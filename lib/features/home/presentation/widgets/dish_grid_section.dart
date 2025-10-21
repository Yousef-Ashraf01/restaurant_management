import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';
import 'package:restaurant_management/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:restaurant_management/features/home/presentation/cubit/dish_cubit.dart';
import 'package:restaurant_management/features/home/presentation/cubit/dish_state.dart';
import 'package:restaurant_management/features/home/presentation/screens/dish_details_screen.dart';
import 'package:restaurant_management/features/home/presentation/widgets/dish_card.dart';
import 'package:restaurant_management/features/home/presentation/widgets/show_dish_options_bottom_sheet.dart';

class DishGridSection extends StatelessWidget {
  const DishGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.h),
      sliver: BlocBuilder<DishCubit, DishState>(
        builder: (context, state) {
          if (state is DishLoading) {
            return const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (state is DishLoaded) {
            final dishes = state.dishes;

            if (dishes.isEmpty) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      "No dishes found",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              );
            }

            return SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20.h,
                crossAxisSpacing: 20.w,
                childAspectRatio: 0.78,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final dish = dishes[index];

                return DishCard(
                  dish: dish,
                  onAdd: () {
                    if (dish.optionGroups.any((g) => g.isRequired)) {
                      showDishOptionsBottomSheet(context, dish);
                    } else {
                      final cartCubit = context.read<CartCubit>();
                      cartCubit.addSingleItemToCart(
                        cartId: 1,
                        dishId: dish.id,
                        quantity: 1,
                        selectedOptions: [],
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "${Localizations.localeOf(context).languageCode == 'en' ? dish.engName : dish.arbName} ${AppLocalizations.of(context)!.addedToCart}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          duration: const Duration(seconds: 1),
                          backgroundColor: AppColors.accent,
                        ),
                      );
                    }
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DishDetailsScreen(dish: dish),
                      ),
                    );
                  },
                );
              }, childCount: dishes.length),
            );
          }

          return const SliverToBoxAdapter(
            child: Center(child: Text("Waiting for dishes...")),
          );
        },
      ),
    );
  }
}
