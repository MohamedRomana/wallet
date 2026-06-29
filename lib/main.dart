// ignore_for_file: deprecated_member_use
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/cache/cache_helper.dart';
import 'core/constants/contsants.dart';
import 'core/data/wallet_repository.dart';
import 'core/service/bloc_observer.dart';
import 'core/service/cubit/app_cubit.dart';
import 'core/theme/app_theme.dart';
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
  await WalletRepository.instance.init();
  ThemeController.isDark.value = CacheHelper.getDarkMode();
  Bloc.observer = MyBlocObserver();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      saveLocale: true,
      useOnlyLangCode: true,
      startLocale: Locale(
        CacheHelper.getLang() == "" ? "en" : CacheHelper.getLang(),
      ),
      assetLoader: const CodegenLoader(),
      path: 'assets/Lang',
      fallbackLocale: Locale(
        CacheHelper.getLang() == "" ? "en" : CacheHelper.getLang(),
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
          providers: [BlocProvider(create: (context) => AppCubit())],
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: ValueListenableBuilder<bool>(
              valueListenable: ThemeController.isDark,
              builder: (context, isDark, child) {
                return MaterialApp(
                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,
                  themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                  debugShowCheckedModeBanner: false,

                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,

                  navigatorKey: navigatorKey,

                  home: const Splash(), // ✅ الحل هنا
                );
              },
            ),
          ),
        );
      },
      child: const Splash(),
    );
  }
}
