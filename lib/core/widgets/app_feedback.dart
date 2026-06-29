import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/fonts.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../constants/colors.dart';
import '../theme/app_theme.dart';
import 'app_text.dart';

class AppFeedback {
  AppFeedback._();

  /// Returns true if the user confirmed deletion.
  static Future<bool> confirmDelete(
    BuildContext context, {
    String? title,
    String? message,
  }) async {
    final palette = context.palette;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: AppText(
          text: title ?? LocaleKeys.confirm_delete_title.tr(),
          size: 17.sp,
          fontWeight: FontWeight.w700,
          family: FontFamily.bahijJannaBold,
          color: palette.textPrimary,
        ),
        content: AppText(
          text: message ?? LocaleKeys.confirm_delete_msg.tr(),
          size: 14.sp,
          lines: 3,
          color: palette.textSecondary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: AppText(
              text: LocaleKeys.cancel.tr(),
              color: palette.textSecondary,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: AppText(
              text: LocaleKeys.delete.tr(),
              color: AppColors.expense,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static void success(BuildContext context, String message) {
    _snack(context, message, AppColors.income, Icons.check_circle_rounded);
  }

  static void error(BuildContext context, String message) {
    _snack(context, message, AppColors.expense, Icons.error_rounded);
  }

  static void _snack(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: color,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20.w),
              SizedBox(width: 10.w),
              Expanded(
                child: AppText(
                  text: message,
                  color: Colors.white,
                  size: 14.sp,
                ),
              ),
            ],
          ),
        ),
      );
  }
}
