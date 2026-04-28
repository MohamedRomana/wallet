import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widgets/app_text.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _gradientController;

  late final Animation<double> _logoBounceAnimation;
  late final Animation<double> _titleFadeAnimation;
  late final Animation<Offset> _titleSlideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _logoBounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: -18.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -18.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 65,
      ),
    ]).animate(_logoController);

    _titleFadeAnimation = CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.15, 0.55, curve: Curves.easeIn),
    );

    _titleSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.7), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _textController,
            curve: const Interval(0.15, 0.55, curve: Curves.easeOutCubic),
          ),
        );
  }

  void _startAnimations() async {
    _logoController.repeat(reverse: true);
    await Future.delayed(const Duration(milliseconds: 300));
    _textController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          final t = _gradientController.value;

          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.lerp(
                    const Color(0xFF614BFB),
                    const Color(0xFF8B5CF6),
                    t,
                  )!,
                  Color.lerp(
                    const Color(0xFF751BDC),
                    const Color(0xFF3B1FA8),
                    t,
                  )!,
                  Color.lerp(
                    const Color(0xFF4C35E0),
                    const Color(0xFF614BFB),
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
            ),
            child: SingleChildScrollView(
              child: Form(
                // key: context.read<ContactUsCubit>().formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 120.h),
                    Center(
                      child: AnimatedBuilder(
                        animation: _logoBounceAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _logoBounceAnimation.value),
                            child: child,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28.r),
                            color: Colors.white.withValues(alpha: 0.10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 25,
                                spreadRadius: 1,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: Image.asset(
                              Assets.img.logo.path,
                              height: 150.w,
                              width: 150.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    SlideTransition(
                      position: _titleSlideAnimation,
                      child: FadeTransition(
                        opacity: _titleFadeAnimation,
                        child: AppText(
                          text: 'About Us',
                          start: 16.w,
                          bottom: 20.h,
                          size: 30.sp,
                          color: Colors.white,
                          family: FontFamily.bahijJannaBold,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          AppText(
                            text:
                                'هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها. ولذلك يتم استخدام طريقة لوريم إيبسوم لأنها تعطي توزيعاَ طبيعياَ -إلى حد ما- للأحرف عوضاً عن استخدام "هنا يوجد محتوى نصي، هنا يوجد محتوى نصي" فتجعلها تبدو (أي الأحرف) وكأنها نص مقروء. العديد من برامح النشر المكتبي وبرامح تحرير صفحات الويب تستخدم لوريم إيبسوم بشكل إفتراضي كنموذج عن النص، وإذا قمت بإدخال "lorem ipsum" في أي محرك بحث ستظهر العديد من المواقع الحديثة العهد في نتائج البحث. على مدى السنين ظهرت نسخ جديدة ومختلفة من نص لوريم إيبسوم، أحياناً عن طريق الصدفة، وأحياناً عن عمد كإدخال بعض العبارات الفكاهية إليها.',
                            textAlign: TextAlign.center,
                            start: 24.w,
                            end: 24.w,
                            bottom: 32.h,
                            color: Colors.white,
                            size: 16.sp,
                            fontWeight: FontWeight.w600,
                            lines: 100,
                          ),
                          SizedBox(height: 180.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
