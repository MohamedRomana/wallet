import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/fonts.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../constants/colors.dart';
import '../data/models/category_model.dart';
import '../data/models/transaction_model.dart';
import '../theme/app_theme.dart';
import '../utils/money.dart';
import 'app_text.dart';
import 'category_avatar.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel tx;
  final VoidCallback? onTap;

  const TransactionTile({super.key, required this.tx, this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isTransfer = tx.type == TxType.transfer;
    final isIncome = tx.type == TxType.income;

    final TxCategory? cat = isTransfer
        ? null
        : Categories.resolve(tx.categoryId, isIncome: isIncome);

    final String title = isTransfer
        ? LocaleKeys.transfer.tr()
        : (cat?.nameKey.tr() ?? '');

    final Color color = isTransfer
        ? AppColors.primary
        : (cat?.color ?? AppColors.primary);

    final String icon =
        isTransfer ? 'assets/svg/send.svg' : (cat?.icon ?? 'assets/svg/more.svg');

    final amountColor = isTransfer
        ? palette.textPrimary
        : (isIncome ? AppColors.income : AppColors.expense);

    final subtitle = tx.note.isNotEmpty
        ? tx.note
        : DateFormat.yMMMd().format(tx.date);

    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
        child: Row(
          children: [
            CategoryAvatar(icon: icon, color: color),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: title,
                    size: 15.sp,
                    fontWeight: FontWeight.w600,
                    family: FontFamily.bahijJannaBold,
                    color: palette.textPrimary,
                  ),
                  SizedBox(height: 3.h),
                  AppText(
                    text: subtitle,
                    size: 12.sp,
                    color: palette.textSecondary,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(
                  text: isTransfer
                      ? Money.format(tx.amount)
                      : Money.signed(tx.amount, isIncome: isIncome),
                  size: 15.sp,
                  fontWeight: FontWeight.w700,
                  family: FontFamily.bahijJannaBold,
                  color: amountColor,
                ),
                SizedBox(height: 3.h),
                AppText(
                  text: DateFormat.MMMd().format(tx.date),
                  size: 11.sp,
                  color: palette.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
