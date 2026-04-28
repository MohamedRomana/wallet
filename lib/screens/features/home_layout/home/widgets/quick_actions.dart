// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet/core/cache/cache_helper.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../gen/fonts.gen.dart';
import 'dart:math' as math;

class QuickActions extends StatefulWidget {
  const QuickActions({super.key});

  @override
  State<QuickActions> createState() => _QuickActionsState();
}

class _QuickActionsState extends State<QuickActions>
    with TickerProviderStateMixin {
  late final AnimationController _cardController;
  late final AnimationController _borderRunnerController;
  late final AnimationController _textController;
  late final AnimationController _bgController;

  @override
  void initState() {
    super.initState();

    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();

    _borderRunnerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cardController.dispose();
    _borderRunnerController.dispose();
    _textController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_borderRunnerController, _bgController]),
      builder: (context, child) {
        final t = _bgController.value;

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.92, end: 1.0),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(scale: scale, child: child);
          },
          child: _RunningBorderCard(
            progress: _borderRunnerController.value,
            borderRadius: 20.r,
            borderColor: Colors.black,
            child: Container(
              width: 361.w,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 25.h),
              decoration: BoxDecoration(
                color: Color.lerp(
                  Colors.white,
                  CacheHelper.getDarkMode() ? Color(0xff1E2939) : Colors.black,
                  t,
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20.r,
                    spreadRadius: 2.r,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AnimatedTextItem(
                    controller: _textController,
                    delay: 0.0,
                    offsetY: 18,
                    child: AppText(
                      text: 'Quick Actions',
                      size: 18.sp,
                      color: Color.lerp(Colors.black, Colors.white, t),
                      fontWeight: FontWeight.w700,
                      family: FontFamily.bahijJannaBold,
                      bottom: 20.h,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _ActionCard(
                          borderColor: Colors.green,
                          delay: 0.05,
                          textController: _textController,
                          borderProgress: _borderRunnerController.value,
                          bgProgress: _bgController.value,
                          width: 90.w,
                          height: 130.h,
                          baseColor: Colors.green,
                          lightColor: Colors.green.withAlpha(50),
                          icon: Icons.arrow_upward,
                          iconAngle: 2.5,
                          line1: 'Add',
                          line2: 'Income',
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _ActionCard(
                          delay: 0.12,
                          textController: _textController,
                          borderProgress: _borderRunnerController.value,
                          bgProgress: _bgController.value,
                          width: 90.w,
                          height: 130.h,
                          baseColor: Colors.red,
                          lightColor: Colors.red.withAlpha(50),
                          icon: Icons.arrow_upward,
                          iconAngle: 0.8,
                          line1: 'Add',
                          line2: 'Expense',
                          borderColor: Colors.red,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _ActionCard(
                          delay: 0.19,
                          textController: _textController,
                          borderProgress: _borderRunnerController.value,
                          bgProgress: _bgController.value,
                          width: 90.w,
                          height: 130.h,
                          baseColor: Colors.blue,
                          lightColor: Colors.blue.withAlpha(50),
                          icon: Icons.arrow_upward,
                          iconAngle: 0.8,
                          line1: 'Transfer',
                          line2: '',
                          borderColor: Colors.blue,
                        ),
                      ),
                    ],
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

class _ActionCard extends StatefulWidget {
  final double width;
  final double height;
  final Color baseColor;
  final Color lightColor;
  final IconData icon;
  final double iconAngle;
  final String line1;
  final String line2;
  final double delay;
  final AnimationController textController;
  final double borderProgress;
  final double bgProgress;
  final Color borderColor;

  const _ActionCard({
    required this.width,
    required this.height,
    required this.baseColor,
    required this.lightColor,
    required this.icon,
    required this.iconAngle,
    required this.line1,
    required this.line2,
    required this.delay,
    required this.textController,
    required this.borderProgress,
    required this.bgProgress,
    required this.borderColor,
  });

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard>
    with TickerProviderStateMixin {
  late final AnimationController _pressController;
  late final AnimationController _iconController;
  late final AnimationController _iconBgController;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      lowerBound: 0.94,
      upperBound: 1.0,
      value: 1.0,
    );

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _iconBgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pressController.dispose();
    _iconController.dispose();
    _iconBgController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _pressController.reverse();
  }

  void _onTapUp(TapUpDetails details) {
    _pressController.forward();
  }

  void _onTapCancel() {
    _pressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.88, end: 1.0),
      duration: Duration(milliseconds: (850 + (widget.delay * 1000)).toInt()),
      curve: Curves.easeOutBack,
      builder: (context, entryScale, child) {
        return Transform.scale(scale: entryScale, child: child);
      },
      child: GestureDetector(
        onTap: () {},
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _pressController,
            _iconController,
            _iconBgController,
          ]),
          builder: (context, child) {
            final localT = _iconBgController.value;
            final floatY = math.sin(_iconController.value * math.pi * 2) * 4;

            return Transform.scale(
              scale: _pressController.value,
              child: _RunningBorderCard(
                progress: (widget.borderProgress + widget.delay) % 1,
                borderRadius: 20.r,
                borderColor: widget.borderColor,
                child: Container(
                  width: widget.width,
                  height: widget.height,
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: Color.lerp(
                      widget.lightColor,
                      widget.baseColor.withAlpha(35),
                      localT,
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: widget.baseColor.withAlpha(35),
                        blurRadius: 14,
                        spreadRadius: 1,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Transform.translate(
                        offset: Offset(0, floatY),
                        child: Container(
                          width: 50.w,
                          height: 50.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Color.lerp(
                                  widget.baseColor,
                                  Colors.white,
                                  localT * 0.2,
                                )!,
                                widget.baseColor,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: widget.baseColor.withAlpha(60),
                                blurRadius: 14,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Transform.rotate(
                            angle:
                                widget.iconAngle +
                                (math.sin(_iconController.value * math.pi * 2) *
                                    0.08),
                            child: Icon(
                              widget.icon,
                              color: Colors.white,
                              size: 25.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      _AnimatedTextItem(
                        controller: widget.textController,
                        delay: widget.delay + 0.10,
                        offsetY: 16,
                        child: AppText(
                          text: widget.line1,
                          size: 14.sp,
                          color: widget.baseColor,
                          fontWeight: FontWeight.w700,
                          family: FontFamily.bahijJannaBold,
                        ),
                      ),
                      if (widget.line2.isNotEmpty)
                        _AnimatedTextItem(
                          controller: widget.textController,
                          delay: widget.delay + 0.18,
                          offsetY: 20,
                          child: AppText(
                            text: widget.line2,
                            size: 14.sp,
                            color: widget.baseColor,
                            fontWeight: FontWeight.w700,
                            family: FontFamily.bahijJannaBold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AnimatedTextItem extends StatelessWidget {
  final AnimationController controller;
  final double delay;
  final double offsetY;
  final Widget child;

  const _AnimatedTextItem({
    required this.controller,
    required this.delay,
    required this.offsetY,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final start = delay.clamp(0.0, 0.8);
    final end = (start + 0.35).clamp(0.0, 1.0);

    final fade = CurvedAnimation(
      parent: controller,
      curve: Interval(start, end, curve: Curves.easeOut),
    );

    final slide =
        Tween<Offset>(begin: Offset(0, offsetY / 40), end: Offset.zero).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(start, end, curve: Curves.easeOutCubic),
          ),
        );

    return SlideTransition(
      position: slide,
      child: FadeTransition(opacity: fade, child: child),
    );
  }
}

class _RunningBorderCard extends StatelessWidget {
  final Widget child;
  final double progress;
  final double borderRadius;
  final Color borderColor;

  const _RunningBorderCard({
    required this.child,
    required this.progress,
    required this.borderRadius,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RunningBorderPainter(
        progress: progress,
        borderRadius: borderRadius,
        borderColor: borderColor,
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
  final Color borderColor;

  _RunningBorderPainter({
    required this.progress,
    required this.borderRadius,
    required this.borderColor,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(1.1),
      Radius.circular(borderRadius),
    );

    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..color = Colors.black.withAlpha(18);

    canvas.drawRRect(rrect, basePaint);

    final path = Path()..addRRect(rrect);
    final metric = path.computeMetrics().first;
    final length = metric.length;
    const segmentLength = 55.0;
    final start = progress * length;
    final end = start + segmentLength;

    Path extract;
    if (end <= length) {
      extract = metric.extractPath(start, end);
    } else {
      final first = metric.extractPath(start, length);
      final second = metric.extractPath(0, end - length);
      extract = Path()
        ..addPath(first, Offset.zero)
        ..addPath(second, Offset.zero);
    }

    final runnerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          borderColor,
          Colors.white,
          borderColor,
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
