// ignore_for_file: deprecated_member_use
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/constants/colors.dart';
import 'core/cache/cache_helper.dart';
import 'core/service/bloc_observer.dart';
import 'core/service/cubit/app_cubit.dart';
import 'gen/fonts.gen.dart';
import 'generated/codegen_loader.g.dart';
import 'screens/start/splash/splash.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();
  // await NotificationHelper.initFirebaseAndFCM();
  await EasyLocalization.ensureInitialized();
  debugPrint("userId is ${CacheHelper.getUserId()}");

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      saveLocale: true,
      useOnlyLangCode: true,
      startLocale: Locale(
        CacheHelper.getLang() == "" ? "ar" : CacheHelper.getLang(),
      ),
      assetLoader: const CodegenLoader(),
      path: 'assets/Lang',
      fallbackLocale: Locale(
        CacheHelper.getLang() == "" ? "ar" : CacheHelper.getLang(),
      ),
      child: const MyApp(),
    ),
  );
  // NotificationHelper.setupListeners();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AppCubit()),
          ],
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: MaterialApp(
              theme: ThemeData(
                fontFamily: FontFamily.bahijJannaRegular,
                scaffoldBackgroundColor: Colors.white,
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: AppColors.primary,
                  selectionColor: AppColors.primary.withOpacity(0.3),
                  selectionHandleColor: AppColors.primary,
                ),
              ),
              debugShowCheckedModeBanner: false,
              builder: (context, child) => child!,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              navigatorKey: navigatorKey,
              home: child,
            ),
          ),
        );
      },
      child: const Splash(),
    );
  }
}
