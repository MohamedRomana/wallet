// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/cash_flow.dart';
import 'widgets/money_in_wallet.dart';
import 'widgets/quick_actions.dart';
import 'widgets/spending_category.dart';
import 'widgets/transaction.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                MoneyInWallet(),
                CashFlow(),
                SpendingCategory(),
                Transactions(),
                SizedBox(height: 300.h),
              ],
            ),
            PositionedDirectional(
              top: 450.h,
              start: 16.w,
              end: 16.w,
              child: QuickActions(),
            ),
          ],
        ),
      ),
    );
  }
}

