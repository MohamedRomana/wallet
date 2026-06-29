import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/colors.dart';
import '../../../core/service/cubit/app_cubit.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_text.dart';
import '../../../gen/fonts.gen.dart';
import '../../../generated/locale_keys.g.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  static const _items = [
    _NavItem('assets/svg/walet.svg', 0),
    _NavItem('assets/svg/pay.svg', 1),
    _NavItem('assets/svg/track.svg', 3),
    _NavItem('assets/svg/goal.svg', 4),
  ];

  Future<void> _confirmExit(BuildContext context) async {
    final palette = context.palette;
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: palette.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: AppText(
          text: LocaleKeys.doYouWantToLeaveThisApp.tr(),
          size: 16.sp,
          fontWeight: FontWeight.w700,
          family: FontFamily.bahijJannaBold,
          color: palette.textPrimary,
        ),
        content: AppText(
          text: LocaleKeys.areYouSure.tr(),
          color: palette.textSecondary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: AppText(text: LocaleKeys.no.tr(), color: AppColors.income),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: AppText(text: LocaleKeys.yes.tr(), color: AppColors.expense),
          ),
        ],
      ),
    );
    if (leave == true) SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final cubit = AppCubit.get(context);
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _confirmExit(context);
          },
          child: Scaffold(
            extendBody: true,
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              child: KeyedSubtree(
                key: ValueKey(cubit.bottomNavIndex),
                child: cubit.bottomNavScreens[cubit.bottomNavIndex],
              ),
            ),
            bottomNavigationBar: _BottomBar(cubit: cubit, items: _items),
          ),
        );
      },
    );
  }
}

class _NavItem {
  final String icon;
  final int index;
  const _NavItem(this.icon, this.index);
}

class _BottomBar extends StatelessWidget {
  final AppCubit cubit;
  final List<_NavItem> items;
  const _BottomBar({required this.cubit, required this.items});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SafeArea(
      bottom: false,
      child: Container(
        height: 74.h,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          boxShadow: [
            BoxShadow(
              color: palette.shadow,
              blurRadius: 18,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavButton(
              item: items[0],
              active: cubit.bottomNavIndex == 0,
              onTap: () => cubit.changebottomNavIndex(0),
            ),
            _NavButton(
              item: items[1],
              active: cubit.bottomNavIndex == 1,
              onTap: () => cubit.changebottomNavIndex(1),
            ),
            _CenterAddButton(
              active: cubit.bottomNavIndex == 2,
              onTap: () => cubit.changebottomNavIndex(2),
            ),
            _NavButton(
              item: items[2],
              active: cubit.bottomNavIndex == 3,
              onTap: () => cubit.changebottomNavIndex(3),
            ),
            _NavButton(
              item: items[3],
              active: cubit.bottomNavIndex == 4,
              onTap: () => cubit.changebottomNavIndex(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool active;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedScale(
        scale: active ? 1.15 : 1,
        duration: const Duration(milliseconds: 200),
        child: SvgPicture.asset(
          item.icon,
          width: 26.w,
          height: 26.w,
          colorFilter: ColorFilter.mode(
            active ? AppColors.primary : palette.textSecondary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

class _CenterAddButton extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;
  const _CenterAddButton({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.translate(
        offset: Offset(0, -18.h),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 58.w,
          width: 58.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.45),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: AnimatedRotation(
            turns: active ? 0.125 : 0,
            duration: const Duration(milliseconds: 250),
            child: Icon(Icons.add, color: Colors.white, size: 30.w),
          ),
        ),
      ),
    );
  }
}
