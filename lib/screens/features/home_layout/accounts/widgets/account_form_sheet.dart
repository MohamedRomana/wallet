import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/data/models/account_model.dart';
import '../../../../../core/service/cubit/app_cubit.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/app_feedback.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../../generated/locale_keys.g.dart';

const List<int> kAccountColors = [
  0xFF2563EB,
  0xFF10B981,
  0xFF8B5CF6,
  0xFFF59E0B,
  0xFFEF4444,
  0xFF06B6D4,
  0xFFEC4899,
  0xFF64748B,
];

/// Shows the add/edit account modal. Pass [account] to edit.
Future<void> showAccountForm(BuildContext context, {AccountModel? account}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AccountFormSheet(account: account),
  );
}

class _AccountFormSheet extends StatefulWidget {
  final AccountModel? account;
  const _AccountFormSheet({this.account});

  @override
  State<_AccountFormSheet> createState() => _AccountFormSheetState();
}

class _AccountFormSheetState extends State<_AccountFormSheet> {
  late final TextEditingController _name;
  late final TextEditingController _balance;
  late AccountType _type;
  late int _color;

  bool get _isEditing => widget.account != null;

  @override
  void initState() {
    super.initState();
    final a = widget.account;
    _name = TextEditingController(text: a?.name ?? '');
    _balance = TextEditingController(
      text: a == null
          ? ''
          : a.openingBalance.toStringAsFixed(
              a.openingBalance.truncateToDouble() == a.openingBalance ? 0 : 2),
    );
    _type = a?.type ?? AccountType.cash;
    _color = a?.colorValue ?? kAccountColors.first;
  }

  @override
  void dispose() {
    _name.dispose();
    _balance.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final cubit = AppCubit.get(context);
    final name = _name.text.trim();
    if (name.isEmpty) {
      AppFeedback.error(context, LocaleKeys.fill_all_fields.tr());
      return;
    }
    final balance = double.tryParse(_balance.text.trim()) ?? 0;

    if (_isEditing) {
      await cubit.updateAccount(
        widget.account!.copyWith(
          name: name,
          type: _type,
          openingBalance: balance,
          colorValue: _color,
        ),
      );
    } else {
      await cubit.addAccount(
        name: name,
        type: _type,
        openingBalance: balance,
        colorValue: _color,
      );
    }
    if (!mounted) return;
    Navigator.pop(context);
    AppFeedback.success(context, LocaleKeys.saved_successfully.tr());
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 24.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: palette.border,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              AppText(
                text: _isEditing
                    ? LocaleKeys.edit_account.tr()
                    : LocaleKeys.add_account.tr(),
                size: 18.sp,
                fontWeight: FontWeight.w700,
                family: FontFamily.bahijJannaBold,
                color: palette.textPrimary,
              ),
              SizedBox(height: 18.h),

              _Label(LocaleKeys.account_name.tr()),
              _Field(controller: _name),
              SizedBox(height: 16.h),

              _Label(LocaleKeys.account_type.tr()),
              Row(
                children: [
                  for (final t in AccountType.values) ...[
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _type = t),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          margin: EdgeInsets.only(right: 8.w),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _type == t
                                ? Color(_color).withValues(alpha: 0.16)
                                : palette.surfaceAlt,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: _type == t
                                  ? Color(_color)
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: AppText(
                            text: t.nameKey.tr(),
                            size: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: palette.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 16.h),

              _Label(LocaleKeys.opening_balance.tr()),
              _Field(
                controller: _balance,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d{0,2}')),
                ],
                hint: '0',
              ),
              SizedBox(height: 16.h),

              _Label(LocaleKeys.color.tr()),
              Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: [
                  for (final c in kAccountColors)
                    GestureDetector(
                      onTap: () => setState(() => _color = c),
                      child: Container(
                        width: 34.w,
                        height: 34.w,
                        decoration: BoxDecoration(
                          color: Color(c),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _color == c
                                ? palette.textPrimary
                                : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                        child: _color == c
                            ? Icon(Icons.check,
                                color: Colors.white, size: 18.w)
                            : null,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 26.h),

              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(_color),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: AppText(
                    text: LocaleKeys.save.tr(),
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
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: AppText(
        text: text,
        size: 13.sp,
        fontWeight: FontWeight.w700,
        color: context.palette.textSecondary,
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? hint;

  const _Field({
    required this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: TextStyle(fontSize: 15.sp, color: palette.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: palette.textSecondary, fontSize: 14.sp),
        filled: true,
        fillColor: palette.surfaceAlt,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
