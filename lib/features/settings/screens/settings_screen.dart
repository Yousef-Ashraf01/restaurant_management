import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/config/routes/app_routes.dart';
import 'package:restaurant_management/features/auth/state/auth_cubit.dart';
import 'package:restaurant_management/features/settings/widgets/list_tile_widget.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 15.h),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 50.h,
                color: Colors.white,
                child: Text(
                  AppLocalizations.of(context)!.settings,
                  style: TextStyle(fontSize: 22.sp),
                ),
              ),
              SizedBox(height: 25.h),
              ListTileWidget(
                onTap: () {
                  final tokenStorage =
                      context
                          .read<AuthCubit>()
                          .repository
                          .tokenStorage;
                  final userId = tokenStorage.getUserId();
                  final token = tokenStorage.getAccessToken();
                  print("$tokenStorage $userId $token");
                  if (userId != null && token != null) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.progileRoute,
                      arguments: {'userId': userId, 'token': token},
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("User not logged in")),
                    );
                  }
                },
                icon: Icons.person,
                title: AppLocalizations.of(context)!.profile,
              ),
              SizedBox(height: 25.h),
              ListTileWidget(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.languageRoute);
                },
                icon: Icons.language,
                title: AppLocalizations.of(context)!.chooseLanguage,
              ),
              SizedBox(height: 25.h),
              ListTileWidget(
                onTap: () {},
                icon: Icons.restaurant,
                title: AppLocalizations.of(context)!.aboutTheRestaurant,
              ),
              const Spacer(),
              ListTileWidget(
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (ctx) =>
                        AlertDialog(
                          title: Text(AppLocalizations.of(context)!
                              .confirm_delete_title),
                          content: Text(
                            AppLocalizations.of(context)!
                                .confirm_delete_content,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: Text(
                                AppLocalizations.of(context)!.cancel,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: Text(
                                AppLocalizations.of(context)!.logout,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                          ],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 20.h,
                          ),
                        ),
                  );
                  if (confirm == true) {
                    final authCubit = context.read<AuthCubit>();
                    final userId =
                    authCubit.repository.tokenStorage.getUserId();
                    if (userId != null) {
                      await authCubit.logout(userId);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.loginRoute,
                            (route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("User not logged in")),
                      );
                    }
                  }
                },
                icon: Icons.logout,
                title: AppLocalizations.of(context)!.logout,
                iconColor: Colors.red[600],
                backgroundAvatar: Colors.red[100],
              ),
              SizedBox(height: 25.h),
            ],
          ),
        ),
      ),
    );
  }
}
