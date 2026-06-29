import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/data/models/budget_model.dart';
import '../../../../../core/data/models/category_model.dart';
import '../../../../../core/service/cubit/app_cubit.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/app_feedback.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../../generated/locale_keys.g.dart';

Future<void> showBudgetForm(BuildContext context, {BudgetModel? budget}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _BudgetFormSheet(budget: budget),
  );
}

class _BudgetFormSheet extends StatefulWidget {
  final BudgetModel? budget;
  const _BudgetFormSheet({this.budget});

  @override
  State<_BudgetFormSheet> createState() => _BudgetFormSheetState();
}

class _BudgetFormSheetState extends State<_BudgetFormSheet> {
  late final TextEditingController _limit;
  late String _categoryId;

  bool get _isEditing => widget.budget != null;

  @override
  void initState() {
    super.initState();
    final b = widget.budget;
    _limit = TextEditingController(
      text: b == null
          ? ''
          : b.limit.toStringAsFixed(
              b.limit.truncateToDouble() == b.limit ? 0 : 2),
    );
    _categoryId = b?.categoryId ?? Categories.expense.first.id;
  }

  @override
  void dispose() {
    _limit.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final cubit = AppCubit.get(context);
    final limit = double.tryParse(_limit.text.trim());
    if (limit == null || limit <= 0) {
      AppFeedback.error(context, LocaleKeys.invalid_amount.tr());
      return;
    }
    // Reuse an existing budget for the same category instead of duplicating.
    final existing = cubit.budgets.where((b) => b.categoryId == _categoryId);
    final id = widget.budget?.id ??
        (existing.isNotEmpty ? existing.first.id : cubit.newId());

    await cubit.saveBudget(
      BudgetModel(id: id, categoryId: _categoryId, limit: limit),
    );
    if (!mounted) return;
    Navigator.pop(context);
    AppFeedback.success(context, LocaleKeys.saved_successfully.tr());
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                    ? LocaleKeys.edit_budget.tr()
                    : LocaleKeys.set_budget.tr(),
                size: 18.sp,
                fontWeight: FontWeight.w700,
                family: FontFamily.bahijJannaBold,
                color: palette.textPrimary,
              ),
              SizedBox(height: 18.h),
              AppText(
                text: LocaleKeys.category.tr(),
                size: 13.sp,
                fontWeight: FontWeight.w700,
                color: palette.textSecondary,
                bottom: 10.h,
              ),
              Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: [
                  for (final c in Categories.expense)
                    GestureDetector(
                      onTap: _isEditing
                          ? null
                          : () => setState(() => _categoryId = c.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: _categoryId == c.id
                              ? c.color.withValues(alpha: 0.18)
                              : palette.surfaceAlt,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: _categoryId == c.id
                                ? c.color
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              c.icon,
                              width: 18.w,
                              height: 18.w,
                              colorFilter:
                                  ColorFilter.mode(c.color, BlendMode.srcIn),
                            ),
                            SizedBox(width: 6.w),
                            AppText(
                              text: c.nameKey.tr(),
                              size: 13.sp,
                              color: palette.textPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 18.h),
              AppText(
                text: LocaleKeys.budget_limit.tr(),
                size: 13.sp,
                fontWeight: FontWeight.w700,
                color: palette.textSecondary,
                bottom: 10.h,
              ),
              TextField(
                controller: _limit,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                style: TextStyle(fontSize: 16.sp, color: palette.textPrimary),
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle:
                      TextStyle(color: palette.textSecondary, fontSize: 14.sp),
                  filled: true,
                  fillColor: palette.surfaceAlt,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 26.h),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Categories.resolve(_categoryId).color,
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
