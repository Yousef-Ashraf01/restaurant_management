import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart'; // لو هتستخدم Lottie للانيميشن
import 'package:restaurant_management/config/routes/app_routes.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/features/auth/state/connectivity_cubit.dart';
import 'package:restaurant_management/features/auth/state/order_cubit.dart';
import 'package:restaurant_management/features/auth/state/order_state.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String? userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadUserId();
    });
  }


  Future<void> _loadUserId() async {
    debugPrint("🟢 Entered _loadUserId");
    final tokenStorage = TokenStorage();
    await tokenStorage.init();
    debugPrint("🟣 TokenStorage initialized");

    final id = tokenStorage.getUserId();
    debugPrint("🔵 Retrieved userId from prefs: $id");

    if (id != null && id.isNotEmpty && mounted) {
      setState(() => userId = id);
      debugPrint("✅ User ID loaded successfully: $userId");

      // 🔥 استخدم Future.microtask هنا
      Future.microtask(() {
        if (mounted) {
          context.read<OrderCubit>().getUserOrders(id);
        }
      });
    } else {
      debugPrint("⚠️ UserId not found in SharedPreferences");
    }
  }

  String _getStatusText(dynamic status) {
    final value = status.toString().trim();

    switch (value) {
      case "0":
        return AppLocalizations.of(context)!.pending;
      case "1":
        return AppLocalizations.of(context)!.delivered;
      case "2":
        return AppLocalizations.of(context)!.cancelled;
      case "3":
        return AppLocalizations.of(context)!.preparing;
      case "4":
        return AppLocalizations.of(context)!.onTheWay;
      default:
        return AppLocalizations.of(context)!.unknown;
    }
  }

  Color _getStatusColor(dynamic status) {
    final value = status.toString().trim();

    switch (value) {
      case "0":
        return Colors.orange;
      case "1":
        return Colors.green;
      case "2":
        return Colors.red;
      case "3":
        return Colors.blue;
      case "4":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, bool>(
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          body:
          userId == null
              ? const Center(child: CircularProgressIndicator())
              : BlocBuilder<OrderCubit, OrderState>(
            builder: (context, state) {
              if (state is OrderLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is OrderListSuccess) {
                final orders = state.orders;

                if (orders.isEmpty) {
                  return Center(
                    child: Text(
                      "${AppLocalizations.of(context)!.noOrdersYet} 🍔.",
                      style: TextStyle(fontSize: 22.sp),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return SafeArea(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 25.h,
                    ),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final orderDate = DateFormat(
                        'yyyy-MM-dd – hh:mm a',
                      ).format(order.createdAt);

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            radius: 26,
                            backgroundColor: _getStatusColor(
                              order.status,
                            ).withOpacity(0.1),
                            child: Icon(
                              Icons.receipt_long,
                              color: _getStatusColor(order.status),
                              size: 28,
                            ),
                          ),
                          title: Text(
                            "${AppLocalizations.of(context)!.order} #${order.id.isNotEmpty ? order.id : '--'}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.city}: ${order.city}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  "${AppLocalizations.of(context)!.address}: ${order.fullAddress}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "${AppLocalizations.of(context)!.createdAt}: $orderDate",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(
                                order.status,
                              ).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getStatusText(order.status),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _getStatusColor(order.status),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onTap: () async {
                            final orderCubit = context.read<OrderCubit>(); // ✅
                            await Navigator.pushNamed(
                              context,
                              AppRoutes.orderDetailsRoute,
                              arguments: {'orderId': order.id},
                            );

                            if (!mounted || userId == null) return;
                            orderCubit.getUserOrders(userId!); // ✅ آمن 100%
                          },

                        ),
                      );
                    },
                  ),
                );
              }

              if (state is OrderFailure) {
                return Center(
                  child: Text(
                    "❌ Failed to load orders\n${state.message}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        );
      },
    );
  }
}
