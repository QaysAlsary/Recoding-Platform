import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/home/models/category_model.dart';

class DropDownCategory extends StatelessWidget {
  final int? value;
  final void Function(int?)? onChanged;
  final bool isLoading;
  final String? error;
  final List<CategoryModel> items;
  const DropDownCategory({
    super.key,
    this.value,
    required this.onChanged,
    this.isLoading = false,
    this.error,
    this.items = const [],
  });

  @override
  Widget build(BuildContext context) {
    final validValue =
        value != null && items.any((c) => c.id == value) ? value : null;
    if (error != null) {
      return Text(error!);
    }
    return DropdownButtonFormField<int>(
      key: ValueKey('category_${items.length}_$validValue'),
      value: validValue,
      isExpanded: true,
      dropdownColor: Colors.white,
      menuMaxHeight: 300,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.grey[700],
        size: 28,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Category',
        hintStyle: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: Colors.grey[500]),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        prefixIcon: Icon(
          Icons.category_outlined,
          size: 22,
          color: Colors.grey[700],
        ),
      ),
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black),
      selectedItemBuilder: (context) => items
          .map((category) => Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  category.name,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
      items: items
          .map((category) => DropdownMenuItem(
                value: category.id,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: validValue == category.id
                        ? Colors.grey[100]
                        : Colors.white,
                  ),
                  child: Text(
                    category.name,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: validValue == category.id
                              ? Colors.black
                              : Colors.grey[800],
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
