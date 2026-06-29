import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/app_feedback.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../core/widgets/sub_header.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../../generated/locale_keys.g.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  void _send() {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      _name.clear();
      _email.clear();
      _message.clear();
      AppFeedback.success(context, LocaleKeys.message_sent.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SubHeader(title: LocaleKeys.contactUs.tr()),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 30.h),
                children: [
                  Row(
                    children: [
                      _Contact(
                        icon: Icons.email_rounded,
                        label: 'support@pocketmind.app',
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 12.w),
                      _Contact(
                        icon: Icons.phone_rounded,
                        label: '+1 234 567',
                        color: AppColors.income,
                      ),
                    ],
                  ),
                  SizedBox(height: 22.h),
                  _Field(
                    controller: _name,
                    label: LocaleKeys.your_name.tr(),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? LocaleKeys.fill_all_fields.tr()
                        : null,
                  ),
                  SizedBox(height: 14.h),
                  _Field(
                    controller: _email,
                    label: LocaleKeys.your_email.tr(),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return LocaleKeys.fill_all_fields.tr();
                      }
                      if (!v.contains('@') || !v.contains('.')) {
                        return LocaleKeys.fill_all_fields.tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 14.h),
                  _Field(
                    controller: _message,
                    label: LocaleKeys.your_message.tr(),
                    maxLines: 5,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? LocaleKeys.fill_all_fields.tr()
                        : null,
                  ),
                  SizedBox(height: 26.h),
                  SizedBox(
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: _send,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: AppText(
                        text: LocaleKeys.send.tr(),
                        color: Colors.white,
                        size: 16.sp,
                        fontWeight: FontWeight.w700,
                        family: FontFamily.bahijJannaBold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Contact extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Contact({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SectionCard(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
        child: Column(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22.w),
            ),
            SizedBox(height: 8.h),
            AppText(
              text: label,
              size: 12.sp,
              textAlign: TextAlign.center,
              color: context.palette.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(fontSize: 15.sp, color: palette.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: palette.textSecondary, fontSize: 14.sp),
        filled: true,
        fillColor: palette.surface,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: palette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: AppColors.expense),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: AppColors.expense),
        ),
      ),
    );
  }
}
