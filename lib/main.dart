import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_management/app/app_initializer.dart';
import 'package:restaurant_management/core/network/token_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final tokenStorage = TokenStorage();
  await tokenStorage.init();

  final accessToken = tokenStorage.getAccessToken();

  runApp(
    Provider<TokenStorage>(
      create: (_) => tokenStorage,
      child: MyAppInitializer(accessToken: accessToken),
    ),
  );
}
