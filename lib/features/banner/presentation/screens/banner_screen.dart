import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/utils/image_utils.dart';
import 'package:restaurant_management/features/banner/presentation/cubit/banner_cubit.dart';
import 'package:restaurant_management/features/banner/presentation/cubit/banner_state.dart';

class BannerScreen extends StatelessWidget {
  const BannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<BannerCubit>().getBanners();

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.bannersTitle)),
      body: BlocBuilder<BannerCubit, BannerState>(
        builder: (context, state) {
          if (state is BannerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BannerError) {
            return Center(
              child: Text(
                "${AppLocalizations.of(context)!.error}: ${state.message}",
              ),
            );
          } else if (state is BannerLoaded) {
            final banners = state.banners;
            if (banners.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!.noBannersFound),
              );
            }

            return ListView.builder(
              itemCount: banners.length,
              itemBuilder: (context, index) {
                final banner = banners[index];
                return Card(
                  margin: EdgeInsets.all(10.h),
                  child: Column(
                    children: [
                      Text(banner.name, style: TextStyle(fontSize: 18.sp)),
                      Image.memory(
                        convertBase64ToImage(banner.image),
                        fit: BoxFit.cover,
                        height: 180.h,
                        width: double.infinity,
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Center(
            child: Text(AppLocalizations.of(context)!.waitingForBanners),
          );
        },
      ),
    );
  }
}
