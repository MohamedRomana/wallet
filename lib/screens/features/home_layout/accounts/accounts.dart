import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/data/models/account_model.dart';
import '../../../../core/service/cubit/app_cubit.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/animated_amount.dart';
import '../../../../core/widgets/app_feedback.dart';
import '../../../../core/widgets/app_router.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/category_avatar.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../../generated/locale_keys.g.dart';
import 'account_details.dart';
import 'widgets/account_form_sheet.dart';

class Accounts extends StatelessWidget {
  const Accounts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 70.h),
        child: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          onPressed: () => showAccountForm(context),
          icon: const Icon(Icons.add, color: Colors.white),
          label: AppText(
            text: LocaleKeys.add_account.tr(),
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          final cubit = AppCubit.get(context);
          final accounts = cubit.accounts;

          return Column(
            children: [
              GradientHeader(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 22.h),
                  child: Column(
                    children: [
                      AppText(
                        text: LocaleKeys.accounts.tr(),
                        size: 20.sp,
                        fontWeight: FontWeight.w700,
                        family: FontFamily.bahijJannaBold,
                        color: Colors.white,
                        bottom: 18.h,
                      ),
                      AppText(
                        text: LocaleKeys.total_net_worth.tr(),
                        size: 13.sp,
                        color: Colors.white70,
                      ),
                      SizedBox(height: 6.h),
                      AnimatedAmount(
                        value: cubit.totalBalance,
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w800,
                          fontFamily: FontFamily.bahijJannaBold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: accounts.isEmpty
                    ? EmptyState(message: LocaleKeys.no_accounts.tr())
                    : AnimationLimiter(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding:
                              EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 140.h),
                          itemCount: accounts.length,
                          separatorBuilder: (_, _) => SizedBox(height: 12.h),
                          itemBuilder: (context, i) {
                            final a = accounts[i];
                            return AnimationConfiguration.staggeredList(
                              position: i,
                              duration: const Duration(milliseconds: 400),
                              child: SlideAnimation(
                                verticalOffset: 40.h,
                                child: FadeInAnimation(
                                  child: _AccountCard(
                                    account: a,
                                    balance: cubit.accountBalance(a.id),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final AccountModel account;
  final double balance;

  const _AccountCard({required this.account, required this.balance});

  @override
  Widget build(BuildContext context) {
    final cubit = AppCubit.get(context);
    final palette = context.palette;

    return Slidable(
      key: ValueKey(account.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.5,
        children: [
          CustomSlidableAction(
            backgroundColor: AppColors.primary,
            borderRadius: BorderRadius.circular(16.r),
            onPressed: (_) => showAccountForm(context, account: account),
            child: Icon(Icons.edit_rounded, color: Colors.white, size: 22.w),
          ),
          SizedBox(width: 8.w),
          CustomSlidableAction(
            backgroundColor: AppColors.expense,
            borderRadius: BorderRadius.circular(16.r),
            onPressed: (_) async {
              final ok = await AppFeedback.confirmDelete(context);
              if (ok) {
                await cubit.deleteAccount(account.id);
                if (context.mounted) {
                  AppFeedback.success(
                      context, LocaleKeys.deleted_successfully.tr());
                }
              }
            },
            child: Icon(Icons.delete_rounded, color: Colors.white, size: 22.w),
          ),
        ],
      ),
      child: SectionCard(
        onTap: () =>
            AppRouter.navigateTo(context, AccountDetails(accountId: account.id)),
        child: Row(
          children: [
            CategoryAvatar(
              icon: account.type.icon,
              color: account.color,
              size: 48,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: account.name,
                    size: 16.sp,
                    fontWeight: FontWeight.w700,
                    family: FontFamily.bahijJannaBold,
                    color: palette.textPrimary,
                  ),
                  SizedBox(height: 3.h),
                  AppText(
                    text: account.type.nameKey.tr(),
                    size: 12.sp,
                    color: palette.textSecondary,
                  ),
                ],
              ),
            ),
            AppText(
              text: Money.format(balance),
              size: 16.sp,
              fontWeight: FontWeight.w800,
              family: FontFamily.bahijJannaBold,
              color: balance < 0 ? AppColors.expense : palette.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
