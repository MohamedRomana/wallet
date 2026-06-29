import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/service/cubit/app_cubit.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/app_router.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../core/widgets/section_header.dart';
import '../../../../../core/widgets/transaction_tile.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../transactions/transaction_details.dart';
import '../../../transactions/transactions_screen.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = AppCubit.get(context);
    final recent = cubit.recentTransactions(5);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: LocaleKeys.recent_transactions.tr(),
            onAction: recent.isEmpty
                ? null
                : () => AppRouter.navigateTo(
                    context, const TransactionsScreen()),
          ),
          SizedBox(height: 6.h),
          if (recent.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(
                child: AppText(
                  text: LocaleKeys.no_transactions.tr(),
                  color: context.palette.textSecondary,
                  size: 14.sp,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recent.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: context.palette.border,
              ),
              itemBuilder: (context, i) => TransactionTile(
                tx: recent[i],
                onTap: () => AppRouter.navigateTo(
                  context,
                  TransactionDetails(tx: recent[i]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
