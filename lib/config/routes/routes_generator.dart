import 'package:flutter/material.dart';
import 'package:restaurant_management/config/routes/app_routes.dart';
import 'package:restaurant_management/core/widgets/auth_guard.dart';
import 'package:restaurant_management/features/auth/data/models/dish_model.dart';
import 'package:restaurant_management/features/auth/screens/login_screen.dart';
import 'package:restaurant_management/features/auth/screens/new_password_screen.dart';
import 'package:restaurant_management/features/auth/screens/otp_verification_code_screen.dart';
import 'package:restaurant_management/features/auth/screens/sign_up__screen.dart';
import 'package:restaurant_management/features/cart/screens/cart_screen.dart';
import 'package:restaurant_management/features/changePassword/screens/change_password_screen.dart';
import 'package:restaurant_management/features/home/screens/dish_details_screen.dart';
import 'package:restaurant_management/features/language/screens/language_screen.dart';
import 'package:restaurant_management/features/main/screens/main_screen.dart';
import 'package:restaurant_management/features/profile/screens/profile_screen.dart';
import 'package:restaurant_management/features/restaurant_info/screens/restaurant_info_screen.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      // 🟢 شاشات الدخول والتسجيل مفتوحة بدون AuthGuard
      case AppRoutes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.signUpRoute:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

      case AppRoutes.newPasswordRoute:
        return MaterialPageRoute(builder: (_) => const NewPasswordScreen());

      case AppRoutes.otpVerificatonCodeRoute:
        return MaterialPageRoute(
          builder: (_) => const OtpVerificationCodeScreen(),
        );

      case AppRoutes.languageRoute:
        return MaterialPageRoute(builder: (_) => const LanguageScreen());

      // 🔒 باقي الشاشات محمية بـ AuthGuard
      case AppRoutes.mainRoute:
        return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: MainScreen()),
        );

      case AppRoutes.progileRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null ||
            !args.containsKey('userId') ||
            !args.containsKey('token')) {
          return MaterialPageRoute(
            builder:
                (_) => const Scaffold(
                  body: Center(child: Text("User ID or token missing")),
                ),
          );
        }
        return MaterialPageRoute(
          builder:
              (_) => AuthGuard(
                child: ProfileScreen(
                  userId: args['userId'],
                  token: args['token'],
                ),
              ),
        );

      case AppRoutes.changePsswordRoute:
        return MaterialPageRoute(builder: (_) => ChangePasswordScreen());

      case AppRoutes.restaurantInfoRoute:
        return MaterialPageRoute(builder: (_) => RestaurantInfoScreen());

      case AppRoutes.cartRoute:
        return MaterialPageRoute(builder: (_) => CartScreen());

      case AppRoutes.dishDetailsRoute:
        final dish = settings.arguments as DishModel?;
        if (dish == null) {
          return MaterialPageRoute(
            builder:
                (_) =>
                    const Scaffold(body: Center(child: Text("Dish not found"))),
          );
        }
        return MaterialPageRoute(builder: (_) => DishDetailsScreen(dish: dish));

      default:
        return _unDefinedRoute();
    }
  }

  static Route<dynamic> _unDefinedRoute() {
    return MaterialPageRoute(
      builder:
          (_) => const Scaffold(
            body: Center(
              child: Text(
                "No Route Found",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          ),
    );
  }
}
