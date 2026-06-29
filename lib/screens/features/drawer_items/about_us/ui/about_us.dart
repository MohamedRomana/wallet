import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../core/widgets/sub_header.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../../generated/locale_keys.g.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    final palette = context.palette;

    final paragraph = isAr
        ? 'PocketMind هو تطبيق محفظة شخصية يساعدك على تتبّع دخلك ومصروفاتك، '
              'وإدارة حساباتك المتعددة، وضبط ميزانيات شهرية لكل فئة، وتحقيق '
              'أهدافك المالية. كل بياناتك محفوظة على جهازك وتعمل بالكامل بدون إنترنت.'
        : 'PocketMind is a personal finance app that helps you track your '
              'income and expenses, manage multiple accounts, set monthly '
              'budgets per category, and reach your savings goals. All your '
              'data is stored privately on your device and works fully offline.';

    final features = isAr
        ? const [
            'تتبّع الدخل والمصروفات والتحويلات',
            'حسابات متعددة برصيد محسوب تلقائياً',
            'ميزانيات شهرية لكل فئة',
            'أهداف ادخار بتتبّع التقدّم',
            'رسوم بيانية وتحليلات واضحة',
          ]
        : const [
            'Track income, expenses and transfers',
            'Multiple accounts with auto-computed balances',
            'Monthly budgets per category',
            'Savings goals with progress tracking',
            'Clear charts and analytics',
          ];

    return Scaffold(
      body: Column(
        children: [
          SubHeader(title: LocaleKeys.aboutus.tr()),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 30.h),
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 84.w,
                        height: 84.w,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                          ),
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/svg/walet.svg',
                          width: 40.w,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      AppText(
                        text: LocaleKeys.app_name.tr(),
                        size: 22.sp,
                        fontWeight: FontWeight.w800,
                        family: FontFamily.bahijJannaBold,
                        color: palette.textPrimary,
                      ),
                      AppText(
                        text: LocaleKeys.app_subtitle.tr(),
                        size: 13.sp,
                        color: palette.textSecondary,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                SectionCard(
                  child: AppText(
                    text: paragraph,
                    size: 14.sp,
                    lines: 20,
                    overflow: TextOverflow.visible,
                    color: palette.textPrimary,
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(height: 16.h),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final f in features)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 7.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.check_circle_rounded,
                                  color: AppColors.income, size: 20.w),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: AppText(
                                  text: f,
                                  size: 14.sp,
                                  lines: 2,
                                  overflow: TextOverflow.visible,
                                  color: palette.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
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
