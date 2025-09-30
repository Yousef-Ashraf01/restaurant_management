import 'package:dio/dio.dart';
import 'package:restaurant_management/core/network/token_storage.dart';

class DioClient {
  final Dio dio;
  final TokenStorage tokenStorage;

  DioClient(this.tokenStorage)
    : dio = Dio(
        BaseOptions(baseUrl: "https://restaurantmanagementsystem.runasp.net"),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = tokenStorage.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshToken = tokenStorage.getRefreshToken();

            if (refreshToken != null) {
              try {
                // call refresh endpoint
                final res = await dio.post(
                  "/Auth/Refresh",
                  data: {"refreshToken": refreshToken},
                );

                final newAccess = res.data["accessToken"];
                final newRefresh = res.data["refreshToken"];

                await tokenStorage.saveAccessToken(newAccess);
                await tokenStorage.saveRefreshToken(newRefresh);

                // repeat old request with new token
                final opts = e.requestOptions;
                opts.headers["Authorization"] = "Bearer $newAccess";

                final cloneReq = await dio.fetch(opts);
                return handler.resolve(cloneReq);
              } catch (err) {
                await tokenStorage.clear();
                return handler.reject(e);
              }
            }
          }
          return handler.next(e);
        },
      ),
    );
  }
}
