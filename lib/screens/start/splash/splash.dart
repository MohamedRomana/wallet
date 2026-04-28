// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet/core/cache/cache_helper.dart';
import 'package:wallet/core/widgets/app_text.dart';
import 'package:wallet/gen/fonts.gen.dart';
import '../../../../gen/assets.gen.dart';
import '../../../core/widgets/app_router.dart';
import '../on_boarding/on_boarding.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _gradientController;

  late final Animation<double> _logoBounceAnimation;
  late final Animation<double> _titleFadeAnimation;
  late final Animation<Offset> _titleSlideAnimation;
  late final Animation<double> _subtitleFadeAnimation;
  late final Animation<Offset> _subtitleSlideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
    _customNavigation();
    CacheHelper.getDarkMode();
  }

  void _initAnimations() {
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _logoBounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: -18.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -18.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 65,
      ),
    ]).animate(_logoController);

    _titleFadeAnimation = CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.15, 0.55, curve: Curves.easeIn),
    );

    _titleSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.7), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _textController,
            curve: const Interval(0.15, 0.55, curve: Curves.easeOutCubic),
          ),
        );

    _subtitleFadeAnimation = CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.45, 0.9, curve: Curves.easeIn),
    );

    _subtitleSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.8), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _textController,
            curve: const Interval(0.45, 0.9, curve: Curves.easeOutCubic),
          ),
        );
  }

  void _startAnimations() async {
    _logoController.repeat(reverse: true);
    await Future.delayed(const Duration(milliseconds: 300));
    _textController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          final t = _gradientController.value;

          return Container(
            height: double.infinity,
            width: double.infinity,
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
            child: SafeArea(
              top: false,
              bottom: false,
              child: Stack(
                children: [
                  Positioned(
                    top: -60.h,
                    right: -40.w,
                    child: Container(
                      height: 220.h,
                      width: 220.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -80.h,
                    left: -50.w,
                    child: Container(
                      height: 260.h,
                      width: 260.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: AnimatedBuilder(
                          animation: _logoBounceAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _logoBounceAnimation.value),
                              child: child,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28.r),
                              color: Colors.white.withValues(alpha: 0.10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 25,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: Image.asset(
                                Assets.img.logo.path,
                                height: 150.w,
                                width: 150.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      SlideTransition(
                        position: _titleSlideAnimation,
                        child: FadeTransition(
                          opacity: _titleFadeAnimation,
                          child: AppText(
                            text: 'PocketMind',
                            size: 30.sp,
                            color: Colors.white,
                            family: FontFamily.bahijJannaBold,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      SlideTransition(
                        position: _subtitleSlideAnimation,
                        child: FadeTransition(
                          opacity: _subtitleFadeAnimation,
                          child: AppText(
                            text: 'Your Personal Finance Manager',
                            size: 16.sp,
                            color: Colors.white.withValues(alpha: 0.92),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _customNavigation() async {
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    // CacheHelper.getLang() != ""
    //     ? CacheHelper.getUserId() != ""
    //           ? CacheHelper.getUserType() == "client" ||
    //                     CacheHelper.getUserType() == "admin"
    //                 ? AppRouter.navigateAndFinish(context, const HomeLayout())
    //                 : AppRouter.navigateAndFinish(
    //                     context,
    //                     const ProvHomeLayout(),
    //                   )
    //           : {
    //               CacheHelper.setUserType('client'),
    //               AppRouter.navigateAndFinish(context, const HomeLayout()),
    //             }
    //     : AppRouter.navigateAndFinish(context, const OnBoarding());
    AppRouter.navigateAndFinish(context, const OnBoarding());
  }
}
