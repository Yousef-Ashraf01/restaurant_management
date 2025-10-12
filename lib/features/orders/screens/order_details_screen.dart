import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
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
    switch (status) {
      case 0:
        return AppLocalizations.of(context)!.pending;
      case 1:
        return AppLocalizations.of(context)!.processing;
      case 2:
        return AppLocalizations.of(context)!.delivered;
      case 3:
        return AppLocalizations.of(context)!.cancelled;
      default:
        return AppLocalizations.of(context)!.unknown;
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.orangeAccent;
      case 1:
        return Colors.blueAccent;
      case 2:
        return Colors.green;
      case 3:
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${AppLocalizations.of(context)!.order} #${widget.orderId}",
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderDetailsSuccess) {
            final order = state.order;
            final formattedDate = DateFormat(
              'yyyy-MM-dd – hh:mm a',
            ).format(order.date);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                  AppLocalizations.of(context)!.orderStatus,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  _getStatusText(order.status),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _getStatusColor(order.status),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    AppLocalizations.of(context)!.deliveryAddress,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFEBEE),
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(10),
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.redAccent,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                AppLocalizations.of(context)!.deliveryAddress,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // 🏠 Address
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  order.fullAddress,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.apartment,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        "${AppLocalizations.of(context)!.building}: ${order.buildingName}",
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.stairs,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        "${AppLocalizations.of(context)!.floor}: ${order.floor}",
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.meeting_room,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        "${AppLocalizations.of(context)!.apartment}: ${order.apartmentNo}",
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_city,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        "${AppLocalizations.of(context)!.city}: ${order.city}",
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          if (order.additionalDirections.isNotEmpty)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.map_outlined,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    "${AppLocalizations.of(context)!.directions}: ${order.additionalDirections}",
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    AppLocalizations.of(context)!.orderItems,
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
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children:
                            order.items.map((item) {
                              final dish = item.dish;
                              return ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    dish?.image ?? '',
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
                                          ? dish!.engName
                                          : dish!.arbName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    );
                                  },
                                ),
                                subtitle: Text("x${item.quantity}"),
                                trailing: Text(
                                  item.totalPrice.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    AppLocalizations.of(context)!.orderSummary,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSummaryRow(
                            "${AppLocalizations.of(context)!.total}:",
                            order.totalPrice.toStringAsFixed(2),
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is OrderDetailsFailure) {
            return Center(
              child: Text(
                "${AppLocalizations.of(context)!.error} : ${state.message}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const SizedBox();
        },
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
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
