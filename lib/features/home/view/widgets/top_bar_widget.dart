import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../src/themes/app_colors.dart';

class TopBarWidget extends StatelessWidget {
  const TopBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12  , vertical: 6),
      color:  AppColors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
           SizedBox(
            width: 40.r,
            height: 40.r,
            child: ClipOval(
              child: Image.asset(
                'assets/images/prof.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            children:  [
              IconButton(icon: Icon(Icons.notifications_none, size: 30.r,color: Colors.grey,),onPressed: (){},  ),

              IconButton(icon: Icon(Icons.settings, size: 30.r, color: Colors.grey,),  onPressed: (){}, ),
            ],
          ),
        ],
      ),
    );
  }
}