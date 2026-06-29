import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/app_text.dart';

class GoalFieldLabel extends StatelessWidget {
  final String text;
  const GoalFieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: AppText(
        text: text,
        size: 13.sp,
        fontWeight: FontWeight.w700,
        color: context.palette.textSecondary,
      ),
    );
  }
}

class GoalTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool number;
  final String? hint;

  const GoalTextField({
    super.key,
    required this.controller,
    this.number = false,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return TextField(
      controller: controller,
      keyboardType: number
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      inputFormatters: number
          ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))]
          : null,
      style: TextStyle(fontSize: 15.sp, color: palette.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: palette.textSecondary, fontSize: 14.sp),
        filled: true,
        fillColor: palette.surfaceAlt,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
