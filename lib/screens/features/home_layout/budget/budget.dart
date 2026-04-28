import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../gen/fonts.gen.dart';

class Budget extends StatefulWidget {
  const Budget({super.key});

  @override
  State<Budget> createState() => _BudgetState();
}

class _BudgetState extends State<Budget> with TickerProviderStateMixin {
  bool isVisible = true;

  late final AnimationController _gradientController;
  late final AnimationController _gearController;
  late final AnimationController _iconFloatController;
  late final AnimationController _textController;
  late final AnimationController _cardPulseController;
  late final AnimationController _borderRunnerController;
  late final AnimationController _eyeTapController;

  late final Animation<double> _iconFloatAnimation;
  late final Animation<double> _cardPulseAnimation;

  List goals = [
    {
      "title": "Food",
      "target": "\$1,200.00",
      "remaining": "3 months left",
      "progress": '25%',
      'icon': 'assets/svg/burger.svg',
      'prog_double': 25,
    },
    {
      "title": "Rent",
      "target": "\$4,000.00",
      "remaining": "3 months left",
      "progress": '50%',
      'icon': 'assets/svg/house.svg',
      'prog_double': 50,
    },
    {
      "title": "Entertainment",
      "target": "\$800.00",
      "remaining": "3 months left",
      "progress": '10%',
      'icon': 'assets/svg/game.svg',
      'prog_double': 10,
    },
  ];

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

    _iconFloatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _iconFloatController, curve: Curves.easeInOut),
    );

    _cardPulseAnimation = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(parent: _cardPulseController, curve: Curves.easeInOut),
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
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,

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
                          text: "Categories & Budget",
                          color: Colors.white,
                          bottom: 20.h,
                          size: 25.sp,
                          top: 15.h,
                          fontWeight: FontWeight.w700,
                          family: FontFamily.bahijJannaBold,
                        ),
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
                                  Column(
                                    children: [
                                      _SmallAnimatedInfoCard(
                                        progress: _borderRunnerController.value,
                                        title: 'Total Budget',
                                        amount: '\$8,000.00',
                                        iconColor: Colors.lightGreenAccent,
                                        floatOffset: _iconFloatAnimation.value,
                                      ),
                                      SizedBox(height: 20.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: _SmallAnimatedInfoCard(
                                              progress:
                                                  _borderRunnerController.value,
                                              title: 'Total Spent',
                                              amount: '\$8,000.00',
                                              iconColor: Colors.redAccent,
                                              rotateIcon: true,
                                              floatOffset:
                                                  -_iconFloatAnimation.value,
                                            ),
                                          ),
                                          SizedBox(width: 16.w),

                                          Expanded(
                                            child: _SmallAnimatedInfoCard(
                                              progress:
                                                  _borderRunnerController.value,
                                              title: 'Remaining',
                                              amount: '\$8,000.00',
                                              iconColor: Colors.redAccent,
                                              rotateIcon: true,
                                              floatOffset:
                                                  -_iconFloatAnimation.value,
                                            ),
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
                      ],
                    ),
                  ),
                ],
              ),
              AnimationLimiter(
                child: ListView.separated(
                  itemCount: goals.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsetsDirectional.only(
                    top: 350.h,
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
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      // أيقونة مع انيميشن "التنطيط"
                                      SvgPicture.asset(
                                        goals[index]['icon'],
                                        width: 28.w,
                                        height: 28.w,
                                      ),
                                      SizedBox(width: 16.w),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            text: goals[index]['title'],
                                            size: 16.sp,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          SizedBox(height: 4.h),
                                          AppText(
                                            text:
                                                'Budget: ${goals[index]["target"]}',
                                            size: 14.sp,
                                            color: Colors.black54,
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      // الرقم مع الأنيميشن العددي
                                      AnimatedDefaultTextStyle(
                                        duration: const Duration(
                                          milliseconds: 500,
                                        ),
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                            vertical: 6.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.greenAccent.withAlpha(
                                              50,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                          ),

                                          child: Text(
                                            '${goals[index]["progress"]}',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  Center(
                                    child: LinearPercentIndicator(
                                      width: 310.w,
                                      lineHeight: 10.h,
                                      percent:
                                          goals[index]['prog_double'] / 100,
                                      barRadius: Radius.circular(7.r),
                                      backgroundColor: Colors.grey,
                                      progressColor: Colors.black,
                                      animation: true,
                                      animateFromLastPercent: true,
                                      animateToInitialPercent: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
  final Color iconColor;
  final bool rotateIcon;
  final double floatOffset;

  const _SmallAnimatedInfoCard({
    required this.progress,
    required this.title,
    required this.amount,
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
