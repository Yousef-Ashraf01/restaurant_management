// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'token_manager.dart';
//
// class AuthInterceptor extends Interceptor {
//   final TokenManager tokenManager;
//
//   AuthInterceptor(this.tokenManager);
//
//   @override
//   Future<void> onRequest(
//     RequestOptions options,
//     RequestInterceptorHandler handler,
//   ) async {
//     // ✅ تحقق أولًا من صلاحية التوكن
//     final isValid = await tokenManager.checkAndRefreshTokens();
//
//     if (!isValid) {
//       print("🚫 Tokens invalid → redirect to login");
//       handler.reject(
//         DioException(
//           requestOptions: options,
//           type: DioExceptionType.cancel,
//           error: "SessionExpired",
//         ),
//       );
//       return;
//     }
//
//     // ✅ لو صالح، ضيف التوكن للـ headers
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('accessToken');
//
//     if (token != null) {
//       options.headers['Authorization'] = 'Bearer $token';
//     }
//
//     return handler.next(options);
//   }
//
//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     // لو السيرفر رجّع Unauthorized بعد التحديث → نعتبرها جلسة منتهية
//     if (err.response?.statusCode == 401) {
//       print("⚠️ Unauthorized → clearing tokens");
//       tokenManager.checkAndRefreshTokens(); // مجرد تأكيد
//     }
//
//     handler.next(err);
//   }
// }
