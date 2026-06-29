import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/service/cubit/app_cubit.dart';
import '../../../../../core/utils/money.dart';
import '../../../../../core/widgets/animated_amount.dart';
import '../../../../../core/widgets/app_router.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/gradient_header.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../settings/settings.dart';

class DashboardHeader extends StatefulWidget {
  const DashboardHeader({super.key});

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  bool _hidden = false;

  @override
  Widget build(BuildContext context) {
    final cubit = AppCubit.get(context);
    return GradientHeader(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 22.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: app name + settings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: LocaleKeys.dashboard.tr(),
                      size: 13.sp,
                      color: Colors.white70,
                    ),
                    AppText(
                      text: LocaleKeys.app_name.tr(),
                      size: 20.sp,
                      fontWeight: FontWeight.w700,
                      family: FontFamily.bahijJannaBold,
                      color: Colors.white,
                    ),
                  ],
                ),
                _CircleIconButton(
                  icon: 'assets/svg/menu.svg',
                  onTap: () =>
                      AppRouter.navigateTo(context, const Settings()),
                ),
              ],
            ),
            SizedBox(height: 22.h),

            // Balance
            Row(
              children: [
                AppText(
                  text: LocaleKeys.total_balance.tr(),
                  size: 13.sp,
                  color: Colors.white70,
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () => setState(() => _hidden = !_hidden),
                  child: Icon(
                    _hidden
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: Colors.white70,
                    size: 18.w,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _hidden
                  ? AppText(
                      key: const ValueKey('hidden'),
                      text: '••••••',
                      size: 32.sp,
                      fontWeight: FontWeight.w800,
                      family: FontFamily.bahijJannaBold,
                      color: Colors.white,
                    )
                  : AnimatedAmount(
                      key: const ValueKey('shown'),
                      value: cubit.totalBalance,
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w800,
                        fontFamily: FontFamily.bahijJannaBold,
                        color: Colors.white,
                      ),
                    ),
            ),
            SizedBox(height: 20.h),

            // Income / Expense pills
            Row(
              children: [
                Expanded(
                  child: _MiniStat(
                    label: LocaleKeys.income.tr(),
                    amount: cubit.incomeForMonth(),
                    icon: Icons.arrow_downward_rounded,
                    iconColor: const Color(0xFF34D399),
                    hidden: _hidden,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _MiniStat(
                    label: LocaleKeys.expense.tr(),
                    amount: cubit.expenseForMonth(),
                    icon: Icons.arrow_upward_rounded,
                    iconColor: const Color(0xFFF87171),
                    hidden: _hidden,
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

class _MiniStat extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color iconColor;
  final bool hidden;

  const _MiniStat({
    required this.label,
    required this.amount,
    required this.icon,
    required this.iconColor,
    required this.hidden,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 16.w),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(text: label, size: 11.sp, color: Colors.white70),
                AppText(
                  text: hidden ? '••••' : Money.compact(amount),
                  size: 14.sp,
                  fontWeight: FontWeight.w700,
                  family: FontFamily.bahijJannaBold,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

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
        child: SvgPicture.asset(
          icon,
          width: 20.w,
          height: 20.w,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }
}
