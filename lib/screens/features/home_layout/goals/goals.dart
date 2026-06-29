import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/data/models/goal_model.dart';
import '../../../../core/service/cubit/app_cubit.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/app_feedback.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../../generated/locale_keys.g.dart';
import 'widgets/goal_form_sheet.dart';

class Goals extends StatelessWidget {
  const Goals({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 70.h),
        child: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          onPressed: () => showGoalForm(context),
          icon: const Icon(Icons.add, color: Colors.white),
          label: AppText(
            text: LocaleKeys.add_goal.tr(),
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          final cubit = AppCubit.get(context);
          final goals = cubit.goals;
          final totalSaved = goals.fold<double>(0, (s, g) => s + g.savedAmount);
          final totalTarget =
              goals.fold<double>(0, (s, g) => s + g.targetAmount);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _Header(
                  count: goals.length,
                  saved: totalSaved,
                  target: totalTarget,
                ),
              ),
              if (goals.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.only(top: 60.h),
                    child: AppText(
                      text: LocaleKeys.no_goals.tr(),
                      textAlign: TextAlign.center,
                      color: context.palette.textSecondary,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 140.h),
                  sliver: SliverList.separated(
                    itemCount: goals.length,
                    separatorBuilder: (_, _) => SizedBox(height: 12.h),
                    itemBuilder: (context, i) =>
                        AnimationConfiguration.staggeredList(
                      position: i,
                      duration: const Duration(milliseconds: 400),
                      child: SlideAnimation(
                        verticalOffset: 40.h,
                        child: FadeInAnimation(
                          child: _GoalCard(goal: goals[i]),
                        ),
                      ),
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

class _Header extends StatelessWidget {
  final int count;
  final double saved;
  final double target;
  const _Header({
    required this.count,
    required this.saved,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    return GradientHeader(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 22.h),
        child: Column(
          children: [
            AppText(
              text: LocaleKeys.financial_goals.tr(),
              size: 20.sp,
              fontWeight: FontWeight.w700,
              family: FontFamily.bahijJannaBold,
              color: Colors.white,
              bottom: 18.h,
            ),
            Row(
              children: [
                Expanded(
                  child: _HeaderStat(
                    label: LocaleKeys.active_goals.tr(),
                    value: '$count',
                  ),
                ),
                Expanded(
                  child: _HeaderStat(
                    label: LocaleKeys.saved_amount.tr(),
                    value: Money.compact(saved),
                  ),
                ),
                Expanded(
                  child: _HeaderStat(
                    label: LocaleKeys.target_amount.tr(),
                    value: Money.compact(target),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String label;
  final String value;
  const _HeaderStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(text: label, size: 11.sp, color: Colors.white70),
        SizedBox(height: 4.h),
        AppText(
          text: value,
          size: 15.sp,
          fontWeight: FontWeight.w800,
          family: FontFamily.bahijJannaBold,
          color: Colors.white,
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  final GoalModel goal;
  const _GoalCard({required this.goal});

  String _deadlineLabel(BuildContext context) {
    if (goal.isCompleted) return LocaleKeys.goal_completed.tr();
    final d = goal.deadline;
    if (d == null) return '';
    final days = d.difference(DateTime.now()).inDays;
    if (days <= 0) return '';
    if (days < 31) return '$days ${LocaleKeys.days_left.tr()}';
    final months = (days / 30).round();
    return '$months ${LocaleKeys.months_left.tr()}';
  }

  @override
  Widget build(BuildContext context) {
    final cubit = AppCubit.get(context);
    final palette = context.palette;
    final color = goal.color;

    return Slidable(
      key: ValueKey(goal.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.5,
        children: [
          CustomSlidableAction(
            backgroundColor: AppColors.primary,
            borderRadius: BorderRadius.circular(16.r),
            onPressed: (_) => showGoalForm(context, goal: goal),
            child: Icon(Icons.edit_rounded, color: Colors.white, size: 22.w),
          ),
          SizedBox(width: 8.w),
          CustomSlidableAction(
            backgroundColor: AppColors.expense,
            borderRadius: BorderRadius.circular(16.r),
            onPressed: (_) async {
              final ok = await AppFeedback.confirmDelete(context);
              if (ok) {
                await cubit.deleteGoal(goal.id);
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
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
                color: palette.shadow,
                blurRadius: 16,
                offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    goal.icon,
                    width: 24.w,
                    height: 24.w,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: goal.title,
                        size: 16.sp,
                        fontWeight: FontWeight.w700,
                        family: FontFamily.bahijJannaBold,
                        color: palette.textPrimary,
                      ),
                      if (_deadlineLabel(context).isNotEmpty) ...[
                        SizedBox(height: 3.h),
                        AppText(
                          text: _deadlineLabel(context),
                          size: 12.sp,
                          color: goal.isCompleted
                              ? AppColors.income
                              : palette.textSecondary,
                        ),
                      ],
                    ],
                  ),
                ),
                _IconBtn(
                  color: color,
                  onTap: () => _contribute(context, goal),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            LinearPercentIndicator(
              padding: EdgeInsets.zero,
              lineHeight: 9.h,
              percent: goal.progress,
              barRadius: Radius.circular(8.r),
              backgroundColor: palette.surfaceAlt,
              progressColor: color,
              animation: true,
              animationDuration: 600,
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: Money.format(goal.savedAmount),
                  size: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
                AppText(
                  text:
                      '${(goal.progress * 100).round()}% ${LocaleKeys.of_word.tr()} ${Money.format(goal.targetAmount)}',
                  size: 12.sp,
                  color: palette.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _contribute(BuildContext context, GoalModel goal) async {
    final controller = TextEditingController();
    final palette = context.palette;
    final amount = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: AppText(
          text: LocaleKeys.contribute.tr(),
          size: 17.sp,
          fontWeight: FontWeight.w700,
          family: FontFamily.bahijJannaBold,
          color: palette.textPrimary,
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          style: TextStyle(fontSize: 18.sp, color: palette.textPrimary),
          decoration: InputDecoration(
            prefixText: '${Money.symbol} ',
            hintText: '0',
            filled: true,
            fillColor: palette.surfaceAlt,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: AppText(
              text: LocaleKeys.cancel.tr(),
              color: palette.textSecondary,
            ),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(ctx, double.tryParse(controller.text.trim())),
            child: AppText(
              text: LocaleKeys.save.tr(),
              color: goal.color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );

    if (amount != null && amount > 0 && context.mounted) {
      await AppCubit.get(context).contributeToGoal(goal, amount);
      if (context.mounted) {
        AppFeedback.success(context, LocaleKeys.saved_successfully.tr());
      }
    }
  }
}

class _IconBtn extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;
  const _IconBtn({required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(Icons.add, color: color, size: 20.w),
      ),
    );
  }
}
