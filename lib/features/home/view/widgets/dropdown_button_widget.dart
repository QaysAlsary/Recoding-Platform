import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';

import '../../bloc/home_bloc.dart';

class DropdownButtonWidget extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? openMenuLabel;

  const DropdownButtonWidget({
    super.key,
    required this.label,
    required this.icon,
    required this.openMenuLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isOpen = openMenuLabel == label;
    return ElevatedButton(

      onPressed: () {
        FocusScope.of(context).unfocus(); // Dismiss any open inputs or dropdowns
        context.read<HomeBloc>().add(ToggleMenuEvent(label));
      },
      style: ElevatedButton.styleFrom(
        overlayColor: Colors.grey,
        backgroundColor: AppColors.grey,
        elevation: 0,
        fixedSize: Size.fromHeight(40.h),
        shape: const BeveledRectangleBorder(),
        textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20.r, color: Colors.grey),
              8.horizontalSpace,
              Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 12.r)),
            ],
          ),
          Icon(
            isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.grey,
            size: 20.r,
          ),
        ],
      ),
    );
  }
}
