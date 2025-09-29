import 'package:flutter/material.dart';
import 'package:restaurant_management/config/routes/app_routes.dart';
import 'package:restaurant_management/features/auth/screens/login_screen.dart';
import 'package:restaurant_management/features/auth/screens/sign_up__screen.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.signUpRoute:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

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
