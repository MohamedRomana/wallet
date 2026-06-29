import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../theme/app_theme.dart';
import 'app_text.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final String lottie;
  final double size;

  const EmptyState({
    super.key,
    required this.message,
    this.lottie = 'assets/img/No-Data.json',
    this.size = 180,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(lottie, width: size.w, height: size.w, repeat: true),
          SizedBox(height: 8.h),
          AppText(
            text: message,
            size: 15.sp,
            color: context.palette.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
