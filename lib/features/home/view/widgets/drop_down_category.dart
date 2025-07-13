import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/home/models/category_model.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';

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
      icon: Icon(
        Icons.keyboard_arrow_down_outlined,
        color: Color(0xff787878),
      ),
      decoration: InputDecoration(
        hintText: 'Category',
        hintStyle: Theme.of(context).textTheme.labelMedium,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(
            width: 3.73,
            color: AppColors.black015,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            width: 3.73,
            color: AppColors.black015,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            width: 3.73,
            color: AppColors.black015,
          ),
        ),
        prefixIcon: Icon(
          Icons.category_outlined,
          size: 20.r,
          color: Color(0xff787878),
        ),
      ),
      style: Theme.of(context)
          .textTheme
          .labelMedium
          ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400),
      items: items
          .map((category) => DropdownMenuItem(
                value: category.id,
                child: Text(
                  category.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
