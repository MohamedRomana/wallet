import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/data/models/budget_model.dart';
import '../../../../core/data/models/category_model.dart';
import '../../../../core/service/cubit/app_cubit.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/app_feedback.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/category_avatar.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../../generated/locale_keys.g.dart';
import 'widgets/budget_form_sheet.dart';

class Budget extends StatelessWidget {
  const Budget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 70.h),
        child: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          onPressed: () => showBudgetForm(context),
          icon: const Icon(Icons.add, color: Colors.white),
          label: AppText(
            text: LocaleKeys.set_budget.tr(),
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          final cubit = AppCubit.get(context);
          final budgets = cubit.budgets;
          final totalBudget =
              budgets.fold<double>(0, (s, b) => s + b.limit);
          final totalSpent = budgets.fold<double>(
              0, (s, b) => s + cubit.spentForCategory(b.categoryId));
          final remaining = totalBudget - totalSpent;

          return Column(
            children: [
              GradientHeader(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
                  child: Column(
                    children: [
                      AppText(
                        text: LocaleKeys.categories_and_budget.tr(),
                        size: 20.sp,
                        fontWeight: FontWeight.w700,
                        family: FontFamily.bahijJannaBold,
                        color: Colors.white,
                        bottom: 18.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _SummaryTile(
                              label: LocaleKeys.total_budget.tr(),
                              value: totalBudget,
                            ),
                          ),
                          Expanded(
                            child: _SummaryTile(
                              label: LocaleKeys.total_spent.tr(),
                              value: totalSpent,
                            ),
                          ),
                          Expanded(
                            child: _SummaryTile(
                              label: LocaleKeys.remaining.tr(),
                              value: remaining,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: budgets.isEmpty
                    ? EmptyState(message: LocaleKeys.no_budgets.tr())
                    : AnimationLimiter(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding:
                              EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 140.h),
                          itemCount: budgets.length,
                          separatorBuilder: (_, _) => SizedBox(height: 12.h),
                          itemBuilder: (context, i) {
                            final b = budgets[i];
                            return AnimationConfiguration.staggeredList(
                              position: i,
                              duration: const Duration(milliseconds: 400),
                              child: SlideAnimation(
                                verticalOffset: 40.h,
                                child: FadeInAnimation(
                                  child: _BudgetCard(
                                    budget: b,
                                    spent:
                                        cubit.spentForCategory(b.categoryId),
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

class _SummaryTile extends StatelessWidget {
  final String label;
  final double value;
  const _SummaryTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(text: label, size: 11.sp, color: Colors.white70),
        SizedBox(height: 4.h),
        AppText(
          text: Money.compact(value),
          size: 15.sp,
          fontWeight: FontWeight.w800,
          family: FontFamily.bahijJannaBold,
          color: Colors.white,
        ),
      ],
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final BudgetModel budget;
  final double spent;

  const _BudgetCard({required this.budget, required this.spent});

  @override
  Widget build(BuildContext context) {
    final cubit = AppCubit.get(context);
    final palette = context.palette;
    final cat = Categories.resolve(budget.categoryId);
    final percent =
        budget.limit <= 0 ? 0.0 : (spent / budget.limit).clamp(0.0, 1.0);
    final over = spent > budget.limit;
    final barColor = over ? AppColors.expense : cat.color;

    return Slidable(
      key: ValueKey(budget.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.5,
        children: [
          CustomSlidableAction(
            backgroundColor: AppColors.primary,
            borderRadius: BorderRadius.circular(16.r),
            onPressed: (_) => showBudgetForm(context, budget: budget),
            child: Icon(Icons.edit_rounded, color: Colors.white, size: 22.w),
          ),
          SizedBox(width: 8.w),
          CustomSlidableAction(
            backgroundColor: AppColors.expense,
            borderRadius: BorderRadius.circular(16.r),
            onPressed: (_) async {
              final ok = await AppFeedback.confirmDelete(context);
              if (ok) {
                await cubit.deleteBudget(budget.id);
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
        child: Column(
          children: [
            Row(
              children: [
                CategoryAvatar(icon: cat.icon, color: cat.color),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: cat.nameKey.tr(),
                        size: 15.sp,
                        fontWeight: FontWeight.w700,
                        family: FontFamily.bahijJannaBold,
                        color: palette.textPrimary,
                      ),
                      SizedBox(height: 3.h),
                      AppText(
                        text:
                            '${Money.format(spent)} ${LocaleKeys.of_word.tr()} ${Money.format(budget.limit)}',
                        size: 12.sp,
                        color: palette.textSecondary,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: barColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: AppText(
                    text: over
                        ? LocaleKeys.overspent.tr()
                        : '${(percent * 100).round()}%',
                    size: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: barColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            LinearPercentIndicator(
              padding: EdgeInsets.zero,
              lineHeight: 9.h,
              percent: percent.toDouble(),
              barRadius: Radius.circular(8.r),
              backgroundColor: palette.surfaceAlt,
              progressColor: barColor,
              animation: true,
              animationDuration: 600,
            ),
          ],
        ),
      ),
    );
  }
}
