import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/colors.dart';
import '../../../core/service/cubit/app_cubit.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../../core/widgets/app_router.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/section_card.dart';
import '../../../core/widgets/sub_header.dart';
import '../../../gen/fonts.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../drawer_items/about_us/ui/about_us.dart';
import '../drawer_items/contact_us/ui/contact_us.dart';
import '../drawer_items/privacy_policy/ui/privacy_policy.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          final cubit = AppCubit.get(context);
          final palette = context.palette;
          final isArabic = context.locale.languageCode == 'ar';

          return Column(
            children: [
              SubHeader(title: LocaleKeys.settings.tr()),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 30.h),
                  children: [
                    _GroupLabel(LocaleKeys.preferences.tr()),
                    SectionCard(
                      child: Column(
                        children: [
                          // Language
                          _Row(
                            icon: Icons.language_rounded,
                            color: AppColors.accent,
                            title: LocaleKeys.language.tr(),
                            trailing: _LangSwitch(
                              isArabic: isArabic,
                              onChanged: (ar) => cubit.changeLanguage(
                                  context, ar ? 'ar' : 'en'),
                            ),
                          ),
                          _Divider(palette.border),
                          // Dark mode
                          _Row(
                            icon: context.isDark
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            color: AppColors.warning,
                            title: context.isDark
                                ? LocaleKeys.dark_mode.tr()
                                : LocaleKeys.light_mode.tr(),
                            trailing: Switch.adaptive(
                              value: cubit.isDark,
                              activeTrackColor: AppColors.primary,
                              onChanged: (v) => cubit.toggleTheme(v),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 22.h),

                    _GroupLabel(LocaleKeys.general.tr()),
                    SectionCard(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Column(
                        children: [
                          _Row(
                            icon: Icons.headset_mic_rounded,
                            color: AppColors.primary,
                            title: LocaleKeys.contactUs.tr(),
                            onTap: () => AppRouter.navigateTo(
                                context, const ContactUs()),
                          ),
                          _Divider(palette.border),
                          _Row(
                            icon: Icons.privacy_tip_rounded,
                            color: AppColors.secondary,
                            title: LocaleKeys.privacy_policy.tr(),
                            onTap: () => AppRouter.navigateTo(
                                context, const PrivacyPolicy()),
                          ),
                          _Divider(palette.border),
                          _Row(
                            icon: Icons.info_rounded,
                            color: AppColors.income,
                            title: LocaleKeys.aboutus.tr(),
                            onTap: () => AppRouter.navigateTo(
                                context, const AboutUs()),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 22.h),

                    SectionCard(
                      child: _Row(
                        icon: Icons.restart_alt_rounded,
                        color: AppColors.expense,
                        title: LocaleKeys.reset_data.tr(),
                        subtitle: LocaleKeys.reset_data_desc.tr(),
                        onTap: () => _resetData(context, cubit),
                      ),
                    ),
                    SizedBox(height: 26.h),
                    Center(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/walet.svg',
                            width: 32.w,
                            colorFilter: ColorFilter.mode(
                                palette.textSecondary, BlendMode.srcIn),
                          ),
                          SizedBox(height: 8.h),
                          AppText(
                            text: '${LocaleKeys.app_name.tr()}  ·  '
                                '${LocaleKeys.version.tr()} 1.0.0',
                            size: 12.sp,
                            color: palette.textSecondary,
                          ),
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

  Future<void> _resetData(BuildContext context, AppCubit cubit) async {
    final ok = await AppFeedback.confirmDelete(
      context,
      title: LocaleKeys.reset_data.tr(),
      message: LocaleKeys.reset_data_desc.tr(),
    );
    if (ok) {
      await cubit.resetAllData();
      if (context.mounted) {
        AppFeedback.success(context, LocaleKeys.data_reset.tr());
      }
    }
  }
}

class _GroupLabel extends StatelessWidget {
  final String text;
  const _GroupLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 6.w, bottom: 10.h),
      child: AppText(
        text: text,
        size: 13.sp,
        fontWeight: FontWeight.w700,
        color: context.palette.textSecondary,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final Color color;
  const _Divider(this.color);
  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, color: color, indent: 56.w);
}

class _Row extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _Row({
    required this.icon,
    required this.color,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: color, size: 20.w),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: title,
                    size: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: palette.textPrimary,
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    AppText(
                      text: subtitle!,
                      size: 11.5.sp,
                      lines: 2,
                      color: palette.textSecondary,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              Icon(Icons.chevron_right_rounded,
                  color: palette.textSecondary, size: 22.w),
          ],
        ),
      ),
    );
  }
}

class _LangSwitch extends StatelessWidget {
  final bool isArabic;
  final ValueChanged<bool> onChanged;
  const _LangSwitch({required this.isArabic, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        color: context.palette.surfaceAlt,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          _seg('EN', !isArabic, () => onChanged(false)),
          _seg('ع', isArabic, () => onChanged(true)),
        ],
      ),
    );
  }

  Widget _seg(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: AppText(
          text: label,
          size: 13.sp,
          fontWeight: FontWeight.w700,
          family: FontFamily.bahijJannaBold,
          color: active ? Colors.white : null,
        ),
      ),
    );
  }
}
