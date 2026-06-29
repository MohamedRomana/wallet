import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/fonts.gen.dart';
import 'app_text.dart';
import 'gradient_header.dart';

/// Gradient header with a back button and a title, used by all secondary
/// (pushed) screens. [trailing] can hold an action button.
class SubHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget? bottom;

  const SubHeader({
    super.key,
    required this.title,
    this.trailing,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return GradientHeader(
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 18.h),
        child: Column(
          children: [
            Row(
              children: [
                _RoundBtn(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.of(context).maybePop(),
                ),
                Expanded(
                  child: AppText(
                    text: title,
                    size: 18.sp,
                    fontWeight: FontWeight.w700,
                    family: FontFamily.bahijJannaBold,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 42.w, child: trailing),
              ],
            ),
            if (bottom != null) ...[SizedBox(height: 14.h), bottom!],
          ],
        ),
      ),
    );
  }
}

class _RoundBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42.w,
        height: 42.w,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: Colors.white, size: 18.w),
      ),
    );
  }
}
