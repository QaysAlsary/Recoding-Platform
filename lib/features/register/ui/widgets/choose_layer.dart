import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';

class ChooseLayer extends StatefulWidget {
  final TextEditingController layerController;

  const ChooseLayer({super.key, required this.layerController});

  @override
  _ChooseLayerState createState() => _ChooseLayerState();
}

class _ChooseLayerState extends State<ChooseLayer> {
  String? selectedValue; // القيمة المختارة

  final List<String> options = [
    'public health',
    'resources management',
    'economic factor',
    'urban planning',
    'ecological factor',
    'social factor',
    'building code',
    'Culture and heritage',
    'technology and infrastructure',
    'data collection and analysis'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340.56.w,
      child: DropdownButton<String>(
        isExpanded: true,
        underline: Container(
          height: 3,
          color: AppColors.black073.withOpacity(0.2),
        ),
        hint: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 8.w),
                Icon(Icons.layers_outlined,
                    size: 30, color: AppColors.black073.withOpacity(0.4)),
                SizedBox(width: 8.w),
                const Text(
                  "Choose your layer:",
                  style: TextStyle(
                    color: AppColors.black073,
                    fontSize: 20,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            )
          ],
        ),
        value: selectedValue,
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.layers,
                        color: AppColors.black073.withOpacity(0.4)),
                    SizedBox(width: 8.w),
                    Text(
                      value,
                      style: const TextStyle(
                        color: AppColors.black073,
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                )
              ],
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue;
            widget.layerController.text = newValue ?? "";
          });
        },
      ),
    );
  }
}
