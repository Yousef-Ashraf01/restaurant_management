import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:restaurant_management/features/auth/data/models/dish_model.dart';
import 'package:restaurant_management/features/auth/state/cart_cubit.dart';

void showDishOptionsBottomSheet(BuildContext context, DishModel dish) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
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
                                      duration: Duration(seconds: 1),
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
