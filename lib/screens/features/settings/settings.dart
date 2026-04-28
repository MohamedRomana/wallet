import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallet/core/cache/cache_helper.dart';
import 'package:wallet/core/widgets/app_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/app_text.dart';
import '../../../gen/fonts.gen.dart';
import '../drawer_items/about_us/ui/about_us.dart';
import '../drawer_items/contact_us/ui/contact_us.dart';
import '../drawer_items/privacy_policy/ui/privacy_policy.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with TickerProviderStateMixin {
  bool isVisible = true;

  late final AnimationController _gradientController;
  late final AnimationController _gearController;
  late final AnimationController _iconFloatController;
  late final AnimationController _textController;
  late final AnimationController _cardPulseController;
  late final AnimationController _borderRunnerController;
  late final AnimationController _eyeTapController;

  @override
  void initState() {
    super.initState();

    setState(() {
      CacheHelper.getDarkMode();
    });
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
                      bottom: 20.h,
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
                        Row(
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withAlpha(80),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: 20.w,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: AppText(
                                start: 80.w,
                                text: "Settings",
                                color: Colors.white,
                                bottom: 20.h,
                                size: 25.sp,
                                top: 15.h,
                                fontWeight: FontWeight.w700,
                                family: FontFamily.bahijJannaBold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: 'General',
                        size: 18.sp,
                        color: CacheHelper.getDarkMode()
                            ? Colors.white
                            : Colors.black54,
                        fontWeight: FontWeight.w700,
                        family: FontFamily.bahijJannaBold,
                        top: 20.h,
                        start: 16.w,
                      ),
                      Container(
                        width: 343.w,
                        padding: EdgeInsets.all(16.w),
                        margin: EdgeInsetsDirectional.only(
                          start: 16.w,
                          end: 16.w,
                          top: 16.h,
                          bottom: 20.h,
                        ),
                        decoration: BoxDecoration(
                          color: CacheHelper.getDarkMode()
                              ? Color(0xff1E2939)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(20),
                              blurRadius: 5.r,
                              spreadRadius: 1.r,
                              offset: Offset(0, 5.h),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                AppRouter.navigateTo(context, ContactUs());
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: 50.w,
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                      color: Colors.purple.withAlpha(30),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.contact_mail_outlined,
                                        color: Colors.purple,
                                        size: 30.w,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        text: 'Contact Us',
                                        size: 16.sp,
                                        color: CacheHelper.getDarkMode()
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: FontWeight.w600,
                                        family: FontFamily.bahijJannaBold,
                                        start: 16.w,
                                      ),
                                      SizedBox(
                                        width: 200.w,
                                        child: AppText(
                                          text:
                                              'Contact us if you have any questions or suggestions',
                                          size: 14.sp,
                                          lines: 2,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                          family: FontFamily.bahijJannaRegular,
                                          start: 16.w,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16.w,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Divider(
                              thickness: 1,
                              color: Colors.grey.withAlpha(50),
                            ),
                            SizedBox(height: 16.h),
                            InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                AppRouter.navigateTo(context, PrivacyPolicy());
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: 50.w,
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                      color: Colors.green.withAlpha(30),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.privacy_tip_outlined,
                                        size: 24.w,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        text: 'Privacy Policy',
                                        size: 16.sp,
                                        color: CacheHelper.getDarkMode()
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: FontWeight.w600,
                                        family: FontFamily.bahijJannaBold,
                                        start: 16.w,
                                      ),
                                      AppText(
                                        text: 'Privacy Policy and Terms of Use',
                                        size: 14.sp,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        family: FontFamily.bahijJannaRegular,
                                        start: 16.w,
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16.w,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Divider(
                              thickness: 1,
                              color: Colors.grey.withAlpha(50),
                            ),
                            SizedBox(height: 16.h),
                            InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                AppRouter.navigateTo(context, AboutUs());
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: 50.w,
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                      color: Colors.red.withAlpha(30),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.info_outline,
                                        size: 24.w,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        text: 'About Us',
                                        size: 16.sp,
                                        color: CacheHelper.getDarkMode()
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: FontWeight.w600,
                                        family: FontFamily.bahijJannaBold,
                                        start: 16.w,
                                      ),
                                      AppText(
                                        text: 'About the app and our team',
                                        size: 14.sp,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        family: FontFamily.bahijJannaRegular,
                                        start: 16.w,
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16.w,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Divider(
                              thickness: 1,
                              color: Colors.grey.withAlpha(50),
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                Container(
                                  height: 50.w,
                                  width: 50.w,
                                  decoration: BoxDecoration(
                                    color: CacheHelper.getDarkMode()
                                        ? Colors.black.withAlpha(30)
                                        : Colors.orange.withAlpha(30),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/svg/${CacheHelper.getDarkMode() ? 'moon' : 'sun'}.svg',
                                      fit: BoxFit.cover,
                                      color: CacheHelper.getDarkMode()
                                          ? Colors.black
                                          : Colors.orange,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      text: CacheHelper.getDarkMode()
                                          ? 'Light Mode'
                                          : 'Dark Mode',
                                      size: 16.sp,
                                      color: CacheHelper.getDarkMode()
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      family: FontFamily.bahijJannaBold,
                                      start: 16.w,
                                    ),
                                    AppText(
                                      text: 'Toggle dark/light theme',
                                      size: 14.sp,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      family: FontFamily.bahijJannaRegular,
                                      start: 16.w,
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Transform.scale(
                                  scale: 0.8.r,
                                  child: Switch(
                                    padding: EdgeInsets.zero,
                                    trackOutlineColor:
                                        const WidgetStatePropertyAll(
                                          Colors.transparent,
                                        ),
                                    activeThumbColor: AppColors.primary,
                                    activeTrackColor: AppColors.primary
                                        .withOpacity(0.2),
                                    inactiveThumbColor: const Color(0xffB5B2B2),
                                    inactiveTrackColor: const Color(0xffDCDCDC),
                                    value: CacheHelper.getDarkMode(),
                                    onChanged: (bool value) {
                                      CacheHelper.setDarkMode(value);
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
