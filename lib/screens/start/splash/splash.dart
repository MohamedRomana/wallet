// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../gen/assets.gen.dart';
import '../../../core/widgets/app_router.dart';
import '../on_boarding/on_boarding.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _customNavigation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD9D9D9),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                Assets.img.logo.path,
                height: 300.h,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _customNavigation() {
    return Future.delayed(const Duration(seconds: 3), () {
      // CacheHelper.getLang() != ""
      //     ? CacheHelper.getUserId() != ""
      //           ? CacheHelper.getUserType() == "client" ||
      //                     CacheHelper.getUserType() == "admin"
      //                 ? AppRouter.navigateAndFinish(context, const HomeLayout())
      //                 : AppRouter.navigateAndFinish(
      //                     context,
      //                     const ProvHomeLayout(),
      //                   )
      //           : {
      //               CacheHelper.setUserType('client'),
      //               AppRouter.navigateAndFinish(context, const HomeLayout()),
      //             }
          // :
           AppRouter.navigateAndFinish(context, const OnBoarding());
    });
  }
}
