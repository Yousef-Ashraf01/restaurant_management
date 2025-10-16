import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';
import 'package:restaurant_management/features/cart/screens/cart_screen.dart';
import 'package:restaurant_management/features/home/screens/home_screen.dart';
import 'package:restaurant_management/features/orders/screens/orders_screen.dart';
import 'package:restaurant_management/features/settings/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<int> _navigationStack = [0];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [
      HomeScreen(),
      OrdersScreen(),
      CartScreen(),
      SettingScreen(),
    ];
  }

  Future<bool> _onWillPop() async {
    if (_navigationStack.length > 1) {
      setState(() {
        _navigationStack.removeLast();
        _selectedIndex =
            _navigationStack.isNotEmpty ? _navigationStack.last : 0;
      });
      return false;
    } else {
      SystemNavigator.pop();
      return false;
    }
  }

  void onTabChange(int index) {
    setState(() {
      if (_navigationStack.isEmpty || _navigationStack.last != index) {
        _navigationStack.add(index);
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
              child: GNav(
                gap: 8,
                activeColor: Colors.white,
                color: Colors.grey[600],
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: AppColors.primary,
                tabs: [
                  GButton(
                    icon: Icons.home,
                    text: AppLocalizations.of(context)!.home,
                  ),
                  GButton(
                    icon: Icons.receipt_long,
                    text: AppLocalizations.of(context)!.orders,
                  ),
                  GButton(
                    icon: Icons.shopping_cart,
                    text: AppLocalizations.of(context)!.cart,
                  ),
                  GButton(
                    icon: Icons.settings,
                    text: AppLocalizations.of(context)!.settings,
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: onTabChange,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
