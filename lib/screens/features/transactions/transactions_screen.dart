import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors.dart';
import '../../../core/data/models/transaction_model.dart';
import '../../../core/service/cubit/app_cubit.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../../core/widgets/app_router.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/sub_header.dart';
import '../../../core/widgets/transaction_tile.dart';
import '../../../generated/locale_keys.g.dart';
import 'transaction_details.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          final cubit = AppCubit.get(context);
          final txs = cubit.sortedTransactions;
          // group by day
          final groups = <String, List<TransactionModel>>{};
          for (final t in txs) {
            final key = DateFormat.yMMMMd().format(t.date);
            groups.putIfAbsent(key, () => []).add(t);
          }

          return Column(
            children: [
              SubHeader(title: LocaleKeys.recent_transactions.tr()),
              Expanded(
                child: txs.isEmpty
                    ? EmptyState(message: LocaleKeys.no_transactions.tr())
                    : AnimationLimiter(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 30.h),
                          children: AnimationConfiguration.toStaggeredList(
                            duration: const Duration(milliseconds: 400),
                            childAnimationBuilder: (w) => SlideAnimation(
                              verticalOffset: 30.h,
                              child: FadeInAnimation(child: w),
                            ),
                            children: [
                              for (final entry in groups.entries) ...[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      4.w, 8.h, 4.w, 6.h),
                                  child: AppText(
                                    text: entry.key,
                                    size: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: context.palette.textSecondary,
                                  ),
                                ),
                                for (final tx in entry.value)
                                  _Slidable(tx: tx),
                              ],
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Slidable extends StatelessWidget {
  final TransactionModel tx;
  const _Slidable({required this.tx});

  @override
  Widget build(BuildContext context) {
    final cubit = AppCubit.get(context);
    return Slidable(
      key: ValueKey(tx.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          CustomSlidableAction(
            backgroundColor: AppColors.expense,
            borderRadius: BorderRadius.circular(14.r),
            onPressed: (_) async {
              final ok = await AppFeedback.confirmDelete(context);
              if (ok) {
                await cubit.deleteTransaction(tx.id);
                if (context.mounted) {
                  AppFeedback.success(
                    context, LocaleKeys.deleted_successfully.tr());
                }
              }
            },
            child: Icon(Icons.delete_rounded, color: Colors.white, size: 24.w),
          ),
        ],
      ),
      child: TransactionTile(
        tx: tx,
        onTap: () =>
            AppRouter.navigateTo(context, TransactionDetails(tx: tx)),
      ),
    );
  }
}
