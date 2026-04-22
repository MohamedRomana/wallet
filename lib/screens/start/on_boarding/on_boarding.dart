// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/service/cubit/app_cubit.dart';
import '../../../core/widgets/app_text.dart';
import '../../../generated/locale_keys.g.dart';
import 'widgets/on_boarding_buttons.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> with TickerProviderStateMixin {
  double currPage = 0.0;
  late PageController pageController;
  late AnimationController _gradientController;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  List pageList = [
    {
      'image': 'assets/svg/secure.svg',
      'title': 'Secure & Private',
      'titleAr': 'آمن وخاص',
      'subtitle':
          'Your financial data stays on your device. Complete offline functionality.',
      'subtitleAr':
          'تبقى بياناتك المالية على جهازك. وظائف غير متصلة بالإنترنت بالكامل.',
    },
    {
      'image': 'assets/svg/track.svg',
      'title': 'Track Everything',
      'titleAr': 'تتبع كل شيء',
      'subtitle':
          'Monitor income, expenses, and transfers across multiple accounts.',
      'subtitleAr': 'راقب الدخل والنفقات والتحويلات عبر حسابات متعددة.',
    },
    {
      'image': 'assets/svg/goal.svg',
      'title': 'Achieve Goals',
      'titleAr': 'حقق الأهداف',
      'subtitle':
          'Set financial goals and track your progress with visual insights.',
      'subtitleAr': 'حدد أهدافك المالية وتتبع تقدمك برؤى مرئية.',
    },
    {
      'image': 'assets/svg/arrows.svg',
      'title': 'Smart Analytics',
      'titleAr': 'تحليلات ذكية',
      'subtitle': 'Get detailed reports and understand your spending patterns.',
      'subtitleAr': 'احصل على تقارير مفصلة وافهم أنماط إنفاقك.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: -18.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: -18.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 65,
      ),
    ]).animate(_bounceController);
    pageController = PageController()
      ..addListener(() {
        setState(() {
          currPage = pageController.page!;
        });
      });

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    pageController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return AnimatedBuilder(
          animation: _gradientController,
          builder: (context, child) {
            final t = _gradientController.value;

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.lerp(
                      const Color(0xFF614BFB),
                      const Color(0xFF8B5CF6),
                      t,
                    )!,
                    Color.lerp(
                      const Color(0xFF751BDC),
                      const Color(0xFF3B1FA8),
                      t,
                    )!,
                    Color.lerp(
                      const Color(0xFF4C35E0),
                      const Color(0xFF614BFB),
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
              ),
              child: child,
            );
          },
          child: SafeArea(
            bottom: false,
            top: false,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  /// 🔥 PageView
                  PageView.builder(
                    controller: pageController,
                    itemCount: pageList.length,
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: pageController,
                        builder: (context, child) {
                          double value = 1;
                          if (pageController.position.haveDimensions) {
                            value = pageController.page! - index;
                            value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                          }

                          return Transform.scale(
                            scale: value,
                            child: Opacity(opacity: value, child: child),
                          );
                        },
                        child: Stack(
                          children: [
                            PositionedDirectional(
                              top: 150.h,
                              start: 40.w,
                              end: 40.w,
                              child: Column(
                                children: [
                                  /// 🔥 صورة Bounce
                                  AnimatedBuilder(
                                    animation: _bounceAnimation,
                                    builder: (context, child) {
                                      return Transform.translate(
                                        offset: Offset(
                                          0,
                                          _bounceAnimation.value,
                                        ),
                                        child: child,
                                      );
                                    },
                                    child: Container(
                                      height: 200.w,
                                      width: 200.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF614BFB),
                                            Color(0xFF8B5CF6),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF614BFB,
                                            ).withOpacity(0.5),
                                            blurRadius: 30,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          pageList[index]['image'],
                                          color: Colors.white,
                                          height: 120.w,
                                        ),
                                      ),
                                    ),
                                  ),

                                  /// 🔥 Title Animation
                                  TweenAnimationBuilder(
                                    duration: const Duration(milliseconds: 700),
                                    tween: Tween(begin: 40.0, end: 0.0),
                                    builder: (context, offset, child) {
                                      return Transform.translate(
                                        offset: Offset(0, offset),
                                        child: Opacity(
                                          opacity: (1 - offset / 40).clamp(
                                            0,
                                            1,
                                          ),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: AppText(
                                      top: 24.h,
                                      text: pageList[index]['title'],
                                      size: 30.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  /// 🔥 Subtitle AR
                                  TweenAnimationBuilder(
                                    duration: const Duration(milliseconds: 900),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    builder: (context, opacity, child) {
                                      return Opacity(
                                        opacity: opacity,
                                        child: child,
                                      );
                                    },
                                    child: AppText(
                                      text: pageList[index]['titleAr'],
                                      bottom: 10.h,
                                      size: 20.sp,
                                      color: Colors.white,
                                    ),
                                  ),

                                  /// 🔥 Subtitle EN
                                  TweenAnimationBuilder(
                                    duration: const Duration(
                                      milliseconds: 1100,
                                    ),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    builder: (context, opacity, child) {
                                      return Opacity(
                                        opacity: opacity,
                                        child: child,
                                      );
                                    },
                                    child: AppText(
                                      text: pageList[index]['subtitle'],
                                      size: 16.sp,
                                      lines: 3,
                                      top: 10.h,
                                      bottom: 15.h,
                                      textAlign: TextAlign.center,
                                      color: Colors.white,
                                    ),
                                  ),

                                  TweenAnimationBuilder(
                                    duration: const Duration(
                                      milliseconds: 1300,
                                    ),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    builder: (context, opacity, child) {
                                      return Opacity(
                                        opacity: opacity,
                                        child: child,
                                      );
                                    },
                                    child: AppText(
                                      text: pageList[index]['subtitleAr'],
                                      size: 16.sp,
                                      lines: 3,
                                      textAlign: TextAlign.center,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// 🔥 Buttons
                            CustomOnBoardingButtons(
                              pagesList: pageList,
                              currPage: currPage,
                              pageController: pageController,
                            ),

                            /// 🔥 Skip Animation
                            PositionedDirectional(
                              top: 60.h,
                              start: 20.w,
                              child: TweenAnimationBuilder(
                                duration: const Duration(milliseconds: 600),
                                tween: Tween(begin: -50.0, end: 0.0),
                                builder: (context, offset, child) {
                                  return Transform.translate(
                                    offset: Offset(offset, 0),
                                    child: Opacity(
                                      opacity: (1 - offset.abs() / 50).clamp(
                                        0,
                                        1,
                                      ),
                                      child: child,
                                    ),
                                  );
                                },
                                child: Visibility(
                                  visible: currPage <= pageList.length - 1.5,
                                  child: TextButton(
                                    onPressed: () {
                                      pageController.animateToPage(
                                        pageList.length - 1,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeIn,
                                      );
                                    },
                                    child: AppText(
                                      text: LocaleKeys.skip.tr(),
                                      color: Colors.white,
                                      size: 22.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  /// 🔥 Dots
                  PositionedDirectional(
                    bottom: 180.h,
                    end: 20.w,
                    start: 20.w,
                    child: DotsIndicator(
                      dotsCount: pageList.length,
                      position: currPage,
                      decorator: DotsDecorator(
                        activeColor: Colors.white,
                        color: Colors.white.withOpacity(0.3),
                        size: Size.square(10.r),
                        activeSize: Size(22.w, 10.h),
                        activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
