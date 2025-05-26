import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/home/view/widgets/dropdown_button_widget.dart';
import 'package:recoding_platform_project/src/components/header.dart';
import 'package:recoding_platform_project/src/components/outline_input_text_form.dart';
import 'package:recoding_platform_project/src/components/rounded_rectangle_button.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';

class SelectMarkerView extends StatelessWidget {
  const SelectMarkerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Header(
            headerText: "Select Marker",
          ),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  dropdownColor: Colors.white,
                  icon: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Filter by Team',
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
                      color: Colors.grey,
                    ),
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontSize: 16.r, fontWeight: FontWeight.w300),
                  items: ['Category A', 'Category B', 'Category C']
                      .map((cat) =>
                          DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (value) {},
                ),
                SizedBox(
                  height: 24.h,
                ),
                SizedBox(
                  height: 10.h,
                ),
                OutlineInputTextForm(
                  hintText: "Damascus Marker",
                  suffixIcon: Icons.edit_outlined,
                ),
                SizedBox(
                  height: 10.h,
                ),
                OutlineInputTextForm(
                  hintText: "Social Marker",
                  suffixIcon: Icons.edit_outlined,
                ),
                SizedBox(
                  height: 10.h,
                ),
                OutlineInputTextForm(
                  hintText: "Data Collection Marker",
                  suffixIcon: Icons.edit_outlined,
                ),
                SizedBox(
                  height: 10.h,
                ),
                OutlineInputTextForm(
                  hintText: "Something Marker",
                  suffixIcon: Icons.edit_outlined,
                ),
                SizedBox(
                  height: 10.h,
                ),
                OutlineInputTextForm(
                  hintText: "Example Marker",
                  suffixIcon: Icons.edit_outlined,
                ),
                SizedBox(
                  height: 150.h,
                ),
                RoundedRectangleButton(
                  onPressed: () {},
                  text: "Create New Marker",
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
