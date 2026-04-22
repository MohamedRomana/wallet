// import 'package:wallet/core/cache/cache_helper.dart';
// import 'package:wallet/core/widgets/app_button.dart';
// import 'package:wallet/core/widgets/app_text.dart';
// import 'package:wallet/gen/fonts.gen.dart';
// import 'package:wallet/screens/users/home_layout/home_layout.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../core/constants/colors.dart';
// import '../../../core/service/cubit/app_cubit.dart';
// import '../../../core/widgets/app_router.dart';
// import '../../../gen/assets.gen.dart';
// import '../../../generated/locale_keys.g.dart';
// import '../../auth/views/login/login.dart';
// import '../../auth/views/register/register.dart';

// class Types extends StatelessWidget {
//   const Types({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AppCubit, AppState>(
//       builder: (context, state) {
//         return Scaffold(
//           backgroundColor: AppColors.secondray,
//           body: SafeArea(
//             bottom: false,
//             child: Stack(
//               children: [
//                 PositionedDirectional(
//                   bottom: 0,
//                   child: Image.asset(
//                     Assets.img.types.path,
//                     height: 270.h,
//                     width: 375.w,
//                     fit: BoxFit.cover,
//                     color: AppColors.primary,
//                   ),
//                 ),
//                 Center(
//                   child: Column(
//                     children: [
//                       AppText(
//                         top: 102.h,
//                         text: LocaleKeys.let_start_now.tr(),
//                         color: Colors.black,
//                         size: 14.sp,
//                         family: FontFamily.bahijJannaBold,
//                         bottom: 4.h,
//                       ),
//                       AppText(
//                         text: LocaleKeys.let_us_help_you_now.tr(),
//                         size: 36.sp,
//                         color: AppColors.primary,
//                         family: FontFamily.bahijJannaBold,
//                         bottom: 44.h,
//                       ),
//                       AppButton(
//                         onPressed: () {
//                           CacheHelper.setUserType('client');
//                           AppRouter.navigateTo(context, const Register());
//                         },
//                         radius: 15.r,
//                         bottom: 16.h,
//                         color: Colors.white,
//                         child: AppText(
//                           text: LocaleKeys.create_account.tr(),
//                           size: 22.sp,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       AppButton(
//                         onPressed: () {
//                           CacheHelper.setUserType('client');
//                           AppRouter.navigateTo(context, const LogIn());
//                         },
//                         radius: 15.r,
//                         bottom: 16.h,
//                         color: AppColors.primary,
//                         child: AppText(
//                           text: LocaleKeys.login.tr(),
//                           size: 22.sp,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
