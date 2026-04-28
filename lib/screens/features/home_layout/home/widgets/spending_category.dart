// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/cache/cache_helper.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../gen/fonts.gen.dart';

class SpendingCategory extends StatefulWidget {
  const SpendingCategory({super.key});

  @override
  State<SpendingCategory> createState() => _SpendingCategoryState();
}

class _SpendingCategoryState extends State<SpendingCategory>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pieController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pieController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _pieController]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 361.w,
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 25.h),
                decoration: BoxDecoration(
                  color: CacheHelper.getDarkMode()
                      ? Color(0xff1E2939)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Row(
                      children: [
                        AppText(
                          text: 'Spending by Category',
                          size: 18.sp,
                          color: CacheHelper.getDarkMode()
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w700,
                          family: FontFamily.bahijJannaBold,
                        ),
                        const Spacer(),
                        AppText(
                          text: 'See All',
                          size: 14.sp,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    Row(
                      children: [
                        /// 🟣 PIE CHART ANIMATED
                        SizedBox(
                          width: 140.w,
                          height: 140.w,
                          child: PieChart(
                            PieChartData(
                              startDegreeOffset: -90,
                              centerSpaceRadius: 40.r,
                              sectionsSpace: 3,

                              /// 🔥 animation
                              sections: [
                                _buildSection(
                                  CacheHelper.getDarkMode()
                                      ? Color(0xff21378E)
                                      : Colors.blue,
                                  25,
                                ),
                                _buildSection(Colors.red, 25),
                                _buildSection(Colors.orange, 25),
                                _buildSection(Colors.pink, 25),
                              ],
                            ),
                          ),
                        ),

                        const Spacer(),

                        /// 🟣 LIST (stagger animation)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildItem(
                              delay: 0,
                              color: CacheHelper.getDarkMode()
                                  ? Color(0xff21378E)
                                  : Colors.blue,
                              title: 'Food & Drinks',
                              value: '450 \$',
                            ),
                            _buildItem(
                              delay: 0.1,
                              color: Colors.red,
                              title: 'Entertainment',
                              value: '450 \$',
                            ),
                            _buildItem(
                              delay: 0.2,
                              color: Colors.orange,
                              title: 'Transportation',
                              value: '450 \$',
                            ),
                            _buildItem(
                              delay: 0.3,
                              color: Colors.pink,
                              title: 'Shopping',
                              value: '450 \$',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 🔥 PIE SECTION ANIMATION
  PieChartSectionData _buildSection(Color color, double value) {
    return PieChartSectionData(
      value: value * _pieController.value,
      color: color,
      radius: 18.r,
      showTitle: false,
    );
  }

  /// 🔥 LIST ITEM ANIMATION
  Widget _buildItem({
    required double delay,
    required Color color,
    required String title,
    required String value,
  }) {
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(delay, 1, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.2, 0),
          end: Offset.zero,
        ).animate(animation),
        child: Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Row(
            children: [
              Container(
                height: 10.w,
                width: 10.w,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
              SizedBox(width: 10.w),
              AppText(
                text: title,
                size: 14.sp,
                color: CacheHelper.getDarkMode() ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                end: 20.w,
              ),
              AppText(
                text: value,
                size: 14.sp,
                color: CacheHelper.getDarkMode() ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
