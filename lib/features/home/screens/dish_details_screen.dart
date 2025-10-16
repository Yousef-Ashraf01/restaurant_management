import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';
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
import 'package:restaurant_management/features/home/widgets/quantity_selector.dart';

class DishDetailsScreen extends StatelessWidget {
  final DishModel dish;
  const DishDetailsScreen({super.key, required this.dish});

  Future<TokenStorage> _initTokenStorage() async {
    final tokenStorage = TokenStorage();
    await tokenStorage.init();
    return tokenStorage;
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
                      backgroundColor: AppColors.accent,
                    ),
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.h),
                            DishImage(image: dish.image),
                            SizedBox(height: 15.h),
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
                            SizedBox(height: 15.h),
                            Divider(color: Colors.grey.shade300, thickness: 1),
                            SizedBox(height: 15.h),

                            /// Option Groups
                            BlocBuilder<DishDetailsCubit, DishDetailsState>(
                              builder: (context, state) {
                                final cubit = context.read<DishDetailsCubit>();
                                if (dish.optionGroups.isEmpty)
                                  return const SizedBox.shrink();

                                return Column(
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
                                );
                              },
                            ),
                            SizedBox(height: 10.h),

                            /// Quantity
                            BlocBuilder<DishDetailsCubit, DishDetailsState>(
                              builder: (context, state) {
                                final cubit = context.read<DishDetailsCubit>();
                                return Row(
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
                                    QuantitySelector(
                                      quantity: state.quantity,
                                      onIncrement: cubit.incrementQuantity,
                                      onDecrement: cubit.decrementQuantity,
                                    ),
                                  ],
                                );
                              },
                            ),

                            SizedBox(height: 60.h),
                          ],
                        ),
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
                                SnackBar(
                                  content: Text(
                                    "${AppLocalizations.of(context)!.error}: ${state.message}",
                                  ),
                                ),
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
