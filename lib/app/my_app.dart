import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/config/routes/routes_generator.dart';
import 'package:restaurant_management/core/constants/app_theme.dart';
import 'package:restaurant_management/core/widgets/network_listener.dart';
import 'package:restaurant_management/features/auth/state/local_cubit.dart';

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) {
        return BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return ScaffoldMessenger(
              child: NetworkListener(
                showLottieDialogIfOffline: true,
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  onGenerateRoute: RouteGenerator.getRoute,
                  initialRoute: initialRoute,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  locale: locale,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
