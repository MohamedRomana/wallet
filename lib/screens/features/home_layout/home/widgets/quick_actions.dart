import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/service/cubit/app_cubit.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../core/widgets/section_header.dart';
import '../../../../../generated/locale_keys.g.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = AppCubit.get(context);
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: LocaleKeys.quick_actions.tr()),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: LocaleKeys.add_income.tr(),
                  icon: Icons.arrow_downward_rounded,
                  color: AppColors.income,
                  onTap: () => cubit.openAdd(0),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _ActionButton(
                  label: LocaleKeys.add_expense.tr(),
                  icon: Icons.arrow_upward_rounded,
                  color: AppColors.expense,
                  onTap: () => cubit.openAdd(1),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _ActionButton(
                  label: LocaleKeys.transfer.tr(),
                  icon: Icons.swap_horiz_rounded,
                  color: AppColors.primary,
                  onTap: () => cubit.openAdd(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.94),
      onTapUp: (_) => setState(() => _scale = 1),
      onTapCancel: () => setState(() => _scale = 1),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Column(
          children: [
            Container(
              height: 52.w,
              width: 52.w,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(widget.icon, color: widget.color, size: 24.w),
            ),
            SizedBox(height: 8.h),
            AppText(
              text: widget.label,
              size: 12.sp,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
              color: context.palette.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
