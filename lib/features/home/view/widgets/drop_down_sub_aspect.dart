import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/home/models/sub_aspect_model.dart';

class DropDownSubAspect extends StatelessWidget {
  final int? value;
  final void Function(int?)? onChanged;
  final bool isLoading;
  final String? error;
  final List<SubAspectModel> items;
  const DropDownSubAspect({
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
        value != null && items.any((s) => s.id == value) ? value : null;
    if (error != null) {
      return Text(error!);
    }
    return DropdownButtonFormField<int>(
      key: ValueKey('subaspect_${items.length}_$validValue'),
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
        hintText: 'Sub-aspect',
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
          Icons.other_houses_outlined,
          size: 22,
          color: Colors.grey[700],
        ),
      ),
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black),
      selectedItemBuilder: (context) => items
          .map((subAspect) => Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  subAspect.name,
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
          .map((subAspect) => DropdownMenuItem(
                value: subAspect.id,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: validValue == subAspect.id
                        ? Colors.grey[100]
                        : Colors.white,
                  ),
                  child: Text(
                    subAspect.name,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: validValue == subAspect.id
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
