import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet/core/widgets/app_text.dart';
import 'package:wallet/gen/fonts.gen.dart';
import '../../../../core/cache/cache_helper.dart';
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
  late final AnimationController _gradientController;

  late TabController _tabController;

  @override
  void initState() {
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  Color _generateColor(int index) {
    switch (index) {
      case 0:
        return CacheHelper.getDarkMode() ? Color(0xff21378E) : Colors.blue;
      case 1:
        return Colors.red;
      case 2:
        return Colors.green;
      default:
        return CacheHelper.getDarkMode() ? Color(0xff21378E) : Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_gradientController]),
      builder: (context, child) {
        final t = _gradientController.value;

        return Scaffold(
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            height: 50.h,
            width: 361.w,
            margin: EdgeInsetsDirectional.only(
              start: 20.w,
              end: 20.w,
              bottom: 100.h,
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: _generateColor(_tabController.index),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: AppText(
                text:
                    "Save ${_tabController.index == 0
                        ? "Income"
                        : _tabController.index == 1
                        ? "Expense"
                        : "Transfer"}",
                color: Colors.white,
                size: 16.sp,
                fontWeight: FontWeight.w700,
                family: FontFamily.bahijJannaBold,
              ),
            ),
          ),
          body: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsetsDirectional.only(
                      start: 16.w,
                      end: 16.w,
                      top: 30.h,
                      bottom: 100.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.lerp(
                            AppColors.primary,
                            const Color(0xFF8B5CF6),
                            t,
                          )!,
                          Color.lerp(
                            AppColors.secondray,
                            const Color(0xFF3B1FA8),
                            t,
                          )!,
                          Color.lerp(
                            const Color(0xFF4C35E0),
                            AppColors.primary,
                            t,
                          )!,
                        ],
                        begin: Alignment(
                          lerpDouble(1.0, -1.0, t)!,
                          lerpDouble(-1.0, 1.0, t)!,
                        ),
                        end: Alignment(
                          lerpDouble(-1.0, 1.0, t)!,
                          lerpDouble(1.0, -1.0, t)!,
                        ),
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24.r),
                        bottomRight: Radius.circular(24.r),
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
                            indicatorColor: _generateColor(
                              _tabController.index,
                            ),
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
                  height: 600.h,
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
      },
    );
  }
}
