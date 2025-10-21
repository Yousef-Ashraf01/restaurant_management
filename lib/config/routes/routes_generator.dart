import 'package:flutter/material.dart';
import 'package:restaurant_management/config/routes/app_routes.dart';
import 'package:restaurant_management/features/auth/presentation/screens/login_screen.dart';
import 'package:restaurant_management/features/auth/presentation/screens/new_password_screen.dart';
import 'package:restaurant_management/features/auth/presentation/screens/otp_verification_code_screen.dart';
import 'package:restaurant_management/features/auth/presentation/screens/sign_up__screen.dart';
import 'package:restaurant_management/features/cart/presentation/screens/cart_screen.dart';
import 'package:restaurant_management/features/changePassword/presentation/screens/change_password_screen.dart';
import 'package:restaurant_management/features/confirm_email/presentation/screens/confirm_email_screen.dart';
import 'package:restaurant_management/features/home/data/models/dish_model.dart';
import 'package:restaurant_management/features/home/presentation/screens/dish_details_screen.dart';
import 'package:restaurant_management/features/language/presentation/screens/language_screen.dart';
import 'package:restaurant_management/features/main/screens/main_screen.dart';
import 'package:restaurant_management/features/orders/presentation/screens/order_details_screen.dart';
import 'package:restaurant_management/features/orders/presentation/screens/orders_screen.dart';
import 'package:restaurant_management/features/profile/presentation/screens/profile_screen.dart';
import 'package:restaurant_management/features/restaurant_info/presentation/screens/restaurant_info_screen.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.signUpRoute:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

      case AppRoutes.newPasswordRoute:
        return MaterialPageRoute(builder: (_) => const NewPasswordScreen());

      case AppRoutes.confirmEmailRoute:
        return MaterialPageRoute(builder: (_) => const ConfirmEmailScreen());

      case AppRoutes.otpVerificatonCodeRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || !args.containsKey('userId')) {
          return MaterialPageRoute(
            builder:
                (_) => const Scaffold(
                  body: Center(child: Text("User ID is missing")),
                ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => OtpVerificationCodeScreen(userId: args['userId']),
        );

      case AppRoutes.languageRoute:
        return MaterialPageRoute(builder: (_) => const LanguageScreen());

      case AppRoutes.mainRoute:
        return MaterialPageRoute(builder: (_) => MainScreen());

      case AppRoutes.profileRoute:
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
              (context) =>
                  ProfileScreen(userId: args['userId'], token: args['token']),
        );

      case AppRoutes.changePsswordRoute:
        return MaterialPageRoute(builder: (_) => ChangePasswordScreen());

      case AppRoutes.restaurantInfoRoute:
        return MaterialPageRoute(builder: (_) => RestaurantInfoScreen());

      case AppRoutes.ordersRoute:
        return MaterialPageRoute(builder: (_) => OrdersScreen());

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
      case AppRoutes.orderDetailsRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || !args.containsKey('orderId')) {
          return MaterialPageRoute(
            builder:
                (_) => const Scaffold(
                  body: Center(child: Text("Order ID is missing")),
                ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => OrderDetailsScreen(orderId: args['orderId']),
        );

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
