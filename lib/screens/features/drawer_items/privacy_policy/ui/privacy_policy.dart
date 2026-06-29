import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../core/widgets/sub_header.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../../generated/locale_keys.g.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    final palette = context.palette;

    final sections = isAr
        ? const [
            [
              'بياناتك ملكك',
              'كل المعلومات المالية التي تدخلها تُحفظ محلياً على جهازك فقط. '
                  'نحن لا نرسل بياناتك إلى أي خادم ولا نشاركها مع أي طرف ثالث.',
            ],
            [
              'يعمل بدون إنترنت',
              'التطبيق يعمل بالكامل بدون اتصال بالإنترنت. لا يتم جمع أي بيانات '
                  'تحليلية أو تتبّع لموقعك.',
            ],
            [
              'الأذونات',
              'لا يطلب التطبيق أذونات حسّاسة. أي صلاحيات تُستخدم فقط لتشغيل '
                  'ميزات اختارها المستخدم بنفسه.',
            ],
            [
              'حذف البيانات',
              'يمكنك حذف كل بياناتك في أي وقت من شاشة الإعدادات عبر خيار '
                  '"إعادة تعيين البيانات".',
            ],
          ]
        : const [
            [
              'Your data is yours',
              'All the financial information you enter is stored locally on '
                  'your device only. We never send your data to any server or '
                  'share it with third parties.',
            ],
            [
              'Works offline',
              'The app works fully offline. No analytics are collected and your '
                  'location is never tracked.',
            ],
            [
              'Permissions',
              'The app does not request sensitive permissions. Any capability '
                  'used is solely to power features you choose to use.',
            ],
            [
              'Deleting your data',
              'You can erase all your data at any time from the Settings screen '
                  'using the "Reset Data" option.',
            ],
          ];

    return Scaffold(
      body: Column(
        children: [
          SubHeader(title: LocaleKeys.privacy_policy.tr()),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 30.h),
              children: [
                for (final s in sections)
                  Padding(
                    padding: EdgeInsets.only(bottom: 14.h),
                    child: SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: s[0],
                            size: 16.sp,
                            fontWeight: FontWeight.w700,
                            family: FontFamily.bahijJannaBold,
                            color: palette.textPrimary,
                          ),
                          SizedBox(height: 8.h),
                          AppText(
                            text: s[1],
                            size: 13.5.sp,
                            lines: 10,
                            overflow: TextOverflow.visible,
                            color: palette.textSecondary,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
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
