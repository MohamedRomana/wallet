// ignore_for_file: deprecated_member_use, unused_field

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../gen/fonts.gen.dart';

class MoneyInWallet extends StatefulWidget {
  const MoneyInWallet({super.key});

  @override
  State<MoneyInWallet> createState() => _MoneyInWalletState();
}

class _MoneyInWalletState extends State<MoneyInWallet>
    with TickerProviderStateMixin {
  bool isVisible = true;

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

  void _toggleVisibility() async {
    await _eyeTapController.reverse();
    if (mounted) {
      setState(() {
        isVisible = !isVisible;
      });
    }
    await _eyeTapController.forward();
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

        return Container(
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
                Color.lerp(AppColors.primary, const Color(0xFF8B5CF6), t)!,
                Color.lerp(AppColors.secondray, const Color(0xFF3B1FA8), t)!,
                Color.lerp(const Color(0xFF4C35E0), AppColors.primary, t)!,
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
              Row(
                children: [
                  Expanded(
                    child: _AnimatedTextsBlock(
                      controller: _textController,
                      children: [
                        AppText(
                          text: 'Dashboard',
                          size: 18.sp,
                          family: FontFamily.bahijJannaRegular,
                          color: Colors.white,
                        ),
                        AppText(
                          text: 'PocketMind',
                          size: 30.sp,
                          family: FontFamily.bahijJannaBold,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  _AnimatedGlassIcon(
                    size: 40.w,
                    backgroundColor: Colors.white.withAlpha(50),
                    child: RotationTransition(
                      turns: _gearController,
                      child: Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 20.w,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),

              Transform.scale(
                scale: _cardPulseAnimation.value,
                child: _RunningBorderCard(
                  progress: _borderRunnerController.value,
                  borderRadius: 20.r,
                  child: Container(
                    width: 361.w,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 25.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(40),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withAlpha(25),
                          blurRadius: 18,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _AnimatedTextsBlock(
                                controller: _textController,
                                children: [
                                  AppText(
                                    text: 'Total Balance',
                                    size: 14.sp,
                                    family: FontFamily.bahijJannaRegular,
                                    color: Colors.white,
                                  ),
                                  Row(
                                    children: [
                                      AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 350,
                                        ),
                                        transitionBuilder: (child, animation) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: SlideTransition(
                                              position: Tween<Offset>(
                                                begin: const Offset(0, 0.25),
                                                end: Offset.zero,
                                              ).animate(animation),
                                              child: child,
                                            ),
                                          );
                                        },
                                        child: AppText(
                                          key: ValueKey(isVisible),
                                          text: isVisible
                                              ? '\$12,345.67'
                                              : '••••••',
                                          size: 24.sp,
                                          family: FontFamily.bahijJannaBold,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          end: 20.w,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: _toggleVisibility,
                                        child: ScaleTransition(
                                          scale: _eyeTapController,
                                          child: AnimatedSwitcher(
                                            duration: const Duration(
                                              milliseconds: 250,
                                            ),
                                            transitionBuilder:
                                                (child, animation) {
                                                  return RotationTransition(
                                                    turns: Tween<double>(
                                                      begin: 0.8,
                                                      end: 1.0,
                                                    ).animate(animation),
                                                    child: FadeTransition(
                                                      opacity: animation,
                                                      child: child,
                                                    ),
                                                  );
                                                },
                                            child: Icon(
                                              isVisible
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                        .visibility_off_outlined,
                                              key: ValueKey(isVisible),
                                              color: isVisible
                                                  ? Colors.white
                                                  : Colors.white.withAlpha(120),
                                              size: 20.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(0, _iconFloatAnimation.value),
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.92, end: 1),
                                duration: const Duration(milliseconds: 900),
                                curve: Curves.easeOutBack,
                                builder: (context, value, child) {
                                  return Transform.scale(
                                    scale: value,
                                    child: child,
                                  );
                                },
                                child: SvgPicture.asset(
                                  'assets/svg/walet.svg',
                                  width: 30.w,
                                  height: 30.w,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 60.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _SmallAnimatedInfoCard(
                                progress: _borderRunnerController.value,
                                title: 'Income',
                                amount: '\$8,000.00',
                                icon: 'assets/svg/arrows.svg',
                                iconColor: Colors.lightGreenAccent,
                                floatOffset: _iconFloatAnimation.value,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: _SmallAnimatedInfoCard(
                                progress: _borderRunnerController.value,
                                title: 'Expense',
                                amount: '\$8,000.00',
                                icon: 'assets/svg/arrows.svg',
                                iconColor: Colors.redAccent,
                                rotateIcon: true,
                                floatOffset: -_iconFloatAnimation.value,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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

class _AnimatedTextsBlock extends StatelessWidget {
  final AnimationController controller;
  final List<Widget> children;

  const _AnimatedTextsBlock({required this.controller, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(children.length, (index) {
        final start = 0.08 * index;
        final end = (start + 0.45).clamp(0.0, 1.0);

        final fade = CurvedAnimation(
          parent: controller,
          curve: Interval(start, end, curve: Curves.easeOut),
        );

        final slide =
            Tween<Offset>(
              begin: Offset(0, 0.45 + (index * 0.08)),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: controller,
                curve: Interval(start, end, curve: Curves.easeOutCubic),
              ),
            );

        return SlideTransition(
          position: slide,
          child: FadeTransition(
            opacity: fade,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: index == children.length - 1 ? 0 : 6.h,
              ),
              child: children[index],
            ),
          ),
        );
      }),
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

class _SmallAnimatedInfoCard extends StatelessWidget {
  final double progress;
  final String title;
  final String amount;
  final String icon;
  final Color iconColor;
  final bool rotateIcon;
  final double floatOffset;

  const _SmallAnimatedInfoCard({
    required this.progress,
    required this.title,
    required this.amount,
    required this.icon,
    required this.iconColor,
    this.rotateIcon = false,
    required this.floatOffset,
  });

  @override
  Widget build(BuildContext context) {
    return _RunningBorderCard(
      progress: progress,
      borderRadius: 20.r,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(45),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withAlpha(18),
              blurRadius: 16,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: Offset(0, floatOffset),
                  child: Transform.rotate(
                    angle: rotateIcon ? math.pi : 0,
                    child: SvgPicture.asset(
                      icon,
                      width: 20.w,
                      height: 20.w,
                      color: iconColor,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Flexible(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(12 * (1 - value), 0),
                          child: child,
                        ),
                      );
                    },
                    child: AppText(
                      text: title,
                      size: 14.sp,
                      family: FontFamily.bahijJannaBold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeOutQuart,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 16 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: AppText(
                text: amount,
                size: 16.sp,
                family: FontFamily.bahijJannaBold,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
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
