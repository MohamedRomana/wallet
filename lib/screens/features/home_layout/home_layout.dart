// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:wallet/core/constants/colors.dart';
import 'package:wallet/core/service/cubit/app_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../generated/locale_keys.g.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> with TickerProviderStateMixin {
  late AnimationController _plusController;
  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();

    /// 🔥 Pulse للزرار +
    _plusController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    /// 🔥 Gradient متحرك
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _plusController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final cubit = AppCubit.get(context);

        return WillPopScope(
          onWillPop: () async {
            bool? shouldPop = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: AppColors.secondray,
                title: Text(LocaleKeys.doYouWantToLeaveThisApp.tr()),
                content: Text(LocaleKeys.areYouSure.tr()),
                actions: [
                  TextButton(
                    onPressed: () => SystemNavigator.pop(),
                    child: Text(LocaleKeys.yes.tr()),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(LocaleKeys.no.tr()),
                  ),
                ],
              ),
            );
            return shouldPop ?? false;
          },

          child: Scaffold(
            extendBody: true,

            /// 🔥 Animated Body
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween(
                      begin: const Offset(0.1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: cubit.bottomNavScreens[cubit.bottomNavIndex],
            ),

            /// 🔥 Bottom Nav
            bottomNavigationBar: SafeArea(
              bottom: false,
              child: Container(
                height: 75.h,
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildItem(
                      icon: 'assets/svg/goal.svg',
                      isActive: cubit.bottomNavIndex == 0,
                      onTap: () => cubit.changebottomNavIndex(0),
                    ),

                    const SizedBox(),

                    _buildItem(
                      icon: 'assets/svg/track.svg',
                      isActive: cubit.bottomNavIndex == 1,
                      onTap: () => cubit.changebottomNavIndex(1),
                    ),

                    /// 🔥 زرار +
                    Transform.translate(
                      offset: Offset(0, -20.h),
                      child: GestureDetector(
                        onTap: () {
                          cubit.changebottomNavIndex(2);
                        },
                        child: AnimatedBuilder(
                          animation: Listenable.merge([
                            _plusController,
                            _gradientController,
                          ]),
                          builder: (context, child) {
                            final t = _gradientController.value;

                            return Transform.scale(
                              scale: 1 + (_plusController.value * 0.1),
                              child: Transform.rotate(
                                angle: _plusController.value * 0.5,
                                child: Container(
                                  height: 60.w,
                                  width: 60.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.lerp(
                                          AppColors.primary,
                                          AppColors.secondray,
                                          t,
                                        )!,
                                        Color.lerp(
                                          AppColors.secondray,
                                          AppColors.primary,
                                          t,
                                        )!,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(
                                          0.5,
                                        ),
                                        blurRadius: 25,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 30.w,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    _buildItem(
                      icon: 'assets/svg/pay.svg',
                      isActive: cubit.bottomNavIndex == 3,
                      onTap: () => cubit.changebottomNavIndex(3),
                    ),

                    const SizedBox(),

                    _buildItem(
                      icon: 'assets/svg/walet.svg',
                      isActive: cubit.bottomNavIndex == 4,
                      onTap: () => cubit.changebottomNavIndex(4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 🔥 زرار عادي Animated
  Widget _buildItem({
    required String icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return _AnimatedIconButton(icon: icon, isActive: isActive, onTap: onTap);
  }
}

class _AnimatedIconButton extends StatefulWidget {
  final String icon;
  final bool isActive;
  final VoidCallback onTap;

  const _AnimatedIconButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<_AnimatedIconButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotateController;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.8,
      upperBound: 1,
      value: 1,
    );

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  void _tap() {
    _scaleController.reverse().then((_) => _scaleController.forward());
    _rotateController.forward(from: 0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _tap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleController, _rotateController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleController.value,
            child: Transform.rotate(
              angle: _rotateController.value * 0.3,
              child: child,
            ),
          );
        },
        child: SvgPicture.asset(
          widget.icon,
          height: 30.w,
          width: 30.w,
          color: widget.isActive ? AppColors.primary : Colors.black,
        ),
      ),
    );
  }
}
