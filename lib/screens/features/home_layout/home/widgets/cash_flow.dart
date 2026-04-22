// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../gen/fonts.gen.dart';

class ReportData {
  final int month; // 1 = Jan .. 12 = Dec
  final double percentage; // 0 - 100

  ReportData({required this.month, required this.percentage});
}

class CashFlow extends StatefulWidget {
  const CashFlow({super.key});

  @override
  State<CashFlow> createState() => _CashFlowState();
}

class _CashFlowState extends State<CashFlow> with TickerProviderStateMixin {
  late final AnimationController _bgController;
  late final AnimationController _textController;
  late final AnimationController _lineController;
  late final AnimationController _borderController;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();

    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _borderController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true); // إضافة الحركة للبوردر
  }

  @override
  void dispose() {
    _bgController.dispose();
    _textController.dispose();
    _lineController.dispose();
    _borderController.dispose();
    super.dispose();
  }

  List<ReportData> get data => [
    ReportData(month: 1, percentage: 40),
    ReportData(month: 2, percentage: 55),
    ReportData(month: 3, percentage: 60),
    ReportData(month: 4, percentage: 70),
    ReportData(month: 5, percentage: 80),
    ReportData(month: 6, percentage: 65),
  ];

  List<FlSpot> get spots =>
      data.map((e) => FlSpot((e.month - 1).toDouble(), e.percentage)).toList();

  double get minY => 0;
  double get maxY => 100;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 16.w,
        end: 16.w,
        top: 200.h,
        bottom: 30.h,
      ),
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _bgController,
          _textController,
          _lineController,
          _borderController,
        ]),
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
              // تطبيق الأنيميشن على البوردر
              progress: _borderController.value,
              borderRadius: 20.r,
              borderColor: Colors.blue,
              child: Container(
                width: double.infinity,
                padding: EdgeInsetsDirectional.only(
                  start: 16.w,
                  end: 16.w,
                  top: 20.h,
                  bottom: 20.h,
                ),

                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(Colors.white, Colors.blue, t)!,
                      Color.lerp(
                        Colors.white.withAlpha(70),
                        const Color(0xFFF7F5FF),
                        t,
                      )!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  children: [
                    _AnimatedTextItem(
                      controller: _textController,
                      delay: 0.0,
                      offsetY: 18,
                      child: AppText(
                        text: 'Cash Flow (12 Months)',
                        size: 18.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        family: FontFamily.bahijJannaBold,
                        bottom: 20.h,
                      ),
                    ),
                    SizedBox(
                      height: 300.h,
                      width: 361.w,
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: 11, // 12 شهر
                          minY: 0,
                          maxY: 100,

                          gridData: const FlGridData(show: true),
                          borderData: FlBorderData(show: false),

                          // Tooltips
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (spots) {
                                return spots.map((s) {
                                  const months = [
                                    'January',
                                    'February',
                                    'March',
                                    'April',
                                    'May',
                                    'June',
                                    'July',
                                    'August',
                                    'September',
                                    'October',
                                    'November',
                                    'December',
                                  ];

                                  final month = months[s.x.toInt()];
                                  return LineTooltipItem(
                                    '$month\n${s.y.toInt()}%',
                                    const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),

                          // Axis titles
                          titlesData: FlTitlesData(
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 20,
                                reservedSize: 42,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${value.toInt()}%',
                                    style: const TextStyle(fontSize: 11),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  const months = [
                                    'Jan',
                                    'Feb',
                                    'Mar',
                                    'Apr',
                                    'May',
                                    'Jun',
                                    'Jul',
                                    'Aug',
                                    'Sep',
                                    'Oct',
                                    'Nov',
                                    'Dec',
                                  ];

                                  final index = value.toInt();
                                  if (index < 0 || index > 11)
                                    return SizedBox.shrink();

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      months[index],
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          // The line
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              barWidth: 3,
                              dotData: FlDotData(
                                show: data.length <= 14,
                              ), // لو أيام قليلة: نقط
                              belowBarData: BarAreaData(show: true),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// _RunningBorderCard class definition remains unchanged

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
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: [
          Colors.blue.withOpacity(0.8),
          borderColor,
          Colors.white,
          borderColor,
          Colors.blue.withOpacity(0.8),
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
