import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../gen/assets.gen.dart';
import 'app_text.dart';

class CustomSoonDialog extends StatelessWidget {
  const CustomSoonDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 60.h),
          Image.asset(
            Assets.img.logo.path,
            height: 115.h,
            width: 163.w,
            fit: BoxFit.fill,
          ),
          AppText(
            top: 10.h,
            text: 'Soon',
            color: Colors.white,
            size: 30.sp,
          ),
        ],
      ),
    );
  }
}
