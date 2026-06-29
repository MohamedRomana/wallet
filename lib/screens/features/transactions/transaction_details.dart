import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/colors.dart';
import '../../../core/data/models/category_model.dart';
import '../../../core/data/models/transaction_model.dart';
import '../../../core/service/cubit/app_cubit.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../../core/widgets/app_router.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/category_avatar.dart';
import '../../../core/widgets/section_card.dart';
import '../../../core/widgets/sub_header.dart';
import '../../../gen/fonts.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../home_layout/add/add.dart';

class TransactionDetails extends StatelessWidget {
  final TransactionModel tx;
  const TransactionDetails({super.key, required this.tx});

  String _accountName(AppCubit cubit, String? id) {
    if (id == null) return '-';
    final acc = cubit.accounts.where((a) => a.id == id);
    return acc.isEmpty ? '-' : acc.first.name;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = AppCubit.get(context);
    final palette = context.palette;
    final isTransfer = tx.type == TxType.transfer;
    final isIncome = tx.type == TxType.income;
    final cat = isTransfer
        ? null
        : Categories.resolve(tx.categoryId, isIncome: isIncome);
    final color = isTransfer
        ? AppColors.primary
        : (isIncome ? AppColors.income : AppColors.expense);

    return Scaffold(
      body: Column(
        children: [
          SubHeader(
            title: LocaleKeys.transaction_details.tr(),
            trailing: IconButton(
              icon: Icon(Icons.edit_rounded, color: Colors.white, size: 20.w),
              onPressed: () =>
                  AppRouter.navigateTo(context, Add(editing: tx)),
            ),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 30.h),
              children: [
                Column(
                  children: [
                    CategoryAvatar(
                      icon: isTransfer
                          ? 'assets/svg/send.svg'
                          : (cat?.icon ?? 'assets/svg/more.svg'),
                      color: color,
                      size: 72,
                    ),
                    SizedBox(height: 14.h),
                    AppText(
                      text: isTransfer
                          ? Money.format(tx.amount)
                          : Money.signed(tx.amount, isIncome: isIncome),
                      size: 30.sp,
                      fontWeight: FontWeight.w800,
                      family: FontFamily.bahijJannaBold,
                      color: color,
                    ),
                    SizedBox(height: 4.h),
                    AppText(
                      text: isTransfer
                          ? LocaleKeys.transfer.tr()
                          : (cat?.nameKey.tr() ?? ''),
                      size: 15.sp,
                      color: palette.textSecondary,
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                SectionCard(
                  child: Column(
                    children: [
                      _Row(
                        label: LocaleKeys.date.tr(),
                        value: DateFormat.yMMMMEEEEd().format(tx.date),
                      ),
                      if (isTransfer) ...[
                        _Row(
                          label: LocaleKeys.from_account.tr(),
                          value: _accountName(cubit, tx.fromAccountId),
                        ),
                        _Row(
                          label: LocaleKeys.to_account.tr(),
                          value: _accountName(cubit, tx.toAccountId),
                        ),
                      ] else
                        _Row(
                          label: LocaleKeys.account.tr(),
                          value: _accountName(cubit, tx.accountId),
                        ),
                      if (tx.note.isNotEmpty)
                        _Row(label: LocaleKeys.note.tr(), value: tx.note),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.expense),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    onPressed: () async {
                      final ok = await AppFeedback.confirmDelete(context);
                      if (ok) {
                        await cubit.deleteTransaction(tx.id);
                        if (context.mounted) Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(Icons.delete_rounded,
                        color: AppColors.expense),
                    label: AppText(
                      text: LocaleKeys.delete.tr(),
                      color: AppColors.expense,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: label,
            size: 14.sp,
            color: palette.textSecondary,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: AppText(
              text: value,
              size: 14.sp,
              lines: 3,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.end,
              color: palette.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
