import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';
import 'package:restaurant_management/core/utils/image_utils.dart';
import 'package:restaurant_management/features/auth/state/banner_cubit.dart';
import 'package:restaurant_management/features/auth/state/banner_state.dart';
import 'package:restaurant_management/features/auth/state/connectivity_cubit.dart';
import 'package:restaurant_management/features/auth/state/dish_cubit.dart';
import 'package:restaurant_management/features/auth/state/dish_state.dart';
import 'package:restaurant_management/features/auth/state/local_cubit.dart';
import 'package:restaurant_management/features/home/screens/dish_details_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, bool>(
      builder: (context, isConnected) {
        if (!isConnected) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: Lottie.asset(
                      'assets/animations/noInternetConnection.json',
                    ),
                  ),
                  const SizedBox(height: 12),
                   Text(
                    AppLocalizations.of(context)!.noInternetConnection,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner Carousel
                  BlocBuilder<BannerCubit, BannerState>(
                    builder: (context, state) {
                      if (state is BannerLoading) {
                        return const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (state is BannerError) {
                        return SizedBox(
                          height: 200,
                          child: Center(child: Text("Error: ${state.message}")),
                        );
                      } else if (state is BannerLoaded) {
                        final banners = state.banners;
                        if (banners.isEmpty) {
                          return const SizedBox(
                            height: 200,
                            child: Center(child: Text("No Banners Found")),
                          );
                        }

                        return CarouselSlider(
                          options: CarouselOptions(
                            height: 125.h,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 1.0,
                            aspectRatio: 16 / 9,
                            autoPlayInterval: const Duration(seconds: 3),
                          ),
                          items:
                          banners.map((banner) {
                            return Builder(
                              builder: (BuildContext context) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.memory(
                                    convertBase64ToImage(banner.image),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        );
                      }
                      return const SizedBox(
                        height: 200,
                        child: Center(child: Text("Waiting for banners...")),
                      );
                    },
                  ),

                  SizedBox(height: 20.h),

                  // Dishes Horizontal List
                  Text(
                    AppLocalizations.of(context)!.dishes,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Expanded(
                    child: BlocBuilder<DishCubit, DishState>(
                      builder: (context, state) {
                        if (state is DishLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is DishError) {
                          return Center(child: Text("Error: ${state.message}"));
                        } else if (state is DishLoaded) {
                          final dishes = state.dishes;
                          if (dishes.isEmpty) {
                            return const Center(child: Text("No Dishes Found"));
                          }

                          return ListView.separated(
                            itemCount: dishes.length,
                            separatorBuilder: (_, __) => SizedBox(height: 10.h),
                            itemBuilder: (context, index) {
                              final dish = dishes[index];
                              return GestureDetector(
                                onTap:
                                isConnected
                                    ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) =>
                                          DishDetailsScreen(
                                            dish: dish,
                                          ),
                                    ),
                                  );
                                }
                                    : () {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "❌ No internet connection",
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 70.w,
                                        height: 70.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          image: DecorationImage(
                                            image:
                                            (dish.image.isNotEmpty &&
                                                dish.image != "null")
                                                ? MemoryImage(
                                              convertBase64ToImage(
                                                dish.image,
                                              ),
                                            )
                                                : const AssetImage(
                                              "assets/images/logo1.jpg",
                                            )
                                            as ImageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15.w),
                                      Expanded(
                                        child: BlocBuilder<
                                            LocaleCubit,
                                            Locale>(
                                          builder: (context, locale) {
                                            return Text(
                                              locale.languageCode == 'en' ? dish
                                                  .engName : dish.arbName,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 2.w),
                                        width: 25.w,
                                        height: 25.w,
                                        decoration: BoxDecoration(
                                          color: AppColors.accent,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        return const Center(
                          child: Text("Waiting for dishes..."),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
