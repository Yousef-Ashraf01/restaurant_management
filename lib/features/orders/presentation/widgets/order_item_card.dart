import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_management/config/routes/app_routes.dart';
import 'package:restaurant_management/features/orders/data/models/order_model.dart'; // عدل المسار حسب اسم موديلك
import 'package:restaurant_management/features/orders/presentation/cubit/order_cubit.dart';

class OrderItemCard extends StatelessWidget {
  final OrderModel order;
  final Color statusColor;
  final String statusText;
  final String? userId;

  const OrderItemCard({
    super.key,
    required this.order,
    required this.statusColor,
    required this.statusText,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final utcTime = DateTime.parse(order.createdAt.toString());
    final egyptTime = utcTime.add(const Duration(hours: 3));
    final formattedDate = DateFormat('yyyy-MM-dd • hh:mm a').format(egyptTime);

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
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.receipt_long, color: statusColor, size: 28),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
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
                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      formattedDate,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () async {
          final orderCubit = context.read<OrderCubit>();
          await Navigator.pushNamed(
            context,
            AppRoutes.orderDetailsRoute,
            arguments: {'orderId': order.id},
          );
          if (userId != null) {
            orderCubit.getUserOrders(userId!);
          }
        },
      ),
    );
  }
}
