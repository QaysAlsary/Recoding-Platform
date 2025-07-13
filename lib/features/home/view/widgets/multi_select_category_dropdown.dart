import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recoding_platform_project/features/home/bloc/home_bloc.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';

class MultiSelectCategoryDropdown extends StatelessWidget {
  final List<String> selectedCategories;
  final List<String> categories;
  final bool isLoading;
  final String? error;
  final String hintText;
  final Icon icon;
  final String? hintSelected;
  final void Function(String item)? onItemToggled;

  const MultiSelectCategoryDropdown({
    super.key,
    required this.icon,
    required this.selectedCategories,
    required this.categories,
    this.isLoading = false,
    this.error,
    this.hintText = 'Select Category',
    this.onItemToggled,
    this.hintSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Text(error!, style: TextStyle(color: Colors.red));
    }

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 3.73,
            color: AppColors.black015,
          ),
        ),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            icon,
            8.horizontalSpace,
            Expanded(
              child: Text(
                selectedCategories.isEmpty
                    ? hintText
                    : '${selectedCategories.length} $hintSelected',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 16.r,
                      fontWeight: FontWeight.w300,
                      color: selectedCategories.isEmpty
                          ? Colors.grey
                          : Colors.black,
                    ),
              ),
            ),
          ],
        ),
        children: [
          Container(
            constraints: BoxConstraints(maxHeight: 200.h),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategories.contains(category);

                return CheckboxListTile(
                  title: Text(
                    category,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontSize: 14.r,
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                  value: isSelected,
                  onChanged: (bool? value) {
                    if (onItemToggled != null) {
                      onItemToggled!(category);
                    } else {
                      context.read<HomeBloc>().add(
                            ToggleCategorySelectionEvent(category),
                          );
                    }
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
