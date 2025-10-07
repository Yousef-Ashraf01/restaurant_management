import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/config/routes/app_routes.dart';

import '../network/auth_manager.dart';
import '../network/session_guard.dart';
import '../network/token_storage.dart';

class AuthGuard extends StatefulWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final tokenStorage = context.read<TokenStorage>();
    final dio = Dio(BaseOptions(baseUrl: "https://restaurantmanagementsystem.runasp.net"));
    final authManager = AuthManager(tokenStorage: tokenStorage, dio: dio);
    final guard = SessionGuard(
      tokenStorage: tokenStorage,
      authManager: authManager,
    );
    final isValid = await guard.ensureValidSession();

    if (!isValid && mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.loginRoute, (_) => false);
    } else {
      setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return widget.child;
  }
}
