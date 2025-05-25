import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey,width: 1),
        color: Colors.white.withOpacity(0.37),
        borderRadius: BorderRadius.circular(100),

      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          6.horizontalSpace,
          Expanded(
            child: TextField(

              cursorColor: AppColors.blue,
              controller: controller,
              onChanged: onChanged,
              decoration:  InputDecoration(
                hintText: 'Search',
                hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 15.r,letterSpacing: 0.05),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
