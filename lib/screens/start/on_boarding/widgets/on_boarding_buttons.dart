// ignore_for_file: deprecated_member_use
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet/core/widgets/app_router.dart';
import 'package:wallet/screens/features/home_layout/home_layout.dart';
import '../../../../core/cache/cache_helper.dart';
import '../../../../core/widgets/app_text.dart';

class CustomOnBoardingButtons extends StatefulWidget {
  const CustomOnBoardingButtons({
    super.key,
    required this.pagesList,
    required this.currPage,
    required this.pageController,
  });

  final List pagesList;
  final double currPage;
  final PageController pageController;

  @override
  State<CustomOnBoardingButtons> createState() =>
      _CustomOnBoardingButtonsState();
}

class _CustomOnBoardingButtonsState extends State<CustomOnBoardingButtons>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.reverse();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.forward();
  }

  void _onTapCancel() {
    _scaleController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      end: 16.w,
      start: 16.w,
      bottom: 48.h,
      child: Column(
        children: [
          SizedBox(height: 24.h),

          /// 🔥 Animated Switch بين Next و Get Started
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },

            child: widget.currPage <= widget.pagesList.length - 1.5
                ? _buildButton(
                    key: const ValueKey("next"),
                    text: "Next",
                    onTap: () {
                      widget.pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  )
                : _buildButton(
                    key: const ValueKey("start"),
                    text: "Get Started",

                    onTap: () {
                      CacheHelper.setLang('ar');
                      context.setLocale(const Locale('ar'));
                      AppRouter.navigateAndFinish(context, HomeLayout());
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onTap,
    required Key key,
  }) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,

      /// 🔥 Scale Animation عند الضغط
      child: AnimatedBuilder(
        animation: Listenable.merge([_gradientController, _scaleController]),
        builder: (context, child) {
          final t = _gradientController.value;

          return Transform.scale(
            scale: _scaleController.value,
            child: Container(
              width: 361.w,
              height: 57.w,
              padding: EdgeInsets.symmetric(horizontal: 15.w),

              /// 🔥 Gradient Animated
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.lerp(
                      const Color(0xFF614BFB),
                      const Color(0xFF8B5CF6),
                      t,
                    )!,
                    Color.lerp(
                      const Color(0xFF8B5CF6),
                      const Color(0xFF3B1FA8),
                      t,
                    )!,
                  ],
                  begin: Alignment(-1 + t, -1),
                  end: Alignment(1 - t, 1),
                ),
                borderRadius: BorderRadius.circular(500.r),

                /// 🔥 Glow Effect
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF614BFB).withOpacity(0.5),
                    blurRadius: 25,
                    spreadRadius: 1,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),

              child: Center(
                child: AppText(
                  text: text,
                  color: Colors.white,
                  size: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
