import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../gen/fonts.gen.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions>
    with TickerProviderStateMixin {
  late final AnimationController _textController;
  late final AnimationController _iconController;
  late final AnimationController _cardController;

  late final Animation<double> _textAnimation;
  late final Animation<double> _iconAnimation;
  late final Animation<double> _cardAnimation;

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _textAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    _iconAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );

    _cardAnimation = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _iconController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 361.w,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 25.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 25.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Opacity(opacity: _textAnimation.value, child: child);
                },
                child: AppText(
                  text: 'Recent Transactions',
                  size: 18.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  family: FontFamily.bahijJannaBold,
                ),
              ),
              const Spacer(),
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Opacity(opacity: _textAnimation.value, child: child);
                },
                child: AppText(
                  text: 'See All',
                  size: 14.sp,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          ListView.separated(
            itemCount: 10,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _cardController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _cardAnimation.value,
                    child: child,
                  );
                },
                child: Row(
                  children: [
                    AnimatedBuilder(
                      animation: _iconController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _iconAnimation.value,
                          child: child,
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/svg/shooping.svg',
                        width: 40.w,
                        height: 40.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: 'Bus Ticket',
                          size: 16.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        AppText(
                          text: 'Shopping, 7/3/2023',
                          size: 12.sp,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    const Spacer(),
                    AppText(
                      text: '-\$50',
                      size: 16.sp,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
