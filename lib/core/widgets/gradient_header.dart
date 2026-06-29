import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';

/// A reusable rounded header with a slowly animated brand gradient. One
/// controller per visible header keeps it cheap while still feeling alive.
class GradientHeader extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;

  const GradientHeader({
    super.key,
    required this.child,
    this.padding,
    this.radius = 28,
  });

  @override
  State<GradientHeader> createState() => _GradientHeaderState();
}

class _GradientHeaderState extends State<GradientHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = _c.value;
        return Container(
          width: double.infinity,
          padding:
              widget.padding ??
              EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.lerp(AppColors.brandGradient[0],
                    AppColors.brandGradient[2], t)!,
                Color.lerp(AppColors.brandGradient[1],
                    AppColors.brandGradient[0], t)!,
                Color.lerp(AppColors.brandGradient[2],
                    AppColors.brandGradient[1], t)!,
              ],
              begin: Alignment(lerpDouble(-1, 1, t)!, -1),
              end: Alignment(lerpDouble(1, -1, t)!, 1),
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(widget.radius.r),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.30),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        );
      },
      child: SafeArea(bottom: false, child: widget.child),
    );
  }
}
