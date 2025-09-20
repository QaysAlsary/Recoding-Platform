import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recoding_platform_project/features/home/bloc/home_bloc.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';
import 'package:shimmer/shimmer.dart';

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
      return Center(
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
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
        title: _buildTitle(),
        children: _buildChildren(),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: selectedCategories.isNotEmpty
                ? AppColors.blue.withOpacity(0.1)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6.w),
          ),
          child: Icon(
            icon.icon,
            size: 16.w,
            color: selectedCategories.isNotEmpty
                ? AppColors.blue
                : Colors.grey.shade600,
          ),
        ),
        8.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedCategories.isEmpty
                    ? hintText
                    : '${selectedCategories.length} $hintSelected',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: selectedCategories.isNotEmpty
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: selectedCategories.isNotEmpty
                      ? Colors.black
                      : Colors.grey.shade600,
                ),
              ),
              if (selectedCategories.isNotEmpty) ...[
                2.verticalSpace,
                Text(
                  _getSelectedPreview(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: selectedCategories.isNotEmpty
                ? AppColors.blue.withOpacity(0.1)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4.w),
          ),
          child: Icon(
            Icons.keyboard_arrow_down,
            size: 14.w,
            color: selectedCategories.isNotEmpty
                ? AppColors.blue
                : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildChildren() {
    return [
      Container(
        constraints: BoxConstraints(maxHeight: 150.h),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: categories.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: Colors.grey.shade200,
            indent: 32.w,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = selectedCategories.contains(category);

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (onItemToggled != null) {
                    onItemToggled!(category);
                  } else {
                    // This would need to be handled by the parent widget
                    // since we don't have direct access to the BLoC here
                  }
                },
                borderRadius: BorderRadius.circular(6.w),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    children: [
                      _buildCheckbox(isSelected, category),
                      8.horizontalSpace,
                      Expanded(
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? AppColors.blue : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ];
  }

  Widget _buildCheckbox(bool isSelected, String category) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 16.w,
      height: 16.w,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.blue : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppColors.blue : Colors.grey.shade400,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: isSelected
          ? Icon(
              Icons.check,
              size: 10.w,
              color: Colors.white,
            )
          : null,
    );
  }

  String _getSelectedPreview() {
    if (selectedCategories.isEmpty) return '';
    if (selectedCategories.length <= 2) {
      return selectedCategories.join(', ');
    }
    return '${selectedCategories.take(2).join(', ')}...';
  }
}
