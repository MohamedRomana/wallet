import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/fonts.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../constants/colors.dart';
import '../theme/app_theme.dart';
import 'app_text.dart';

/// "Title ............ See All" row used above lists.
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onAction;
  final String? actionLabel;

  const SectionHeader({
    super.key,
    required this.title,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: AppText(
            text: title,
            size: 17.sp,
            fontWeight: FontWeight.w700,
            family: FontFamily.bahijJannaBold,
            color: context.palette.textPrimary,
          ),
        ),
        if (onAction != null)
          InkWell(
            borderRadius: BorderRadius.circular(8.r),
            onTap: onAction,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              child: AppText(
                text: actionLabel ?? LocaleKeys.see_all.tr(),
                size: 13.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
