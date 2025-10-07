import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_management/core/network/dio_client.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/core/utils/show_snack_bar.dart';
import 'package:restaurant_management/features/auth/data/datasources/cart_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/models/dish_model.dart';
import 'package:restaurant_management/features/auth/domain/repositories/cart_repository.dart';
import 'package:restaurant_management/features/auth/state/cart_cubit.dart';
import 'package:restaurant_management/features/auth/state/cart_state.dart';
import 'package:restaurant_management/features/auth/state/connectivity_cubit.dart';
import 'package:restaurant_management/features/auth/state/dish_details_cubit.dart';
import 'package:restaurant_management/features/auth/state/dish_details_state.dart';
import 'package:restaurant_management/features/auth/state/local_cubit.dart';
import 'package:restaurant_management/features/home/widgets/bottom_bar.dart';
import 'package:restaurant_management/features/home/widgets/dish_image.dart';
import 'package:restaurant_management/features/home/widgets/dish_info.dart';
import 'package:restaurant_management/features/home/widgets/option_group_widget.dart';
import 'package:restaurant_management/features/home/widgets/quantity_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DishDetailsScreen extends StatelessWidget {
  final DishModel dish;
  const DishDetailsScreen({super.key, required this.dish});

  Future<TokenStorage> _initTokenStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return TokenStorage(prefs);
  }

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
                  const Text(
                    'No internet connection\nPlease connect to the internet',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        return FutureBuilder<TokenStorage>(
          future: _initTokenStorage(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final tokenStorage = snapshot.data!;

            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => DishDetailsCubit(dish)),
                BlocProvider(
                  create:
                      (_) => CartCubit(
                        CartRepository(
                          CartRemoteDataSource(DioClient(tokenStorage)),
                          tokenStorage,
                        ),
                      ),
                ),
              ],
              child: BlocBuilder<LocaleCubit, Locale>(
                builder: (context, locale) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(
                        locale.languageCode == 'en'
                            ? dish.engName
                            : dish.arbName,
                      ),
                      centerTitle: true,
                    ),
                    body: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DishImage(image: dish.image),
                          SizedBox(height: 10.h),
                          DishInfo(
                            name:
                                locale.languageCode == 'en'
                                    ? dish.engName
                                    : dish.arbName,
                            description:
                                locale.languageCode == 'en'
                                    ? dish.engDescription
                                    : dish.arbDescription,
                          ),
                          Divider(
                            color: Colors.black45,
                            indent: 15.w,
                            endIndent: 15.w,
                          ),

                          BlocBuilder<DishDetailsCubit, DishDetailsState>(
                            builder: (context, state) {
                              final cubit = context.read<DishDetailsCubit>();

                              if (dish.optionGroups.isEmpty)
                                return const SizedBox.shrink();

                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      dish.optionGroups.map((group) {
                                        return OptionGroupWidget(
                                          group: group,
                                          isSelected: (option) {
                                            if (group.allowMultiple) {
                                              return (state
                                                          .selectedOptions[group
                                                          .id] ??
                                                      [])
                                                  .contains(option);
                                            }
                                            return state.selectedOptions[group
                                                    .id] ==
                                                option;
                                          },
                                          onOptionSelected: (option) {
                                            cubit.selectOption(
                                              group.id,
                                              option,
                                              allowMultiple:
                                                  group.allowMultiple,
                                            );
                                          },
                                        );
                                      }).toList(),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 10.h),
                          BlocBuilder<DishDetailsCubit, DishDetailsState>(
                            builder: (context, state) {
                              final cubit = context.read<DishDetailsCubit>();
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)!.quantity}:",
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        QuantityButton(
                                          icon: Icons.remove,
                                          onTap:
                                              () => cubit.decrementQuantity(),
                                        ),
                                        SizedBox(width: 10.w),
                                        Text(
                                          "${state.quantity}",
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        QuantityButton(
                                          icon: Icons.add,
                                          onTap:
                                              () => cubit.incrementQuantity(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 60.h),
                        ],
                      ),
                    ),

                    bottomNavigationBar: BlocBuilder<
                      DishDetailsCubit,
                      DishDetailsState
                    >(
                      builder: (context, dishState) {
                        return BlocConsumer<CartCubit, CartState>(
                          listener: (context, state) {
                            if (state is CartSuccess) {
                              showAppSnackBar(
                                context,
                                message:
                                    AppLocalizations.of(
                                      context,
                                    )!.addedToCartSuccessfully,
                                type: SnackBarType.success,
                                duration: const Duration(seconds: 1),
                              );
                            } else if (state is CartFailure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("❌ ${state.message}")),
                              );
                            }
                          },
                          builder: (context, cartState) {
                            return BottomBar(
                              total: dishState.totalPrice,
                              isEnabled:
                                  dishState.isSizeSelected &&
                                  cartState is! CartLoading,
                              onAddToCart: () {
                                if (!isConnected) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("❌ No internet connection"),
                                    ),
                                  );
                                  return;
                                }

                                final selectedOptionsList =
                                    dishState.selectedOptions.values
                                        .where((opt) => opt != null)
                                        .expand(
                                          (opt) => opt is List ? opt : [opt],
                                        )
                                        .map(
                                          (option) => {
                                            "dishOptionId": option.id,
                                          },
                                        )
                                        .toList();

                                final int quantity = dishState.quantity ?? 1;

                                final bodyItems = [
                                  {
                                    "dishId": dish.id,
                                    "quantity": quantity,
                                    "selectedOptions": selectedOptionsList,
                                  },
                                ];

                                context.read<CartCubit>().addToCart(
                                  items: bodyItems,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
