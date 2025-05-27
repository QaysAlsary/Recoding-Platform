import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';

class DropDownSubAspect extends StatelessWidget {
  final void Function(String?)? onChanged;
  const DropDownSubAspect({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      dropdownColor: Colors.white,
      icon: Icon(
        Icons.keyboard_arrow_down_outlined,
        color: Colors.grey,
      ),
      decoration: InputDecoration(
        hintText: 'Sub-Aspect',
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
          Icons.other_houses_outlined,
          size: 20.r,
          color: Colors.grey,
        ),
      ),
      style: Theme.of(context)
          .textTheme
          .labelMedium
          ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400),
      items: [
        'Culture & Heritage',
        'Building Code & Policy',
        'Economic Factor',
        'Public Health',
        'Resources Management',
        'Urban Planning',
        'Data Collection & Analysis',
        'Technology & Digital Infrastructure',
        'Ecological Factor',
        'Social Factor',
      ].map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
      onChanged: onChanged,
    );
  }
}
