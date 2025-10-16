import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import 'token_storage.dart';

class DioClient {
  static DioClient? _instance;
  final TokenStorage tokenStorage;
  final Dio dio;
  final Dio _refreshDio;
  final CookieJar _cookieJar = CookieJar();
  final void Function()? onLogout;
  Completer<void>? _refreshCompleter;

  factory DioClient(TokenStorage tokenStorage, {void Function()? onLogout}) {
    _instance ??= DioClient._internal(tokenStorage, onLogout: onLogout);
    return _instance!;
  }

  // https://elasalaelmasriaapi.runasp.net
  // https://restaurantmanagementsystem.runasp.net
  // https://restaurantmanagementsystemapi.runasp.net

  DioClient._internal(this.tokenStorage, {this.onLogout})
    : dio = Dio(
        BaseOptions(
          baseUrl: "https://elasalaelmasriaapi.runasp.net",
          headers: {'Content-Type': 'application/json'},
          validateStatus: (_) => true,
        ),
      ),
      _refreshDio = Dio(
        BaseOptions(
          baseUrl: "https://elasalaelmasriaapi.runasp.net",
          headers: {'Content-Type': 'application/json'},
          validateStatus: (_) => true,
        ),
      ) {
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    dio.interceptors.add(CookieManager(_cookieJar));
    _refreshDio.interceptors.add(CookieManager(_cookieJar));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final isOnline = await _hasInternet();
            if (!isOnline) {
              return handler.reject(
                DioException(
                  requestOptions: options,
                  error: "No internet connection",
                  type: DioExceptionType.connectionError,
                ),
              );
            }

            final isRefreshPath = options.path.contains(
              "/api/Auth/refreshToken",
            );

            if (!isRefreshPath) {
              final accessExpiry = await tokenStorage.getAccessExpiry();
              final refreshExpiry = await tokenStorage.getRefreshExpiry();
              final now = DateTime.now().toUtc();
              print("🕒 Check Expiration");
              print("🕒 Now: $now");
              print("📌 Saved Access Expiry: $accessExpiry");
              print("📌 Saved Refresh Expiry: $refreshExpiry");
              print("Direct try refrsh");
              print("After direct refresh");
              if (accessExpiry != null && accessExpiry.isBefore(now)) {
                if (refreshExpiry != null && refreshExpiry.isAfter(now)) {
                  print("refresh is valid, try refresh...");
                  final refreshed = await _tryRefresh();
                  print("try refresh called and finished");
                  print(refreshed);
                  if (!refreshed) {
                    return handler.reject(
                      DioException(
                        requestOptions: options,
                        error: "Session expired - please login again",
                        type: DioExceptionType.cancel,
                      ),
                    );
                  }
                } else {
                  await _forceLogoutAndReject(
                    DioException(
                      requestOptions: options,
                      error: "Session expired - please login again",
                      type: DioExceptionType.cancel,
                    ),
                    ErrorInterceptorHandler(),
                  );
                  return;
                }
              }

              final accessToken = await tokenStorage.getAccessToken();
              if (accessToken != null && accessToken.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $accessToken';
              }
            } else {
              final refreshToken = await tokenStorage.getRefreshToken();
              if (refreshToken != null && refreshToken.isNotEmpty) {
                options.headers['Cookie'] = 'RefreshToken=$refreshToken';
              }
              options.headers.remove('Authorization');
            }

            handler.next(options);
          } catch (e) {
            handler.reject(
              DioException(
                requestOptions: options,
                error: "Session error",
                type: DioExceptionType.unknown,
              ),
            );
          }
        },
        onError: (err, handler) async {
          final reqOptions = err.requestOptions;
          final isRefreshRequest = reqOptions.path.contains(
            "/api/Auth/refreshToken",
          );

          if (err.response?.statusCode == 401 && !isRefreshRequest) {
            try {
              if (_refreshCompleter != null) {
                await _refreshCompleter!.future;
              } else {
                _refreshCompleter = Completer<void>();
                final refreshed = await _tryRefresh();
                if (!refreshed) {
                  await _forceLogoutAndReject(err, handler);
                  _refreshCompleter!.completeError("Refresh failed");
                  return;
                }
                _refreshCompleter!.complete();
              }

              final newAccess = await tokenStorage.getAccessToken();
              if (newAccess != null) {
                reqOptions.headers['Authorization'] = 'Bearer $newAccess';
              }
              final retryResponse = await dio.fetch(reqOptions);
              print("newAccess $newAccess");
              return handler.resolve(retryResponse);
            } catch (e) {
              await _forceLogoutAndReject(err, handler);
              return;
            } finally {
              _refreshCompleter = null;
            }
          }

          handler.next(err);
        },
      ),
    );
  }

  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> post(String path, {dynamic data, Options? options}) async {
    return await dio.post(path, data: data, options: options);
  }

  Future<Response> put(String path, {dynamic data, Options? options}) async {
    return await dio.put(path, data: data, options: options);
  }

  Future<Response> delete(String path, {dynamic data, Options? options}) async {
    return await dio.delete(path, data: data, options: options);
  }

  Future<bool> _tryRefresh() async {
    final refreshToken = await tokenStorage.getRefreshToken();
    print("🔁 Current refresh token: $refreshToken");

    if (refreshToken == null || refreshToken.isEmpty) return false;

    try {
      print(
        '🔍 Sending refresh request with cookie: RefreshToken=$refreshToken',
      );
      final res = await _refreshDio.get(
        "/api/Auth/refreshToken",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': 'RefreshToken=$refreshToken',
          },
        ),
      );

      print("🔁 Refresh response: ${res.data}");

      if (res.data == null || res.data['data'] == null) {
        print("❌ Invalid response format");
        return false;
      }

      // ✅ Parse & save new tokens
      final tokens = res.data['data'];
      final newAccessToken = tokens['accessToken'] as String?;
      final newRefreshToken = tokens['refreshToken'] as String?;
      final newAccessExpiry =
          tokens['expiresIn'] != null
              ? DateTime.parse(tokens['expiresIn']).toUtc()
              : null;
      final newRefreshExpiry =
          tokens['refreshTokenExpiration'] != null
              ? DateTime.parse(tokens['refreshTokenExpiration']).toUtc()
              : null;

      if (newAccessToken == null || newRefreshToken == null) {
        print("❌ Missing new token values");
        return false;
      }

      // ✅ Save synchronously & wait
      await tokenStorage.saveAccessToken(newAccessToken);
      await tokenStorage.saveRefreshToken(newRefreshToken);
      await tokenStorage.saveAccessExpiry(newAccessExpiry);
      await tokenStorage.saveRefreshExpiry(newRefreshExpiry);

      print("✅ Tokens updated successfully");
      print("🕒 Access expires: $newAccessExpiry");
      print("🔁 Refresh expires: $newRefreshExpiry");

      return true;
    } catch (e) {
      print("❌ Token refresh failed: $e");
      return false;
    }
  }

  Future<_TokenParseResult> _parseTokenResponse(Response response) async {
    final data = response.data;

    if (data == null || data['data'] == null) {
      throw Exception("❌ Invalid token refresh response: missing data");
    }

    final tokens = data['data'];

    final accessToken = tokens['accessToken'] as String?;
    final refreshToken = tokens['refreshToken'] as String?;
    final accessTokenExpiration = tokens['expiresIn'] as String?;
    final refreshTokenExpiration = tokens['refreshTokenExpiration'] as String?;

    if (accessToken == null || refreshToken == null) {
      throw Exception("❌ Missing token values in response");
    }

    final accessExpiry =
        accessTokenExpiration != null
            ? DateTime.parse(accessTokenExpiration).toUtc()
            : null;

    final refreshExpiry =
        refreshTokenExpiration != null
            ? DateTime.parse(refreshTokenExpiration).toUtc()
            : null;

    print("parseToenResponse");
    print("🕒 Now: ${DateTime.now}");
    print("📌 Saved Access Expiry: $accessExpiry");
    print("📌 Saved Refresh Expiry: $refreshExpiry");

    await tokenStorage.saveAccessToken(accessToken);
    await tokenStorage.saveRefreshToken(refreshToken);

    if (accessExpiry != null) {
      await tokenStorage.saveAccessExpiry(accessExpiry);
    }

    if (refreshExpiry != null) {
      await tokenStorage.saveRefreshExpiry(refreshExpiry);
    }

    print("✅ Tokens updated successfully!");
    print("🕒 Access expires: $accessExpiry");
    print("🔁 Refresh expires: $refreshExpiry");

    return _TokenParseResult(
      accessToken: accessToken,
      refreshToken: refreshToken,
      accessExpiry: accessExpiry,
      refreshExpiry: refreshExpiry,
    );
  }

  Future<void> _forceLogoutAndReject(
    DioException sourceErr,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      await tokenStorage.clear();
    } catch (_) {}
    if (onLogout != null) {
      try {
        onLogout!();
      } catch (_) {}
    }

    handler.reject(
      DioException(
        requestOptions: sourceErr.requestOptions,
        error: "Session expired - please login again",
        type: DioExceptionType.cancel,
      ),
    );
  }
}

class _TokenParseResult {
  final String? accessToken;
  final String? refreshToken;
  final DateTime? accessExpiry;
  final DateTime? refreshExpiry;

  _TokenParseResult({
    this.accessToken,
    this.refreshToken,
    this.accessExpiry,
    this.refreshExpiry,
  });
}
