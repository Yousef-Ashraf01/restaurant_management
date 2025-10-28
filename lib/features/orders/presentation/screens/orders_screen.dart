import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/network/connectivity_cubit.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/features/home/presentation/widgets/no_Internet_widget.dart';
import 'package:restaurant_management/features/orders/presentation/cubit/order_cubit.dart';
import 'package:restaurant_management/features/orders/presentation/cubit/order_state.dart';
import 'package:restaurant_management/features/orders/presentation/widgets/empty_orders_widget.dart';
import 'package:restaurant_management/features/orders/presentation/widgets/order_item_card.dart';
import 'package:restaurant_management/features/orders/presentation/widgets/orders_shimmer_list.dart';
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

  String _getStatusText(BuildContext context, String status) {
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
        if (!isConnected) return const NoInternetWidget();

        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          body:
              userId == null
                  ? const OrdersShimmerList()
                  : BlocBuilder<OrderCubit, OrderState>(
                    builder: (context, state) {
                      if (state is OrderLoading) {
                        return const OrdersShimmerList();
                      }

                      if (state is OrderListSuccess) {
                        final orders = List.of(state.orders)..sort(
                          (a, b) => DateTime.parse(
                            b.createdAt.toString(),
                          ).compareTo(DateTime.parse(a.createdAt.toString())),
                        );
                        if (orders.isEmpty) return const EmptyOrdersWidget();

                        return SafeArea(
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 20.h,
                            ),
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              final order = orders[index];
                              final statusColor = _getStatusColor(order.status);
                              final statusText = _getStatusText(
                                context,
                                order.status,
                              );

                              return OrderItemCard(
                                order: order,
                                statusColor: statusColor,
                                statusText: statusText,
                                userId: userId,
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
