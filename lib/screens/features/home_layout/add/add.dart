import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet/core/widgets/app_text.dart';
import 'package:wallet/gen/fonts.gen.dart';
import '../../../../core/constants/colors.dart';
import 'widgets/Transfer_fields.dart';
import 'widgets/expense_fields.dart';
import 'widgets/income_fields.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  Color _generateColor(int index) {
    switch (index) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.red;
      case 2:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                  gradient: LinearGradient(
                    colors: [Colors.blue, AppColors.secondray],
                    begin: AlignmentDirectional.topEnd,
                    end: AlignmentDirectional.bottomStart,
                  ),
                ),
                child: Column(
                  children: [
                    AppText(
                      text: "Add Transaction",
                      color: Colors.white,
                      size: 20.sp,
                      fontWeight: FontWeight.w700,
                      bottom: 30.h,
                      top: 30.h,
                      family: FontFamily.bahijJannaBold,
                    ),
                    Container(
                      height: 50.h,
                      width: 361.w,
                      padding: EdgeInsets.all(5.r),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(80),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: _generateColor(_tabController.index),
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: _generateColor(_tabController.index),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorWeight: 3.r,
                        indicatorPadding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        labelStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: FontFamily.bahijJannaBold,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: FontFamily.bahijJannaBold,
                        ),
                        dividerColor: Colors.transparent,
                        tabs: [
                          Tab(text: 'Income'),
                          Tab(text: 'Expense'),
                          Tab(text: 'Transfer'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Positioned(
            top: 150.h,
            child: Container(
              height: 580.h,
              width: 361.w,
              margin: EdgeInsets.only(bottom: 120.h),
              padding: EdgeInsets.all(20.r),
              child: TabBarView(
                controller: _tabController,
                children: [
                  IncomeFields(),
                  ExpenseFields(),
                  TransferFields(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

