import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:restaurant_management/features/auth/state/address_cubit.dart';
import 'package:restaurant_management/features/auth/state/address_state.dart';
import 'package:restaurant_management/features/auth/state/cart_cubit.dart';
import 'package:restaurant_management/features/auth/state/cart_state.dart';
import 'package:restaurant_management/features/main/screens/main_screen.dart';

class HomeAppBarSection extends StatelessWidget {
  const HomeAppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 10.h),
      sliver: SliverAppBar(
        floating: true,
        snap: true,
        pinned: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<AddressCubit, AddressState>(
              builder: (context, state) {
                String addressLabel = "";

                if (state is AddressLoaded && state.addresses.isNotEmpty) {
                  final selectedAddress =
                      context.read<AddressCubit>().selectedAddress ??
                          state.addresses.first;
                  addressLabel = selectedAddress.addressLabel ?? "";
                }

                final isLoaded =
                    state is AddressLoaded && state.addresses.isNotEmpty;

                return RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                        "${AppLocalizations.of(context)!.deliverTo} ",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(
                        text: isLoaded
                            ? addressLabel
                            : AppLocalizations.of(context)!.loading,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color:
                          isLoaded ? Colors.deepOrange : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            /// 🛒 Cart Icon + Badge
            BlocBuilder<CartCubit, CartState>(
              builder: (context, cartState) {
                int itemCount = 0;
                if (cartState is CartLoaded) {
                  itemCount = cartState.cart.items.fold(
                    0,
                        (total, item) => total + item.quantity,
                  );
                }
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: () {
                        final mainScreenContext =
                        context.findAncestorStateOfType<
                            MainScreenState
                        >();
                        mainScreenContext?.onTabChange(2);
                      },
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.deepOrange,
                        size: 26,
                      ),
                    ),
                    if (itemCount > 0)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                          child: Container(
                            key: ValueKey<int>(itemCount),
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$itemCount',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
