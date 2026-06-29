import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/data/models/transaction_model.dart';
import '../../../../core/service/cubit/app_cubit.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../core/widgets/sub_header.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../../generated/locale_keys.g.dart';
import 'widgets/transaction_form.dart';

class Add extends StatefulWidget {
  /// When non-null the screen opens in edit mode for this transaction.
  final TransactionModel? editing;
  const Add({super.key, this.editing});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  bool get _isEditing => widget.editing != null;

  @override
  void initState() {
    super.initState();
    if (!_isEditing) {
      _tabController = TabController(
        length: 3,
        vsync: this,
        initialIndex: AppCubit.get(context).addInitialTab.clamp(0, 2),
      );
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _onSavedFromTab() {
    // After adding from the bottom-nav tab, jump back to Home.
    AppCubit.get(context).changebottomNavIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      final tx = widget.editing!;
      return Scaffold(
        body: Column(
          children: [
            SubHeader(title: LocaleKeys.edit.tr()),
            Expanded(
              child: TransactionForm(
                type: tx.type,
                editing: tx,
                onSaved: () => Navigator.of(context).maybePop(),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          GradientHeader(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 18.h),
              child: Column(
                children: [
                  AppText(
                    text: LocaleKeys.add_transaction.tr(),
                    size: 20.sp,
                    fontWeight: FontWeight.w700,
                    family: FontFamily.bahijJannaBold,
                    color: Colors.white,
                    bottom: 18.h,
                  ),
                  Container(
                    height: 46.h,
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: Colors.white,
                      labelStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: FontFamily.bahijJannaBold,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: [
                        Tab(text: LocaleKeys.income.tr()),
                        Tab(text: LocaleKeys.expense.tr()),
                        Tab(text: LocaleKeys.transfer.tr()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                TransactionForm(
                  type: TxType.income,
                  onSaved: _onSavedFromTab,
                ),
                TransactionForm(
                  type: TxType.expense,
                  onSaved: _onSavedFromTab,
                ),
                TransactionForm(
                  type: TxType.transfer,
                  onSaved: _onSavedFromTab,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
