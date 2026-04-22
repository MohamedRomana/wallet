// ignore_for_file: deprecated_member_use

import 'package:wallet/core/constants/contsants.dart';
import 'package:wallet/core/widgets/app_cached.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/colors.dart';
import '../../../core/service/cubit/app_cubit.dart';
import '../../../core/widgets/app_text.dart';
import 'widgets/on_boarding_buttons.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  double currPage = 0.0;
  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0)
      ..addListener(() {
        setState(() {
          currPage = pageController.page!;
        });
      });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return SafeArea(
          bottom: false,
          top: false,
          child: Scaffold(
            body: state is GetIntroLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : Stack(
                    children: [
                      PageView.builder(
                        controller: pageController,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              PositionedDirectional(
                                top: 108.h,
                                start: 40.w,
                                end: 40.w,
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        200.r,
                                      ),
                                      child: AppCachedImage(
                                        image: '',
                                        height: isIPad(context) ? 150.w : 250.w,
                                        width: isIPad(context) ? 150.w : 250.w,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    AppText(
                                      top: 24.h,
                                      bottom: 16.h,
                                      text: '',
                                      size: 36.sp,
                                      color: const Color(0xff94B39F),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    AppText(
                                      text: '',
                                      lines: 3,
                                      size: 16.sp,
                                      textAlign: TextAlign.center,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                              CustomOnBoardingButtons(
                                pagesList: ['', '', ''],
                                currPage: currPage,
                                pageController: pageController,
                              ),
                            ],
                          );
                        },
                      ),
                      PositionedDirectional(
                        bottom: 210.h,
                        end: 20.w,
                        start: 20.w,
                        child: DotsIndicator(
                          dotsCount: 3,
                          position: currPage,
                          decorator: DotsDecorator(
                            activeColor: AppColors.third,
                            color: const Color(0xff878787).withOpacity(0.3),
                            size: Size.square(12.r),
                            activeSize: Size(20.w, 12.h),
                            activeShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
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
