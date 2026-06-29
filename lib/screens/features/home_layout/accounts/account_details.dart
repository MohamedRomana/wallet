import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/service/cubit/app_cubit.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/app_router.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/category_avatar.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/sub_header.dart';
import '../../../../core/widgets/transaction_tile.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../transactions/transaction_details.dart';
import 'widgets/account_form_sheet.dart';

class AccountDetails extends StatelessWidget {
  final String accountId;
  const AccountDetails({super.key, required this.accountId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          final cubit = AppCubit.get(context);
          final accounts = cubit.accounts.where((a) => a.id == accountId);
          if (accounts.isEmpty) {
            // account was deleted
            return Column(
              children: [
                SubHeader(title: LocaleKeys.accounts.tr()),
                Expanded(
                  child: EmptyState(message: LocaleKeys.no_accounts.tr()),
                ),
              ],
            );
          }
          final account = accounts.first;
          final balance = cubit.accountBalance(account.id);
          final txs = cubit.sortedTransactions
              .where((t) =>
                  t.accountId == accountId ||
                  t.fromAccountId == accountId ||
                  t.toAccountId == accountId)
              .toList();

          return Column(
            children: [
              SubHeader(
                title: account.name,
                trailing: IconButton(
                  icon: Icon(Icons.edit_rounded,
                      color: Colors.white, size: 20.w),
                  onPressed: () =>
                      showAccountForm(context, account: account),
                ),
                bottom: Column(
                  children: [
                    CategoryAvatar(
                      icon: account.type.icon,
                      color: Colors.white,
                      size: 56,
                    ),
                    SizedBox(height: 10.h),
                    AppText(
                      text: Money.format(balance),
                      size: 28.sp,
                      fontWeight: FontWeight.w800,
                      family: FontFamily.bahijJannaBold,
                      color: Colors.white,
                    ),
                    AppText(
                      text: account.type.nameKey.tr(),
                      size: 13.sp,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: txs.isEmpty
                    ? EmptyState(message: LocaleKeys.no_transactions.tr())
                    : ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 30.h),
                        children: [
                          AppText(
                            text: LocaleKeys.recent_transactions.tr(),
                            size: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: context.palette.textSecondary,
                            bottom: 10.h,
                          ),
                          SectionCard(
                            child: Column(
                              children: [
                                for (int i = 0; i < txs.length; i++) ...[
                                  if (i > 0)
                                    Divider(
                                      height: 1,
                                      color: context.palette.border,
                                    ),
                                  TransactionTile(
                                    tx: txs[i],
                                    onTap: () => AppRouter.navigateTo(
                                      context,
                                      TransactionDetails(tx: txs[i]),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
