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

  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  factory DioClient(TokenStorage tokenStorage, {void Function()? onLogout}) {
    _instance ??= DioClient._internal(tokenStorage, onLogout: onLogout);
    return _instance!;
  }

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
              final accessExpiry = tokenStorage.getAccessExpiry();
              final refreshExpiry = tokenStorage.getRefreshExpiry();
              final now = DateTime.now().toUtc();

              print("🕒 Checking token expiry...");
              print("Now: $now");
              print("Access Expiry: $accessExpiry");
              print("Refresh Expiry: $refreshExpiry");

              // هنا خليه يشيّك فعلي مش دايمًا true
              if (accessExpiry != null && accessExpiry.isBefore(now)) {
                if (refreshExpiry != null && refreshExpiry.isAfter(now)) {
                  print("🔄 Access expired, trying to refresh...");
                  final refreshed = await _refreshTokenIfNeeded();
                  if (!refreshed) {
                    return _forceLogoutAndRejectRequest(
                      DioException(
                        requestOptions: options,
                        error: "Session expired - please login again",
                        type: DioExceptionType.cancel,
                      ),
                      handler,
                    );
                  }
                } else {
                  return _forceLogoutAndRejectRequest(
                    DioException(
                      requestOptions: options,
                      error: "Session expired - please login again",
                      type: DioExceptionType.cancel,
                    ),
                    handler,
                  );
                }
              }

              final accessToken = tokenStorage.getAccessToken();
              if (accessToken != null && accessToken.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $accessToken';
              }
            } else {
              // Refresh request
              final refreshToken = tokenStorage.getRefreshToken();
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
                error: "Request interceptor failed",
                type: DioExceptionType.unknown,
              ),
            );
          }
        },
        onError: (err, handler) async {
          final req = err.requestOptions;
          final isRefresh = req.path.contains("/api/Auth/refreshToken");

          if (err.response?.statusCode == 401 && !isRefresh) {
            print("⚠ 401 detected, trying refresh...");
            try {
              final refreshed = await _refreshTokenIfNeeded();
              if (!refreshed) {
                return _forceLogoutAndRejectError(err, handler);
              }

              final newAccess = tokenStorage.getAccessToken();
              if (newAccess != null) {
                req.headers['Authorization'] = 'Bearer $newAccess';
              }

              final retryResponse = await dio.fetch(req);
              return handler.resolve(retryResponse);
            } catch (e) {
              return _forceLogoutAndRejectError(err, handler);
            }
          }

          handler.next(err);
        },
      ),
    );
  }

  // -------------------- Public methods --------------------

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

  // -------------------- Refresh Logic --------------------

  Future<bool> _refreshTokenIfNeeded() async {
    if (_isRefreshing) {
      print("🕓 Waiting for ongoing refresh to finish...");
      await _refreshCompleter?.future;
      return true;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer();

    try {
      final success = await _tryRefresh();
      if (success) {
        print("✅ Refresh completed successfully");
        _refreshCompleter?.complete();
        return true;
      } else {
        _refreshCompleter?.completeError("Refresh failed");
        return false;
      }
    } catch (e) {
      _refreshCompleter?.completeError(e);
      return false;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  Future<bool> _tryRefresh() async {
    final refreshToken = tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return false;

    print("🔁 Trying refresh with token: $refreshToken");

    try {
      final res = await _refreshDio.get(
        "/api/Auth/refreshToken",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': 'RefreshToken=$refreshToken',
          },
        ),
      );

      if (res.statusCode == 200 && res.data != null) {
        final data = res.data['data'];
        if (data == null) return false;

        final newAccess = data['accessToken'] as String?;
        final newRefresh = data['refreshToken'] as String?;
        final expiresIn = data['expiresIn'] as String?;
        final refreshExpires = data['refreshTokenExpiration'] as String?;

        if (newAccess == null || newRefresh == null) return false;

        await tokenStorage.saveAccessToken(newAccess);
        await tokenStorage.saveRefreshToken(newRefresh);

        if (expiresIn != null) {
          await tokenStorage.saveAccessExpiry(
            DateTime.parse(expiresIn).toUtc(),
          );
        }
        if (refreshExpires != null) {
          await tokenStorage.saveRefreshExpiry(
            DateTime.parse(refreshExpires).toUtc(),
          );
        }

        print("✅ Token refreshed successfully!");
        return true;
      } else {
        print("❌ Refresh failed: ${res.statusCode}");
        return false;
      }
    } catch (e) {
      print("❌ Exception during refresh: $e");
      return false;
    }
  }

  // -------------------- Helpers --------------------

  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> _forceLogoutAndRejectRequest(
    DioException sourceErr,
    RequestInterceptorHandler handler,
  ) async {
    await tokenStorage.clear();
    if (onLogout != null) onLogout!();
    handler.reject(
      DioException(
        requestOptions: sourceErr.requestOptions,
        error: "Session expired - please login again",
        type: DioExceptionType.cancel,
      ),
    );
  }

  Future<void> _forceLogoutAndRejectError(
    DioException sourceErr,
    ErrorInterceptorHandler handler,
  ) async {
    await tokenStorage.clear();
    if (onLogout != null) onLogout!();
    handler.reject(
      DioException(
        requestOptions: sourceErr.requestOptions,
        error: "Session expired - please login again",
        type: DioExceptionType.cancel,
      ),
    );
  }
}
