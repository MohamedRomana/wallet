import 'dart:ui';

import 'package:flutter/material.dart';

import '../cache/cache_helper.dart';

abstract class AppColors {
  static final Color primary = CacheHelper.getDarkMode()
      ? Color(0xff21378E)
      : Colors.blue;
  static Color secondray = CacheHelper.getDarkMode()
      ? Color(0xff58198B)
      : Color(0xFF8B5CF6);
  static const Color third = Colors.black;
  static const Color fourth = Colors.black;
  static const Color darkRed = Color(0xffBE1622);
  static const Color lightRed = Color(0xffFF0909);
}
