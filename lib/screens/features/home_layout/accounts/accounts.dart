// ignore_for_file: deprecated_member_use, unused_field

import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'; // مكتبة الأنيميشن
import 'package:wallet/core/widgets/app_text.dart';
import '../../../../core/constants/colors.dart';
import '../../../../gen/fonts.gen.dart';

class Accounts extends StatefulWidget {
  const Accounts({super.key});

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> with TickerProviderStateMixin {
  late final AnimationController _gradientController;
  late final AnimationController _gearController;
  late final AnimationController _iconFloatController;
  late final AnimationController _textController;
  late final AnimationController _cardPulseController;
  late final AnimationController _borderRunnerController;
  late final AnimationController _eyeTapController;

  late final Animation<double> _gearRotation;
  late final Animation<double> _iconFloatAnimation;
  late final Animation<double> _cardPulseAnimation;
  late final Animation<double> _eyeScaleAnimation;

  @override
  void initState() {
    super.initState();

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _gearController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _iconFloatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();

    _cardPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _borderRunnerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _eyeTapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      lowerBound: 0.88,
      upperBound: 1.0,
      value: 1.0,
    );

    _gearRotation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _gearController, curve: Curves.linear));

    _iconFloatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _iconFloatController, curve: Curves.easeInOut),
    );

    _cardPulseAnimation = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(parent: _cardPulseController, curve: Curves.easeInOut),
    );

    _eyeScaleAnimation = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _eyeTapController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _gearController.dispose();
    _iconFloatController.dispose();
    _textController.dispose();
    _cardPulseController.dispose();
    _borderRunnerController.dispose();
    _eyeTapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _gradientController,
        _iconFloatController,
        _cardPulseController,
        _borderRunnerController,
      ]),
      builder: (context, child) {
        final t = _gradientController.value;

        return Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    // الأنيميشن على التدرج اللوني
                    Container(
                      width: double.infinity,
                      padding: EdgeInsetsDirectional.only(
                        start: 16.w,
                        end: 16.w,
                        top: 60.h,
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
                          // النص مع الأنيميشن
                          AppText(
                            text: 'Accounts',
                            size: 24.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),

                          SizedBox(height: 30.h),
                          // الكونتينر مع الأنيميشن
                          Transform.scale(
                            scale: _cardPulseAnimation.value,
                            child: _RunningBorderCard(
                              progress: _borderRunnerController.value,
                              borderRadius: 20.r,
                              child: Container(
                                width: 361.w,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 20.h,
                                ),

                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(80),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Transform.translate(
                                      offset: Offset(
                                        0,
                                        _iconFloatAnimation.value,
                                      ),
                                      child: TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0.92, end: 1),
                                        duration: const Duration(
                                          milliseconds: 900,
                                        ),
                                        curve: Curves.easeOutBack,
                                        builder: (context, value, child) {
                                          return Transform.scale(
                                            scale: value,
                                            child: child,
                                          );
                                        },
                                        child: AppText(
                                          text: 'Total Net Worth',
                                          size: 18.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          family: FontFamily.bahijJannaBold,
                                          bottom: 35.h,
                                        ),
                                      ),
                                    ),
                                    // الرقم مع الأنيميشن العددي
                                    Transform.translate(
                                      offset: Offset(
                                        0,
                                        _iconFloatAnimation.value,
                                      ),
                                      child: TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0.92, end: 1),
                                        duration: const Duration(
                                          milliseconds: 900,
                                        ),
                                        curve: Curves.easeOutBack,
                                        builder: (context, value, child) {
                                          return Transform.scale(
                                            scale: value,
                                            child: child,
                                          );
                                        },
                                        child: AppText(
                                          text: '\$12,345.67',
                                          size: 28.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          family: FontFamily.bahijJannaBold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // قائمة مع أنيميشن التنقل
                ListView.separated(
                  itemCount: 10,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsetsDirectional.only(
                    top: 300.h,
                    bottom: 150.h,
                    start: 16.w,
                    end: 16.w,
                  ),
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) =>
                      AnimationConfiguration.staggeredList(
                        position: index,
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Container(
                              width: 361.w,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(20),
                                    blurRadius: 10.r,
                                    offset: Offset(0, 5.h),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // أيقونة مع انيميشن "التنطيط"
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 600),
                                    curve: Curves.elasticInOut,
                                    height: 50.w,
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Transform.translate(
                                      offset: Offset(
                                        0,
                                        _iconFloatAnimation.value,
                                      ),
                                      child: TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0.92, end: 1),
                                        duration: const Duration(
                                          milliseconds: 900,
                                        ),
                                        curve: Curves.easeOutBack,
                                        builder: (context, value, child) {
                                          return Transform.scale(
                                            scale: value,
                                            child: child,
                                          );
                                        },
                                        child: Icon(
                                          Icons.account_balance_wallet_outlined,
                                          color: Colors.white,
                                          size: 24.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        text: 'Main Checking',
                                        size: 16.sp,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      SizedBox(height: 4.h),
                                      AppText(
                                        text: 'Bank Account',
                                        size: 14.sp,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  // الرقم مع الأنيميشن العددي
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 500),
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    child: Text('\$5,678.90'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class _AnimatedGlassIcon extends StatefulWidget {
  final Widget child;
  final double size;
  final Color backgroundColor;

  const _AnimatedGlassIcon({
    required this.child,
    required this.size,
    required this.backgroundColor,
  });

  @override
  State<_AnimatedGlassIcon> createState() => _AnimatedGlassIconState();
}

class _AnimatedGlassIconState extends State<_AnimatedGlassIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = 0.96 + (_controller.value * 0.04);
        return Transform.scale(
          scale: value,
          child: Container(
            height: widget.size,
            width: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withAlpha(25),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(child: widget.child),
          ),
        );
      },
    );
  }
}


class _RunningBorderCard extends StatelessWidget {
  final Widget child;
  final double progress;
  final double borderRadius;

  const _RunningBorderCard({
    required this.child,
    required this.progress,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RunningBorderPainter(
        progress: progress,
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
      ),
    );
  }
}

class _RunningBorderPainter extends CustomPainter {
  final double progress;
  final double borderRadius;

  _RunningBorderPainter({required this.progress, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(1.2),
      Radius.circular(borderRadius),
    );

    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = Colors.white.withAlpha(50);

    canvas.drawRRect(rrect, basePaint);

    final path = Path()..addRRect(rrect);
    final metric = path.computeMetrics().first;
    final pathLength = metric.length;
    const segmentLength = 70.0;
    final start = progress * pathLength;
    final end = start + segmentLength;

    Path extract;
    if (end <= pathLength) {
      extract = metric.extractPath(start, end);
    } else {
      final first = metric.extractPath(start, pathLength);
      final second = metric.extractPath(0, end - pathLength);
      extract = Path()
        ..addPath(first, Offset.zero)
        ..addPath(second, Offset.zero);
    }

    final runnerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [
          Colors.transparent,
          Colors.white,
          Color(0xFFF4EEFF),
          Colors.transparent,
        ],
      ).createShader(rect);

    canvas.drawPath(extract, runnerPaint);
  }

  @override
  bool shouldRepaint(covariant _RunningBorderPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.borderRadius != borderRadius;
  }
}
