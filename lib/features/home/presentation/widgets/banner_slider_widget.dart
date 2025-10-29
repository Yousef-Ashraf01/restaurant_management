import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/utils/banner_image_cache.dart';
import 'package:restaurant_management/features/banner/presentation/cubit/banner_cubit.dart';
import 'package:restaurant_management/features/banner/presentation/cubit/banner_state.dart';
import 'package:restaurant_management/features/home/presentation/cubit/dish_cubit.dart';
import 'package:restaurant_management/features/home/presentation/cubit/dish_details_cubit.dart';
import 'package:restaurant_management/features/home/presentation/screens/dish_details_screen.dart';
import 'package:restaurant_management/features/home/presentation/widgets/banner_shimmer.dart';

class BannerSliderWidget extends StatelessWidget {
  const BannerSliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: BlocBuilder<BannerCubit, BannerState>(
          builder: (context, state) {
            if (state is BannerLoading) {
              return const BannerShimmer();
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
                  child: Center(child: Text("No banners found")),
                );
              }

              return CarouselSlider(
                key: const PageStorageKey('banners'),
                options: CarouselOptions(
                  height: 160.h,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.95,
                  autoPlayInterval: const Duration(seconds: 3),
                ),
                items:
                    banners.map((banner) {
                      return GestureDetector(
                        onTap: () {
                          if (banner.linkType == "Dish" &&
                              banner.linkId != null) {
                            final dish = context.read<DishCubit>().getDishById(
                              banner.linkId!,
                            );
                            if (dish != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => BlocProvider(
                                        create: (_) => DishDetailsCubit(dish),
                                        child: DishDetailsScreen(dish: dish),
                                      ),
                                ),
                              );
                            } else {
                              debugPrint(
                                "Dish not found for id ${banner.linkId}",
                              );
                            }
                          } else if (banner.linkType == "Category" &&
                              banner.linkId != null) {
                            context.read<DishCubit>().getDishesByCategory(
                              banner.linkId!.toString(),
                            );
                          } else {
                            debugPrint(
                              "Banner ${banner.name} has no link action",
                            );
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey[200],
                            ),
                            child: Image.memory(
                              BannerImageCache.getImage(
                                banner.id,
                                banner.image,
                              ),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              gaplessPlayback: true,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              );
            }

            return const SizedBox(height: 200);
          },
        ),
      ),
    );
  }
}
