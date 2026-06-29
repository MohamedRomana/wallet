import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/service/cubit/app_cubit.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/money.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../core/widgets/section_header.dart';
import '../../../../../generated/locale_keys.g.dart';

class CashFlowCard extends StatelessWidget {
  const CashFlowCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = AppCubit.get(context);
    final points = cubit.monthlyCashFlow(6);
    final maxVal = points
        .map((p) => p.income > p.expense ? p.income : p.expense)
        .fold<double>(0, (m, v) => v > m ? v : m);
    final maxY = (maxVal <= 0 ? 100.0 : maxVal * 1.25);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: LocaleKeys.cash_flow.tr()),
          SizedBox(height: 4.h),
          Row(
            children: [
              _Legend(color: AppColors.income, label: LocaleKeys.income.tr()),
              SizedBox(width: 16.w),
              _Legend(color: AppColors.expense, label: LocaleKeys.expense.tr()),
            ],
          ),
          SizedBox(height: 18.h),
          SizedBox(
            height: 170.h,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.primary,
                    getTooltipItem: (group, gi, rod, ri) => BarTooltipItem(
                      Money.compact(rod.toY),
                      TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24.h,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= points.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.only(top: 6.h),
                          child: Text(
                            DateFormat.MMM().format(points[i].month),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: context.palette.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 4,
                  getDrawingHorizontalLine: (v) => FlLine(
                    color: context.palette.border,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  for (int i = 0; i < points.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: points[i].income,
                          color: AppColors.income,
                          width: 7.w,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        BarChartRodData(
                          toY: points[i].expense,
                          color: AppColors.expense,
                          width: 7.w,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ],
                    ),
                ],
              ),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        AppText(
          text: label,
          size: 12.sp,
          color: context.palette.textSecondary,
        ),
      ],
    );
  }
}
