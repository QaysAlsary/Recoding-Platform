import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/home/view/widgets/drop_down_sub_aspect.dart';
import 'package:recoding_platform_project/src/components/auth_button.dart';
import 'package:recoding_platform_project/src/components/header.dart';
import 'package:recoding_platform_project/src/components/input_text_form_field.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';

class EditMarkerView extends StatelessWidget {
  const EditMarkerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Header(
            headerText: "Edit Marker",
          ),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '[Marker Name]',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontSize: 24.sp),
                ),
                SizedBox(
                  height: 20.h,
                ),
                InputTextFormField(
                  hintText: "Aspect",
                  prefixIcon: Icon(Icons.sync, color: Color(0xff787878)),
                ),
                SizedBox(
                  height: 32.h,
                ),
                DropDownSubAspect(
                  onChanged: (value) {},
                ),
                SizedBox(
                  height: 32.h,
                ),
                InputTextFormField(
                  hintText: "Category",
                  prefixIcon:
                      Icon(Icons.category_outlined, color: Color(0xff787878)),
                ),
                SizedBox(
                  height: 32.h,
                ),
                InputTextFormField(
                  hintText: "Location name",
                  prefixIcon: Icon(Icons.input, color: Color(0xff787878)),
                ),
                SizedBox(
                  height: 32.h,
                ),
                InputTextFormField(
                  hintText: "Description",
                  prefixIcon: Icon(Icons.description_outlined,
                      color: Color(0xff787878)),
                ),
                SizedBox(
                  height: 32.h,
                ),
                InputTextFormField(
                  hintText: "Upload images",
                  prefixIcon: Icon(
                    Icons.cloud_upload_outlined,
                    color: Color(0xff787878),
                  ),
                  suffixIcon: Icon(Icons.upload_rounded),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AuthButton(
                      onPressed: () {},
                      buttonWidth: 152.w,
                      text: "Save",
                      textStyle: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                      buttonStyle: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff6ab3d9),
                        foregroundColor: AppColors.black073,
                        elevation: 0,
                        overlayColor: Color(0xff6ab3d9),
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                    AuthButton(
                      onPressed: () {},
                      text: 'Cancel',
                      buttonWidth: 152.w,
                      textStyle: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                    ),
                  ],
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
