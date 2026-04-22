import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';

class AppButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget? iconComponent;
  final Widget? textComponent;
  final Color? color;
  final double? height;
  final double? top;
  final double? bottom;
  final double? start;
  final double? end;
  final double? radius;
  final double? width;
  final List<Color>? colors;
  final Widget child;
  final Color? borderColor;
  final WidgetStateProperty<Size?>? minimumSize;
  final WidgetStateProperty<double?>? elevation;
  final WidgetStateProperty<Color?>? shadowColor;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
    this.height,
    this.radius,
    this.width,
    this.top,
    this.bottom,
    this.start,
    this.end,
    this.iconComponent,
    this.textComponent,
    this.colors,
    this.borderColor,
    this.minimumSize, this.elevation, this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: top ?? 0,
        start: start ?? 0,
        bottom: bottom ?? 0,
        end: end ?? 0,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shadowColor: shadowColor,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          elevation: elevation ?? WidgetStateProperty.all(0),
          padding: const WidgetStatePropertyAll(EdgeInsets.all(0)),
          maximumSize: WidgetStateProperty.all(
            Size(width ?? 327.w, height ?? 48.h),
          ),
          minimumSize: minimumSize,
          backgroundColor: WidgetStateColor.transparent,
        ),
        child: Ink(
          decoration: BoxDecoration(
            color: color ?? AppColors.primary,
            // gradient: LinearGradient(
            //   colors: colors ??
            //       [
            //         const Color(0xff0F2B50),
            //         const Color(0xff0C69E5),
            //       ],
            // ),
            borderRadius: BorderRadius.circular(radius ?? 15.r),
            border:
                Border.all(color: borderColor ?? color ?? AppColors.primary),
          ),
          child: Container(
            constraints: BoxConstraints(
              minWidth: width ?? 327.w,
              minHeight: height ?? 48.h,
            ),
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }
}
