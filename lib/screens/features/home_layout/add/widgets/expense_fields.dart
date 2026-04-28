import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/cache/cache_helper.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/widgets/app_input.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../gen/fonts.gen.dart';

class ExpenseFields extends StatelessWidget {
  const ExpenseFields({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Container(
            width: 361.w,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: CacheHelper.getDarkMode()
                  ? Color(0xff1E2939)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.grey.withAlpha(100), width: 1.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: "Amount",
                  color: CacheHelper.getDarkMode()
                      ? Colors.white
                      : Colors.black,
                  size: 16.sp,
                  fontWeight: FontWeight.w700,
                  family: FontFamily.bahijJannaBold,
                ),
                SizedBox(height: 10.h),
                AppInput(
                  hint: "Enter amount",
                  inputType: TextInputType.number,
                  start: 0,
                  end: 0,
                  filled: true,
                  color: Colors.grey.withAlpha(30),
                  enabledBorderColor: Colors.transparent,
                ),
              ],
            ),
          ),
          Container(
            width: 361.w,
            padding: EdgeInsets.all(16.r),
            margin: EdgeInsets.only(top: 20.h),
            decoration: BoxDecoration(
              color: CacheHelper.getDarkMode()
                  ? Color(0xff1E2939)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.grey.withAlpha(100), width: 1.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: "Category",
                  color: CacheHelper.getDarkMode()
                      ? Colors.white
                      : Colors.black,
                  size: 16.sp,
                  fontWeight: FontWeight.w700,
                  family: FontFamily.bahijJannaBold,
                ),
                SizedBox(height: 10.h),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: 4,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(8.r),
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.grey.withAlpha(30),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: AppText(
                          text: 'Salary',
                          size: 14.sp,
                          color: CacheHelper.getDarkMode()
                              ? Colors.white
                              : Colors.black,
                          family: FontFamily.bahijJannaRegular,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            width: 361.w,
            padding: EdgeInsets.all(16.r),
            margin: EdgeInsets.only(top: 20.h),
            decoration: BoxDecoration(
              color: CacheHelper.getDarkMode()
                  ? Color(0xff1E2939)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.grey.withAlpha(100), width: 1.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: "Account",
                  color: CacheHelper.getDarkMode()
                      ? Colors.white
                      : Colors.black,
                  size: 16.sp,
                  fontWeight: FontWeight.w700,
                  family: FontFamily.bahijJannaBold,
                ),
                SizedBox(height: 10.h),
                AppInput(
                  hint: "Enter account",
                  inputType: TextInputType.text,
                  start: 0,
                  end: 0,
                  filled: true,
                  color: Colors.grey.withAlpha(30),
                  enabledBorderColor: Colors.transparent,
                ),
              ],
            ),
          ),
          Container(
            width: 361.w,
            padding: EdgeInsets.all(16.r),
            margin: EdgeInsets.only(top: 20.h),
            decoration: BoxDecoration(
              color: CacheHelper.getDarkMode()
                  ? Color(0xff1E2939)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.grey.withAlpha(100), width: 1.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: "Date",
                  color: CacheHelper.getDarkMode()
                      ? Colors.white
                      : Colors.black,
                  size: 16.sp,
                  fontWeight: FontWeight.w700,
                  family: FontFamily.bahijJannaBold,
                ),
                SizedBox(height: 10.h),
                AppInput(
                  hint: "Enter date",
                  inputType: TextInputType.text,
                  start: 0,
                  end: 0,
                  filled: true,
                  color: Colors.grey.withAlpha(30),
                  enabledBorderColor: Colors.transparent,
                  onTap: () async {
                    DateTime? dateTime = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                      builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColors.secondray,
                            onPrimary: Colors.white,
                            surface: Colors.white,
                            onSurface: Colors.black,
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (dateTime != null) {
                      // String formattedDate =
                      //     DateFormat('yyyy-MM-dd').format(dateTime);
                      // setState(() {
                      //   widget.chooseDateController.text =
                      //       formattedDate;
                      // });
                    }
                  },
                  read: true,
                ),
              ],
            ),
          ),
          Container(
            width: 361.w,
            padding: EdgeInsets.all(16.r),
            margin: EdgeInsets.only(top: 20.h, bottom: 100.h),
            decoration: BoxDecoration(
              color: CacheHelper.getDarkMode()
                  ? Color(0xff1E2939)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.grey.withAlpha(100), width: 1.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: "Note (optional)",
                  color: CacheHelper.getDarkMode()
                      ? Colors.white
                      : Colors.black,
                  size: 16.sp,
                  fontWeight: FontWeight.w700,
                  family: FontFamily.bahijJannaBold,
                ),
                SizedBox(height: 10.h),
                AppInput(
                  hint: "Enter note",
                  inputType: TextInputType.text,
                  start: 0,
                  end: 0,
                  filled: true,
                  color: Colors.grey.withAlpha(30),
                  enabledBorderColor: Colors.transparent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
