// ignore_for_file: deprecated_member_use
import 'package:wallet/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/cache/cache_helper.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/app_text.dart';

class CustomOnBoardingButtons extends StatelessWidget {
  const CustomOnBoardingButtons({
    super.key,
    required this.pagesList,
    required this.currPage,
    required this.pageController,
  });

  final List pagesList;
  final double currPage;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      end: 150.w,
      bottom: 48.h,
      child: Column(
        children: [
          Visibility(
            visible: currPage <= pagesList.length - 1.5,
            child: TextButton(
              onPressed: () {
                pageController.animateToPage(
                  pagesList.length - 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
              child: AppText(
                text: LocaleKeys.skip.tr(),
                color: Colors.black,
                size: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          currPage <= pagesList.length - 1.5
              ? InkWell(
                  onTap: () {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Container(
                    width: 50.w,
                    height: 50.w,
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(500.r),
                    ),
                    child: Transform.scale(
                      scaleX: -1,
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    CacheHelper.setLang('ar');
                    context.setLocale(const Locale('ar'));
                    // CacheHelper.setUserType('client');
                    // AppRouter.navigateAndFinish(context, const HomeLayout());
                  },
                  child: Container(
                    width: 50.w,
                    height: 50.w,
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(500.r),
                    ),
                    child: Transform.scale(
                      scaleX: -1,
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
