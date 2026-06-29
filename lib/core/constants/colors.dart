import 'package:flutter/material.dart';

/// Brand palette. These are fixed brand colors (independent of theme mode).
/// For surface / text / card colors that change with light & dark mode, use
/// `context.palette` from `core/theme/app_theme.dart`.
abstract class AppColors {
  // Brand
  static const Color primary = Color(0xFF4F46E5); // indigo
  static const Color secondary = Color(0xFF8B5CF6); // violet
  static const Color accent = Color(0xFF06B6D4); // cyan

  /// Legacy misspelled alias kept for backwards compatibility.
  static const Color secondray = secondary;

  // Semantic
  static const Color income = Color(0xFF10B981); // green
  static const Color expense = Color(0xFFEF4444); // red
  static const Color warning = Color(0xFFF59E0B); // amber

  // Legacy names still referenced in older code paths.
  static const Color third = Colors.black;
  static const Color fourth = Colors.black;
  static const Color darkRed = Color(0xffBE1622);
  static const Color lightRed = Color(0xffFF0909);

  // Gradients
  static const List<Color> brandGradient = [
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
    Color(0xFF4F46E5),
  ];
}
