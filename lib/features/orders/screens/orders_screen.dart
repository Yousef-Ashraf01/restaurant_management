import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_management/config/routes/app_routes.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/features/auth/state/connectivity_cubit.dart';
import 'package:restaurant_management/features/auth/state/order_cubit.dart';
import 'package:restaurant_management/features/auth/state/order_state.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

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
    tzdata.initializeTimeZones();
    tz.getLocation('Africa/Cairo');
  }

  Future<void> _loadUserId() async {
    final tokenStorage = TokenStorage();
    await tokenStorage.init();
    final id = tokenStorage.getUserId();
    if (id != null && id.isNotEmpty && mounted) {
      setState(() => userId = id);
      Future.microtask(() {
        if (mounted) {
          context.read<OrderCubit>().getUserOrders(id);
        }
      });
    }
  }

  String _getStatusText(String status) {
    final intStatus = int.tryParse(status) ?? 0;
    switch (intStatus) {
      case 0:
        return AppLocalizations.of(context)!.pending;
      case 1:
        return AppLocalizations.of(context)!.accepted;
      case 2:
        return AppLocalizations.of(context)!.preparing;
      case 3:
        return AppLocalizations.of(context)!.ready;
      case 4:
        return AppLocalizations.of(context)!.outForDelivery;
      case 5:
        return AppLocalizations.of(context)!.delivered;
      case 6:
        return AppLocalizations.of(context)!.cancelled;
      default:
        return AppLocalizations.of(context)!.pending;
    }
  }

  Color _getStatusColor(String status) {
    final intStatus = int.tryParse(status) ?? 0;
    switch (intStatus) {
      case 0:
        return Colors.grey.shade400;
      case 1:
        return Colors.blue.shade300;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green.shade400;
      case 4:
        return Colors.blue.shade700;
      case 5:
        return Colors.green.shade800;
      case 6:
        return Colors.red.shade400;
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.grey.shade100,
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
                              "${AppLocalizations.of(context)!.noOrdersYet} 🍔",
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        return SafeArea(
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 20.h,
                            ),
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              final order = orders[index];
                              final egyptTime = order.createdAt.toLocal();
                              final orderDate = DateFormat(
                                'yyyy-MM-dd • hh:mm a',
                              ).format(egyptTime);

                              return Container(
                                margin: EdgeInsets.only(bottom: 12.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  leading: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(
                                        order.status,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.receipt_long,
                                      color: _getStatusColor(order.status),
                                      size: 28,
                                    ),
                                  ),
                                  title: Text(
                                    "${AppLocalizations.of(context)!.order} #${order.id.isNotEmpty ? order.id : '--'}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              size: 14,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                order.fullAddress,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black87,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.access_time,
                                              size: 14,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                orderDate,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(
                                        order.status,
                                      ).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      _getStatusText(order.status),
                                      style: TextStyle(
                                        color: _getStatusColor(order.status),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    final orderCubit =
                                        context.read<OrderCubit>();
                                    await Navigator.pushNamed(
                                      context,
                                      AppRoutes.orderDetailsRoute,
                                      arguments: {'orderId': order.id},
                                    );
                                    if (!mounted || userId == null) return;
                                    orderCubit.getUserOrders(userId!);
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
                            "${AppLocalizations.of(context)!.failedToLoadOrders}\n${state.message}",
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
