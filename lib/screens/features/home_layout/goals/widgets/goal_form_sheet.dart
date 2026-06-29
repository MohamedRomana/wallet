import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/data/models/goal_model.dart';
import '../../../../../core/service/cubit/app_cubit.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/app_feedback.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../../generated/locale_keys.g.dart';
import 'widgets_shared.dart';

const List<String> kGoalIcons = [
  'assets/svg/goal.svg',
  'assets/svg/emerg.svg',
  'assets/svg/vact.svg',
  'assets/svg/lap.svg',
  'assets/svg/house.svg',
  'assets/svg/car.svg',
  'assets/svg/heart.svg',
  'assets/svg/bag.svg',
];

const List<int> kGoalColors = [
  0xFF2563EB,
  0xFF10B981,
  0xFF8B5CF6,
  0xFFF59E0B,
  0xFFEF4444,
  0xFF06B6D4,
  0xFFEC4899,
];

Future<void> showGoalForm(BuildContext context, {GoalModel? goal}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _GoalFormSheet(goal: goal),
  );
}

class _GoalFormSheet extends StatefulWidget {
  final GoalModel? goal;
  const _GoalFormSheet({this.goal});

  @override
  State<_GoalFormSheet> createState() => _GoalFormSheetState();
}

class _GoalFormSheetState extends State<_GoalFormSheet> {
  late final TextEditingController _title;
  late final TextEditingController _target;
  late final TextEditingController _saved;
  DateTime? _deadline;
  late String _icon;
  late int _color;

  bool get _isEditing => widget.goal != null;

  String _num(double v) =>
      v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 2);

  @override
  void initState() {
    super.initState();
    final g = widget.goal;
    _title = TextEditingController(text: g?.title ?? '');
    _target = TextEditingController(text: g == null ? '' : _num(g.targetAmount));
    _saved = TextEditingController(text: g == null ? '' : _num(g.savedAmount));
    _deadline = g?.deadline;
    _icon = g?.icon ?? kGoalIcons.first;
    _color = g?.colorValue ?? kGoalColors.first;
  }

  @override
  void dispose() {
    _title.dispose();
    _target.dispose();
    _saved.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now().add(const Duration(days: 90)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  Future<void> _save() async {
    final cubit = AppCubit.get(context);
    final title = _title.text.trim();
    final target = double.tryParse(_target.text.trim());
    final saved = double.tryParse(_saved.text.trim()) ?? 0;

    if (title.isEmpty) {
      AppFeedback.error(context, LocaleKeys.fill_all_fields.tr());
      return;
    }
    if (target == null || target <= 0) {
      AppFeedback.error(context, LocaleKeys.invalid_amount.tr());
      return;
    }

    final goal = GoalModel(
      id: widget.goal?.id ?? cubit.newId(),
      title: title,
      targetAmount: target,
      savedAmount: saved,
      deadline: _deadline,
      icon: _icon,
      colorValue: _color,
    );
    await cubit.saveGoal(goal);
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
                    ? LocaleKeys.edit_goal.tr()
                    : LocaleKeys.add_goal.tr(),
                size: 18.sp,
                fontWeight: FontWeight.w700,
                family: FontFamily.bahijJannaBold,
                color: palette.textPrimary,
              ),
              SizedBox(height: 18.h),

              GoalFieldLabel(LocaleKeys.goal_title.tr()),
              GoalTextField(controller: _title),
              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GoalFieldLabel(LocaleKeys.target_amount.tr()),
                        GoalTextField(
                          controller: _target,
                          number: true,
                          hint: '0',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GoalFieldLabel(LocaleKeys.saved_amount.tr()),
                        GoalTextField(
                          controller: _saved,
                          number: true,
                          hint: '0',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              GoalFieldLabel(LocaleKeys.deadline.tr()),
              InkWell(
                onTap: _pickDeadline,
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: palette.surfaceAlt,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          size: 18.w, color: Color(_color)),
                      SizedBox(width: 10.w),
                      AppText(
                        text: _deadline == null
                            ? LocaleKeys.select_date.tr()
                            : DateFormat.yMMMMd().format(_deadline!),
                        size: 14.sp,
                        color: _deadline == null
                            ? palette.textSecondary
                            : palette.textPrimary,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              GoalFieldLabel(LocaleKeys.color.tr()),
              Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: [
                  for (final c in kGoalColors)
                    GestureDetector(
                      onTap: () => setState(() => _color = c),
                      child: Container(
                        width: 32.w,
                        height: 32.w,
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
                            ? Icon(Icons.check, color: Colors.white, size: 16.w)
                            : null,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16.h),

              const GoalFieldLabel('Icon'),
              Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: [
                  for (final ic in kGoalIcons)
                    GestureDetector(
                      onTap: () => setState(() => _icon = ic),
                      child: Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: BoxDecoration(
                          color: _icon == ic
                              ? Color(_color).withValues(alpha: 0.18)
                              : palette.surfaceAlt,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: _icon == ic
                                ? Color(_color)
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          ic,
                          width: 22.w,
                          height: 22.w,
                          colorFilter:
                              ColorFilter.mode(Color(_color), BlendMode.srcIn),
                        ),
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
