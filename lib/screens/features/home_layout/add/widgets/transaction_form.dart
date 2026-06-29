import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/data/models/account_model.dart';
import '../../../../../core/data/models/category_model.dart';
import '../../../../../core/data/models/transaction_model.dart';
import '../../../../../core/service/cubit/app_cubit.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/money.dart';
import '../../../../../core/widgets/app_feedback.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/category_avatar.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../../generated/locale_keys.g.dart';

class TransactionForm extends StatefulWidget {
  final TxType type;
  final TransactionModel? editing;

  /// Called after a successful save. The host screen decides what to do
  /// (pop when pushed, or reset + go home when shown as a tab).
  final VoidCallback onSaved;

  const TransactionForm({
    super.key,
    required this.type,
    required this.onSaved,
    this.editing,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String? _categoryId;
  String? _accountId;
  String? _fromAccountId;
  String? _toAccountId;
  DateTime _date = DateTime.now();

  bool get _isTransfer => widget.type == TxType.transfer;
  bool get _isIncome => widget.type == TxType.income;

  List<TxCategory> get _categories =>
      _isIncome ? Categories.income : Categories.expense;

  @override
  void initState() {
    super.initState();
    final e = widget.editing;
    if (e != null) {
      _amountController.text = e.amount
          .toStringAsFixed(e.amount.truncateToDouble() == e.amount ? 0 : 2);
      _noteController.text = e.note;
      _categoryId = e.categoryId;
      _accountId = e.accountId;
      _fromAccountId = e.fromAccountId;
      _toAccountId = e.toAccountId;
      _date = e.date;
    } else {
      final accounts = AppCubit.get(context).accounts;
      if (accounts.isNotEmpty) {
        _accountId = accounts.first.id;
        _fromAccountId = accounts.first.id;
        _toAccountId = accounts.length > 1 ? accounts[1].id : accounts.first.id;
      }
      _categoryId = _categories.first.id;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final cubit = AppCubit.get(context);
    final amount = double.tryParse(_amountController.text.trim());

    if (amount == null || amount <= 0) {
      AppFeedback.error(context, LocaleKeys.invalid_amount.tr());
      return;
    }
    if (cubit.accounts.isEmpty) {
      AppFeedback.error(context, LocaleKeys.no_accounts.tr());
      return;
    }
    if (_isTransfer) {
      if (_fromAccountId == null ||
          _toAccountId == null ||
          _fromAccountId == _toAccountId) {
        AppFeedback.error(context, LocaleKeys.transfer_same_account.tr());
        return;
      }
    } else {
      if (_categoryId == null || _accountId == null) {
        AppFeedback.error(context, LocaleKeys.fill_all_fields.tr());
        return;
      }
    }

    final tx = TransactionModel(
      id: widget.editing?.id ?? '',
      type: widget.type,
      amount: amount,
      categoryId: _isTransfer ? null : _categoryId,
      accountId: _isTransfer ? null : _accountId,
      fromAccountId: _isTransfer ? _fromAccountId : null,
      toAccountId: _isTransfer ? _toAccountId : null,
      date: _date,
      note: _noteController.text.trim(),
    );

    if (widget.editing != null) {
      await cubit.updateTransaction(tx);
    } else {
      await cubit.addTransaction(tx);
    }
    if (!mounted) return;
    AppFeedback.success(context, LocaleKeys.saved_successfully.tr());
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = AppCubit.get(context);
    final palette = context.palette;
    final accentColor = _isTransfer
        ? AppColors.primary
        : (_isIncome ? AppColors.income : AppColors.expense);

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 130.h),
      children: [
        // Amount
        _FieldCard(
          label: LocaleKeys.amount.tr(),
          child: TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
              fontFamily: FontFamily.bahijJannaBold,
              color: accentColor,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              prefixText: '${Money.symbol} ',
              prefixStyle: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: accentColor,
              ),
              hintText: '0',
              hintStyle: TextStyle(
                fontSize: 28.sp,
                color: palette.textSecondary,
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // Category (income / expense only)
        if (!_isTransfer) ...[
          _FieldCard(
            label: LocaleKeys.category.tr(),
            child: Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: [
                for (final c in _categories)
                  _CategoryChip(
                    category: c,
                    selected: _categoryId == c.id,
                    onTap: () => setState(() => _categoryId = c.id),
                  ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _FieldCard(
            label: LocaleKeys.account.tr(),
            child: _AccountSelector(
              accounts: cubit.accounts,
              selectedId: _accountId,
              onSelect: (id) => setState(() => _accountId = id),
            ),
          ),
        ] else ...[
          _FieldCard(
            label: LocaleKeys.from_account.tr(),
            child: _AccountSelector(
              accounts: cubit.accounts,
              selectedId: _fromAccountId,
              onSelect: (id) => setState(() => _fromAccountId = id),
            ),
          ),
          SizedBox(height: 16.h),
          _FieldCard(
            label: LocaleKeys.to_account.tr(),
            child: _AccountSelector(
              accounts: cubit.accounts,
              selectedId: _toAccountId,
              onSelect: (id) => setState(() => _toAccountId = id),
            ),
          ),
        ],
        SizedBox(height: 16.h),

        // Date
        _FieldCard(
          label: LocaleKeys.date.tr(),
          child: InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      size: 18.w, color: accentColor),
                  SizedBox(width: 10.w),
                  AppText(
                    text: DateFormat.yMMMMd().format(_date),
                    size: 15.sp,
                    color: palette.textPrimary,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // Note
        _FieldCard(
          label: LocaleKeys.note_optional.tr(),
          child: TextField(
            controller: _noteController,
            maxLines: 2,
            style: TextStyle(fontSize: 15.sp, color: palette.textPrimary),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintText: LocaleKeys.note.tr(),
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: palette.textSecondary,
              ),
            ),
          ),
        ),
        SizedBox(height: 26.h),

        // Save
        SizedBox(
          height: 52.h,
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
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
    );
  }
}

class _FieldCard extends StatelessWidget {
  final String label;
  final Widget child;
  const _FieldCard({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: label,
            size: 13.sp,
            fontWeight: FontWeight.w700,
            color: context.palette.textSecondary,
          ),
          SizedBox(height: 10.h),
          child,
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final TxCategory category;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected
              ? category.color.withValues(alpha: 0.18)
              : palette.surfaceAlt,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: selected ? category.color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              category.icon,
              width: 18.w,
              height: 18.w,
              colorFilter: ColorFilter.mode(category.color, BlendMode.srcIn),
            ),
            SizedBox(width: 6.w),
            AppText(
              text: category.nameKey.tr(),
              size: 13.sp,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? category.color : palette.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountSelector extends StatelessWidget {
  final List<AccountModel> accounts;
  final String? selectedId;
  final ValueChanged<String> onSelect;

  const _AccountSelector({
    required this.accounts,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: [
        for (final a in accounts)
          GestureDetector(
            onTap: () => onSelect(a.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: selectedId == a.id
                    ? a.color.withValues(alpha: 0.18)
                    : palette.surfaceAlt,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: selectedId == a.id ? a.color : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CategoryAvatar(icon: a.type.icon, color: a.color, size: 26),
                  SizedBox(width: 8.w),
                  AppText(
                    text: a.name,
                    size: 13.sp,
                    fontWeight: selectedId == a.id
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: palette.textPrimary,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
