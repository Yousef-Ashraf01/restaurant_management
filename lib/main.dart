import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_management/app/app_initializer.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Africa/Cairo'));

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
