import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/core/utils/image_utils.dart';
import 'package:restaurant_management/features/auth/data/models/dish_model.dart';
import 'package:restaurant_management/features/auth/state/address_cubit.dart';
import 'package:restaurant_management/features/auth/state/address_state.dart';
import 'package:restaurant_management/features/auth/state/banner_cubit.dart';
import 'package:restaurant_management/features/auth/state/banner_state.dart';
import 'package:restaurant_management/features/auth/state/cart_cubit.dart';
import 'package:restaurant_management/features/auth/state/cart_state.dart';
import 'package:restaurant_management/features/auth/state/connectivity_cubit.dart';
import 'package:restaurant_management/features/auth/state/dish_cubit.dart';
import 'package:restaurant_management/features/auth/state/dish_state.dart';
import 'package:restaurant_management/features/home/screens/dish_details_screen.dart';
import 'package:restaurant_management/features/home/widgets/catgeory_section.dart';
import 'package:restaurant_management/features/home/widgets/dish_card.dart';
import 'package:restaurant_management/features/main/screens/main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final ValueNotifier<int> selectedCategoryNotifier = ValueNotifier(0);

  int selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<DishCubit>().getDishes();

    _loadUserAddress();
  }

  Future<void> _loadUserAddress() async {
    final tokenStorage = TokenStorage();
    await tokenStorage.init(); // مهم جدًا تتأكد إنه Initialized

    final userId = tokenStorage.getUserId();
    debugPrint("👤 Current User ID: $userId");

    if (userId != null) {
      context.read<AddressCubit>().getUserAddresses(userId);
    } else {
      debugPrint("⚠ No userId found in TokenStorage");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                /// ======================= HEADER =======================
                SliverPadding(
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

                            if (state is AddressLoaded &&
                                state.addresses.isNotEmpty) {
                              final selectedAddress =
                                  context
                                      .read<AddressCubit>()
                                      .selectedAddress ??
                                  state.addresses.first;
                              addressLabel = selectedAddress.addressLabel ?? "";
                            }

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
                                    text:
                                        addressLabel.isNotEmpty
                                            ? addressLabel
                                            : Localizations.localeOf(
                                                  context,
                                                ).languageCode ==
                                                'en'
                                            ? "Choose address"
                                            : "اختر عنوانك",
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Colors
                                              .deepOrange, // اللون المختلف هنا 🔥
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

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
                                        context
                                            .findAncestorStateOfType<
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
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      transitionBuilder: (
                                        Widget child,
                                        Animation<double> animation,
                                      ) {
                                        // ✅ تأثير ناعم (تكبير وتصغير بسيط)
                                        return ScaleTransition(
                                          scale: animation,
                                          child: child,
                                        );
                                      },
                                      child: Container(
                                        key: ValueKey<int>(
                                          itemCount,
                                        ), // لازم تتغير لما الرقم يتغير
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
                ),

                /// ======================= ADDRESS SECTION =======================
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 12.h,
                    ),
                    child: BlocBuilder<AddressCubit, AddressState>(
                      builder: (context, state) {
                        final addressCubit = context.read<AddressCubit>();
                        Widget addressSection;

                        if (state is AddressLoading) {
                          addressSection = const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is AddressLoaded &&
                            state.addresses.isNotEmpty) {
                          final addresses = state.addresses;
                          final selectedId =
                              addressCubit.selectedAddress?.id ??
                              addresses.first.id;

                          addressSection = Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.15),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(6.w),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFFE5B4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.deepOrange,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedId,
                                      isExpanded: true,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                        color: Colors.black87,
                                      ),
                                      items:
                                          addresses.map((address) {
                                            final label =
                                                address.addressLabel ??
                                                "No label";
                                            final full =
                                                address.fullAddress ??
                                                "No address";
                                            return DropdownMenuItem<String>(
                                              value: address.id,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    label,
                                                    style: TextStyle(
                                                      color: Colors.deepOrange,
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2.h),
                                                  Text(
                                                    full,
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 12.sp,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                      onChanged: (newId) {
                                        final selected = addresses.firstWhere(
                                          (a) => a.id == newId,
                                        );
                                        addressCubit.selectAddress(selected);
                                      },
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (state is AddressError) {
                          addressSection = Text(
                            "Error loading address: ${state.message}",
                            style: const TextStyle(color: Colors.red),
                          );
                        } else {
                          addressSection = Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.location_off,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  "No address found",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return addressSection;
                      },
                    ),
                  ),
                ),

                /// ======================= BANNERS =======================
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 10.h,
                    ),
                    child: BlocBuilder<BannerCubit, BannerState>(
                      builder: (context, state) {
                        if (state is BannerLoading) {
                          return const SizedBox(
                            height: 200,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else if (state is BannerError) {
                          return SizedBox(
                            height: 200,
                            child: Center(
                              child: Text("Error: ${state.message}"),
                            ),
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
                              height:
                                  160.h, // ✅ كبرناها شوية عشان تبان الصورة كاملة
                              autoPlay: true,
                              enlargeCenterPage: true,
                              viewportFraction:
                                  0.95, // ✅ خفّفنا العرض شوية عشان يبقى في margin جميل
                              autoPlayInterval: const Duration(seconds: 3),
                            ),
                            items:
                                banners.map((banner) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color:
                                            Colors
                                                .grey[200], // ✅ خلفية خفيفة لو الصورة ما اتحملت
                                      ),
                                      child: Image.memory(
                                        key: ValueKey(banner.id),
                                        filterQuality: FilterQuality.high,
                                        convertBase64ToImage(banner.image),
                                        fit:
                                            BoxFit
                                                .cover, // 🔥 الأفضل لو الصور فيها نفس الأبعاد
                                        // جرب بدلها بـ BoxFit.contain لو الصور مختلفة الأبعاد
                                        width: double.infinity,
                                        height: double.infinity,
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
                ),

                /// ======================= CATEGORIES =======================
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 15.w,
                      right: 15.w,
                      top: 10.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.categories,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        SizedBox(
                          height: 120.h,
                          child: ValueListenableBuilder<int>(
                            valueListenable: selectedCategoryNotifier,
                            builder: (context, selectedIndex, _) {
                              return CategorySection(
                                selectedCategoryIndex: selectedIndex,
                                onCategorySelected: (index, categoryId) {
                                  selectedCategoryNotifier.value = index;
                                  if (categoryId == 0) {
                                    context.read<DishCubit>().getDishes();
                                  } else {
                                    context
                                        .read<DishCubit>()
                                        .getDishesByCategory(
                                          categoryId.toString(),
                                        );
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// ======================= DISHES =======================
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: 15.w,
                    right: 15.w,
                    bottom: 15.h,
                  ),
                  sliver: BlocBuilder<DishCubit, DishState>(
                    builder: (context, state) {
                      if (state is DishLoading) {
                        return const SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (state is DishLoaded) {
                        final dishes = state.dishes;
                        if (dishes.isEmpty) {
                          // ✅ لو مفيش أطباق في الفئة دي
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 20.h,
                                crossAxisSpacing: 20.w,
                                childAspectRatio: 0.78,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final dish = dishes[index];
                            return DishCard(
                              dish: dish,
                              onAdd: () {
                                if (dish.optionGroups.any(
                                  (g) => g.isRequired,
                                )) {
                                  _showDishOptionsBottomSheet(context, dish);
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
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      backgroundColor: Colors.orange[700],
                                    ),
                                  );
                                }
                              },

                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => DishDetailsScreen(dish: dish),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void _showDishOptionsBottomSheet(BuildContext context, DishModel dish) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      // ✅ نحط المتغير هنا برّا الـ builder علشان ما يتمسحش مع كل setState
      final Map<int, List<int>> selectedOptions = {};

      return StatefulBuilder(
        builder: (context, setState) {
          bool isAllRequiredSelected() {
            return dish.optionGroups.every((g) {
              if (!g.isRequired) return true;
              return selectedOptions[g.id]?.isNotEmpty ?? false;
            });
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  Text(
                    "Customize ${dish.engName}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ✅ option groups
                  ...dish.optionGroups.map((group) {
                    final bool allowMultiple = group.allowMultiple;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              group.engName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (group.isRequired)
                              const Text(
                                " *",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children:
                              group.options.map((option) {
                                final isSelected =
                                    selectedOptions[group.id]?.contains(
                                      option.id,
                                    ) ??
                                    false;

                                return ChoiceChip(
                                  label: Text(
                                    "${option.engName} ${option.price > 0 ? "(+${option.price} EGP)" : ""}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                  selected: isSelected,
                                  selectedColor: const Color(0xFFE65100),
                                  backgroundColor: Colors.grey[200],
                                  onSelected: (_) {
                                    setState(() {
                                      final list =
                                          selectedOptions[group.id] ?? [];

                                      if (allowMultiple) {
                                        if (isSelected) {
                                          list.remove(option.id);
                                        } else {
                                          list.add(option.id);
                                        }
                                      } else {
                                        list
                                          ..clear()
                                          ..add(option.id);
                                      }

                                      selectedOptions[group.id] = list;
                                    });
                                  },
                                );
                              }).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),

                  const SizedBox(height: 12),

                  // ✅ الزرار
                  Builder(
                    builder: (context) {
                      final isReady = isAllRequiredSelected();

                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isReady ? Colors.deepOrange : Colors.grey[400],
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed:
                            isReady
                                ? () {
                                  final selectedOptionIds =
                                      selectedOptions.values
                                          .expand((ids) => ids)
                                          .toList();

                                  // ✅ نعمل التحويل الصح زي ما في DishDetailsScreen
                                  final selectedOptionsList =
                                      selectedOptionIds
                                          .map((id) => {"dishOptionId": id})
                                          .toList();

                                  final bodyItems = [
                                    {
                                      "dishId": dish.id,
                                      "quantity": 1,
                                      "selectedOptions": selectedOptionsList,
                                    },
                                  ];

                                  context.read<CartCubit>().addToCart(
                                    items: bodyItems,
                                  );

                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "${Localizations.localeOf(context).languageCode == 'en' ? dish.engName : dish.arbName} ${AppLocalizations.of(context)!.addedToCart}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      backgroundColor: Colors.orange[700],
                                    ),
                                  );
                                }
                                : null,
                        child: Text(
                          isReady
                              ? AppLocalizations.of(context)!.addToCart
                              : AppLocalizations.of(
                                context,
                              )!.selectRequiredOptions,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
