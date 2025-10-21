import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';
import 'package:restaurant_management/core/utils/image_utils.dart';
import 'package:restaurant_management/features/auth/data/models/category_model.dart';
import 'package:restaurant_management/features/auth/state/category_cubit.dart';
import 'package:restaurant_management/features/auth/state/category_state.dart';

class CategorySection extends StatefulWidget {
  final int selectedCategoryIndex;
  final Function(int, int) onCategorySelected;

  const CategorySection({
    super.key,
    required this.selectedCategoryIndex,
    required this.onCategorySelected,
  });

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  final Map<int, Uint8List> _imageCache = {};

  Uint8List? _getCachedImage(CategoryModel category) {
    if (category.icon.isEmpty) return null;
    if (_imageCache.containsKey(category.id)) return _imageCache[category.id];
    final bytes = convertBase64ToImage(category.icon);
    _imageCache[category.id] = bytes;
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoryLoaded) {
          final categories = [
            CategoryModel(
              id: 0,
              arbName: "كل الأطباق",
              engName: "All Dishes",
              icon: "",
            ),
            ...state.categories,
          ];

          return ListView.separated(
            key: const PageStorageKey('categories_list'),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = widget.selectedCategoryIndex == index;
              final imageBytes = _getCachedImage(category);

              return GestureDetector(
                key: ValueKey(category.id),
                onTap: () {
                  widget.onCategorySelected(index, category.id);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? AppColors.accent.withOpacity(0.15)
                                : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color:
                              isSelected
                                  ? AppColors.accent
                                  : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child:
                            imageBytes != null
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.memory(
                                    imageBytes,
                                    key: ValueKey('cat_${category.id}'),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    // 🔹 يخلي كل الصور بنفس الحجم داخل المربع
                                    gaplessPlayback: true,
                                  ),
                                )
                                : const Icon(
                                  Icons.restaurant_menu,
                                  color: AppColors.accent,
                                  size: 30,
                                ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 70, // 🔹 نفس عرض الصورة
                      child: Text(
                        Localizations.localeOf(context).languageCode == 'en'
                            ? category.engName
                            : category.arbName,
                        maxLines: 2,
                        // 🔹 يخلي الاسم يلف لسطرين فقط
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        // 🔹 يخلي النص في النص تحت الصورة
                        style: TextStyle(
                          color: isSelected ? AppColors.accent : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 12, // 🔹 حجم مناسب يخلي سطرين يشيلوا الكلام
                          height: 1.2, // 🔹 يقلل المسافة بين السطرين
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        return const Center(child: Text("No categories"));
      },
    );
  }
}
