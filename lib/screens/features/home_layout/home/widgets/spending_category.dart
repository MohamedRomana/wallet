import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/data/models/category_model.dart';
import '../../../../../core/service/cubit/app_cubit.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/money.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../core/widgets/section_header.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../../generated/locale_keys.g.dart';

class SpendingByCategory extends StatelessWidget {
  const SpendingByCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = AppCubit.get(context);
    final breakdown = cubit.categoryBreakdown();
    final total = breakdown.fold<double>(0, (s, e) => s + e.value);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: LocaleKeys.spending_by_category.tr()),
          SizedBox(height: 16.h),
          if (breakdown.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(
                child: AppText(
                  text: LocaleKeys.no_data.tr(),
                  color: context.palette.textSecondary,
                  size: 14.sp,
                ),
              ),
            )
          else
            Row(
              children: [
                SizedBox(
                  width: 120.w,
                  height: 120.w,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 34.r,
                          sections: [
                            for (final e in breakdown)
                              PieChartSectionData(
                                value: e.value,
                                color: e.key.color,
                                radius: 22.r,
                                showTitle: false,
                              ),
                          ],
                        ),
                        duration: const Duration(milliseconds: 600),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            text: LocaleKeys.spent.tr(),
                            size: 10.sp,
                            color: context.palette.textSecondary,
                          ),
                          AppText(
                            text: Money.compact(total),
                            size: 13.sp,
                            fontWeight: FontWeight.w700,
                            family: FontFamily.bahijJannaBold,
                            color: context.palette.textPrimary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    children: [
                      for (final e in breakdown.take(4))
                        _CategoryRow(
                          category: e.key,
                          amount: e.value,
                          percent: total <= 0 ? 0 : e.value / total,
                        ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final TxCategory category;
  final double amount;
  final double percent;

  const _CategoryRow({
    required this.category,
    required this.amount,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Container(
            width: 9.w,
            height: 9.w,
            decoration: BoxDecoration(
              color: category.color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: AppText(
              text: category.nameKey.tr(),
              size: 12.5.sp,
              color: context.palette.textPrimary,
            ),
          ),
          AppText(
            text: '${(percent * 100).round()}%',
            size: 12.sp,
            fontWeight: FontWeight.w700,
            color: context.palette.textSecondary,
          ),
        ],
      ),
    );
  }
}
