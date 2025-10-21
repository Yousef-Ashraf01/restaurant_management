import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';
import 'package:restaurant_management/core/utils/image_utils.dart';
import 'package:restaurant_management/features/auth/state/local_cubit.dart';
import 'package:restaurant_management/features/auth/state/order_cubit.dart';
import 'package:restaurant_management/features/auth/state/order_state.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderCubit>().getOrderDetails(widget.orderId);
  }

  String _getStatusText(int status) {
    final loc = AppLocalizations.of(context)!;
    switch (status) {
      case 0:
        return loc.pending;
      case 1:
        return loc.accepted;
      case 2:
        return loc.preparing;
      case 3:
        return loc.ready;
      case 4:
        return loc.outForDelivery;
      case 5:
        return loc.delivered;
      case 6:
        return loc.cancelled;
      default:
        return loc.pending;
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.grey.shade400; // رمادي فاتح
      case 1:
        return Colors.blue.shade300; // أزرق سماوي
      case 2:
        return Colors.orange; // برتقالي
      case 3:
        return Colors.green.shade400; // أخضر فاتح
      case 4:
        return Colors.blue.shade700; // أزرق داكن
      case 5:
        return Colors.green.shade800; // أخضر غامق
      case 6:
        return Colors.red.shade400; // أحمر
      default:
        return Colors.grey; // افتراضي
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text("${loc.order} #${widget.orderId}"),
        centerTitle: true,
        elevation: 2,
        backgroundColor: AppColors.accent,
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderDetailsSuccess) {
            final order = state.order;
            final egyptTime = order.date.toLocal();
            final formattedDate = DateFormat(
              'yyyy-MM-dd – hh:mm a',
            ).format(egyptTime);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🟢 Order Status
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.assignment_turned_in,
                            size: 28,
                            color: _getStatusColor(order.status),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc.orderStatus,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                      order.status,
                                    ).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _getStatusText(order.status),
                                    style: TextStyle(
                                      color: _getStatusColor(order.status),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🏠 Delivery Address
                  Text(
                    loc.deliveryAddress,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                color: Colors.redAccent,
                                size: 26,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                order.fullAddress,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Divider(color: Colors.grey[300]),
                          const SizedBox(height: 10),
                          _buildAddressRow(
                            Icons.apartment,
                            loc.building,
                            order.buildingName,
                          ),
                          _buildAddressRow(
                            Icons.stairs,
                            loc.floor,
                            "${order.floor}",
                          ),
                          _buildAddressRow(
                            Icons.meeting_room,
                            loc.apartment,
                            "${order.apartmentNo}",
                          ),
                          _buildAddressRow(
                            Icons.location_city,
                            loc.city,
                            order.city,
                          ),
                          if (order.additionalDirections.isNotEmpty)
                            _buildAddressRow(
                              Icons.map_outlined,
                              loc.additionalDirections,
                              order.additionalDirections,
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🍽 Order Items
                  Text(
                    loc.orderItems,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    child: Column(
                      children:
                          order.items.map((item) {
                            final dish = item.dish;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 8,
                                  ),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.memory(
                                      convertBase64ToImage(dish!.image ?? ''),
                                      width: 55,
                                      height: 55,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                            Icons.fastfood,
                                            size: 40,
                                            color: Colors.orange[600],
                                          ),
                                    ),
                                  ),
                                  title: BlocBuilder<LocaleCubit, Locale>(
                                    builder: (context, locale) {
                                      return Text(
                                        locale.languageCode == 'en'
                                            ? dish.engName
                                            : dish.arbName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      );
                                    },
                                  ),
                                  subtitle: Text("x${item.quantity}"),
                                  trailing: Text(
                                    "${item.totalPrice.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),

                                // 🟡 ملاحظات العنصر (لو موجودة)
                                if (item.notes != null &&
                                    item.notes!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                      bottom: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // 🔹 العنوان "Notes"
                                        Text(
                                          AppLocalizations.of(context)!.notes,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.orange.shade700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),

                                        // 🔹 نص الملاحظة
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.notes_rounded,
                                              color: Colors.grey,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                item.notes!,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black54,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                if (item != order.items.last)
                                  Divider(color: Colors.grey[200], height: 1),
                              ],
                            );
                          }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 💵 Order Summary
                  Text(
                    loc.orderSummary,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // 🧮 Subtotal
                          _buildSummaryRow(
                            "${loc.subtotal}:",
                            order.totalPrice.toStringAsFixed(2),
                          ),
                          const SizedBox(height: 8),

                          _buildSummaryRow(
                            "${loc.deliveryFees}:",
                            order.deliveryFees.toStringAsFixed(2),
                          ),
                          const Divider(height: 20),


                          // 💰 Total
                          _buildSummaryRow(
                            "${loc.total}:",
                            order.orderTotal.toStringAsFixed(2),
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 25.h),

                  // 🟢 ملاحظات عامة على الطلب (لو موجودة)
                  if (order.notes != null && order.notes!.isNotEmpty)
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      color: Colors.orange.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.sticky_note_2_rounded,
                              color: Colors.orange.shade700,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                order.notes!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontStyle: FontStyle.italic,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  /// 🔙 Back Button
                  // Center(
                  //   child: TextButton.icon(
                  //     onPressed: () => Navigator.pop(context),
                  //     icon: Icon(
                  //       Icons.arrow_back_ios_new,
                  //       color: AppColors.accent,
                  //     ),
                  //     label: Text(
                  //       "Back to orders",
                  //       style: TextStyle(
                  //         color: AppColors.accent,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          } else if (state is OrderDetailsFailure) {
            return Center(
              child: Text(
                "${loc.error} : ${state.message}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildAddressRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              "$label: $value",
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            color: AppColors.accent,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
