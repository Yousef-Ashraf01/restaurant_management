import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'token_storage.dart';

class DioClient {
  final Dio dio;
  final TokenStorage tokenStorage;

  DioClient(this.tokenStorage)
      : dio = Dio(
    BaseOptions(
      baseUrl: "https://restaurantmanagementsystem.runasp.net",
      headers: {
        'Content-Type': 'application/json', // ✅ هنا ضفنا الـ header
      },
    ),
  ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            // 🔌 تأكد من وجود إنترنت
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

            // 🧩 أضف access token لو موجود
            final accessToken = tokenStorage.getAccessToken();
            if (accessToken != null) {
              options.headers['Authorization'] = 'Bearer $accessToken';
            }

            print("➡️ Request: ${options.method} ${options.uri}");
            handler.next(options);
          } catch (e) {
            print("❌ Request error: $e");
            handler.reject(
              DioException(
                requestOptions: options,
                error: "Session error",
                type: DioExceptionType.unknown,
              ),
            );
          }
        },
        onError: (err, handler) {
          print("❌ Dio error: ${err.message}");
          handler.next(err);
        },
      ),
    );
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

  // 🔌 التحقق من الاتصال بالإنترنت
  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
