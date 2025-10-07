// import 'package:dio/dio.dart';
// import 'package:restaurant_management/core/network/token_storage.dart';
//
// class TokenManager {
//   final Dio dio;
//   final TokenStorage tokenStorage;
//   bool _isRefreshing = false;
//
//   TokenManager(this.tokenStorage)
//     : dio = Dio(
//         BaseOptions(baseUrl: "https://restaurantmanagementsystem.runasp.net"),
//       );
//
//   /// ✅ يتحقق من صلاحية التوكن ويجددها لو أمكن
//   Future<bool> checkAndRefreshTokens() async {
//     final accessToken = await tokenStorage.getAccessToken();
//     final refreshToken = await tokenStorage.getRefreshToken();
//     final accessExpiryStr = await tokenStorage.getAccessExpiry();
//     final refreshExpiryStr = await tokenStorage.getRefreshExpiry();
//
//     if (accessToken == null ||
//         refreshToken == null ||
//         accessExpiryStr == null ||
//         refreshExpiryStr == null) {
//       print("🚫 Missing tokens or expiry dates → logout required");
//       await tokenStorage.clear();
//       return false;
//     }
//
//     final now = DateTime.now().toUtc();
//     late DateTime accessExpiry;
//     late DateTime refreshExpiry;
//
//     try {
//       accessExpiry = DateTime.parse(accessExpiryStr).toUtc();
//       refreshExpiry = DateTime.parse(refreshExpiryStr).toUtc();
//     } catch (e) {
//       print("⚠️ Invalid date format → forcing logout");
//       await tokenStorage.clear();
//       return false;
//     }
//
//     if (accessExpiry.isAfter(now)) {
//       print("✅ Access token still valid");
//       return true;
//     }
//
//     if (refreshExpiry.isAfter(now)) {
//       if (_isRefreshing) {
//         print("⚠️ Refresh already in progress");
//         return true;
//       }
//
//       _isRefreshing = true;
//       try {
//         print("🔄 Refreshing access token...");
//         final res = await dio.get(
//           "/api/Auth/refreshToken",
//           options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
//         );
//
//         final data = res.data['data'];
//         if (data == null) throw Exception("Invalid refresh response");
//
//         await tokenStorage.saveTokens(
//           data['accessToken'],
//           data['refreshToken'],
//           data['expiresIn'],
//           data['refreshTokenExpiration'],
//         );
//
//         print("✅ Tokens refreshed successfully");
//         _isRefreshing = false;
//         return true;
//       } catch (e) {
//         print("❌ Refresh failed: $e");
//         await tokenStorage.clear();
//         _isRefreshing = false;
//         return false;
//       }
//     }
//
//     print("🚫 Both tokens expired → logout");
//     await tokenStorage.clear();
//     return false;
//   }
// }
