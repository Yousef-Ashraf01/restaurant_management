import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/core/network/connectivity_cubit.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/features/banner/presentation/cubit/banner_cubit.dart';
import 'package:restaurant_management/features/home/presentation/cubit/category_cubit.dart';
import 'package:restaurant_management/features/home/presentation/cubit/dish_cubit.dart';
import 'package:restaurant_management/features/home/presentation/widgets/banner_slider_widget.dart';
import 'package:restaurant_management/features/home/presentation/widgets/category_section_widget.dart';
import 'package:restaurant_management/features/home/presentation/widgets/dish_grid_section.dart';
import 'package:restaurant_management/features/home/presentation/widgets/home_address_section.dart';
import 'package:restaurant_management/features/home/presentation/widgets/home_app_bar_section.dart';
import 'package:restaurant_management/features/home/presentation/widgets/no_Internet_widget.dart';
import 'package:restaurant_management/features/profile/presentation/cubit/address_cubit.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final bannerCubit = context.read<BannerCubit>();
    final dishCubit = context.read<DishCubit>();
    final categoryCubit = context.read<CategoryCubit>();

    bannerCubit.getBanners();
    categoryCubit.getCategories();

    await _loadUserAddress();

    Future.delayed(const Duration(milliseconds: 500), () {
      dishCubit.getDishes();
    });
  }

  Future<void> _loadUserAddress() async {
    final tokenStorage = TokenStorage();
    await tokenStorage.init();

    final userId = tokenStorage.getUserId();
    debugPrint("Current User ID: $userId");

    if (userId != null) {
      context.read<AddressCubit>().getUserAddresses(userId);
    } else {
      debugPrint("No userId found in TokenStorage");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ConnectivityCubit, bool>(
      builder: (context, isConnected) {
        if (!isConnected) {
          return const NoInternetWidget();
        }

        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                const HomeAppBarSection(),

                const HomeAddressSection(),
                const BannerSliderWidget(),

                CategorySectionWidget(
                  selectedCategoryNotifier: selectedCategoryNotifier,
                ),

                const DishGridSection(),
              ],
            ),
          ),
        );
      },
    );
  }
}
