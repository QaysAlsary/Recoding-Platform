import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/home/models/aspect_model.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';

class DropDownAspect extends StatelessWidget {
  final void Function(int?)? onChanged;
  final int? value;
  const DropDownAspect({super.key, required this.onChanged, this.value});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: value,
      isExpanded: true,
      dropdownColor: Colors.white,
      icon: Icon(
        Icons.keyboard_arrow_down_outlined,
        color: Color(0xff787878),
      ),
      decoration: InputDecoration(
        hintText: 'Aspect',
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
          color: Color(0xff787878),
        ),
      ),
      style: Theme.of(context)
          .textTheme
          .labelMedium
          ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400),
      items: AspectData.getAspects()
          .map((aspect) => DropdownMenuItem(
                value: aspect.id,
                child: Text(
                  aspect.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
