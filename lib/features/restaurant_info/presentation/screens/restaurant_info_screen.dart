import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_management/core/network/connectivity_cubit.dart';
import 'package:restaurant_management/core/utils/image_utils.dart';
import 'package:restaurant_management/features/language/presentation/cubit/local_cubit.dart';
import 'package:restaurant_management/features/restaurant_info/presentation/cubit/restaurant_cubit.dart';
import 'package:restaurant_management/features/restaurant_info/presentation/cubit/restaurant_state.dart';

class RestaurantInfoScreen extends StatefulWidget {
  const RestaurantInfoScreen({super.key});

  @override
  State<RestaurantInfoScreen> createState() => _RestaurantInfoScreenState();
}

class _RestaurantInfoScreenState extends State<RestaurantInfoScreen> {
  bool _isFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isFetched) {
      context.read<RestaurantCubit>().getRestaurantInfo();
      _isFetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.aboutTheRestaurant),
        centerTitle: true,
        elevation: 1,
      ),
      body: BlocListener<ConnectivityCubit, bool>(
        listener: (context, isConnected) {
          if (isConnected) {
            final state = context.read<RestaurantCubit>().state;
            if (state is RestaurantError || state is RestaurantInitial) {
              context.read<RestaurantCubit>().getRestaurantInfo();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(
                      context,
                    )!.backOnlineFetchingRestaurantInfo,
                  ),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
        },
        child: BlocBuilder<ConnectivityCubit, bool>(
          builder: (context, isConnected) {
            if (!isConnected) {
              return Center(
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }

            return BlocBuilder<RestaurantCubit, RestaurantState>(
              builder: (context, state) {
                if (state is RestaurantLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RestaurantError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.restaurantInfoNotFound,
                          style: TextStyle(fontSize: 18.sp),
                        ),
                      ],
                    ),
                  );
                } else if (state is RestaurantLoaded) {
                  final restaurant = state.restaurant;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (restaurant.logo.isNotEmpty)
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.memory(
                                        convertBase64ToImage(restaurant.logo),
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 12),

                                BlocBuilder<LocaleCubit, Locale>(
                                  builder: (context, locale) {
                                    return Text(
                                      locale.languageCode == 'ar'
                                          ? restaurant.arbName
                                          : restaurant.engName,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 8),

                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      size: 20.sp,
                                      color: Colors.blueGrey,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      restaurant.phoneNumber.isNotEmpty
                                          ? restaurant.phoneNumber
                                          : AppLocalizations.of(
                                            context,
                                          )!.notAvailable,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          AppLocalizations.of(context)!.branches,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: restaurant.branches.length,
                          itemBuilder: (context, index) {
                            final branch = restaurant.branches[index];
                            return BlocBuilder<LocaleCubit, Locale>(
                              builder: (context, locale) {
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.location_on,
                                      color: Colors.redAccent,
                                    ),
                                    title: Text(
                                      locale.languageCode == 'en'
                                          ? branch.engName
                                          : branch.arbName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      locale.languageCode == 'en'
                                          ? "Cairo"
                                          : branch.fullAddress,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }

                return Center(
                  child: Text(AppLocalizations.of(context)!.noDataAvailable),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
