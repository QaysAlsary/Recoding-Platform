import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/home/models/aspect_model.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';

class DropDownCategory extends StatelessWidget {
  final int? value;
  final int? selectedSubAspect;
  final Function(int?) onChanged;

  const DropDownCategory({
    super.key,
    required this.value,
    required this.selectedSubAspect,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = selectedSubAspect != null
        ? AspectData.getCategoriesForSubAspect(selectedSubAspect!)
        : <Category>[];
    final validValue =
        value != null && categories.any((c) => c.id == value) ? value : null;
    return DropdownButtonFormField<int>(
      value: validValue,
      dropdownColor: Colors.white,
      icon: const Icon(
        Icons.keyboard_arrow_down_outlined,
        color: Color(0xff787878),
      ),
      isExpanded: true,
      decoration: InputDecoration(
        hintText: 'Category',
        hintStyle: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(fontSize: 16.r, fontWeight: FontWeight.w300),
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
          ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w300),
      items: categories
          .map((category) => DropdownMenuItem(
                value: category.id,
                child: Text(
                  category.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ))
          .toList(),
      onChanged: selectedSubAspect != null ? onChanged : null,
    );
  }
}
