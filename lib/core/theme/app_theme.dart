import 'package:flutter/material.dart';

import '../../gen/fonts.gen.dart';
import '../constants/colors.dart';

/// Theme-mode dependent colors. Accessed via `context.palette`.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final Color background;
  final Color surface; // cards
  final Color surfaceAlt; // subtle fills (inputs, chips)
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color shadow;

  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.shadow,
  });

  static const light = AppPalette(
    background: Color(0xFFF4F5F9),
    surface: Colors.white,
    surfaceAlt: Color(0xFFEEF0F6),
    textPrimary: Color(0xFF111827),
    textSecondary: Color(0xFF6B7280),
    border: Color(0xFFE5E7EB),
    shadow: Color(0x14000000),
  );

  static const dark = AppPalette(
    background: Color(0xFF0B1120),
    surface: Color(0xFF161E2E),
    surfaceAlt: Color(0xFF1E2738),
    textPrimary: Color(0xFFF3F4F6),
    textSecondary: Color(0xFF9CA3AF),
    border: Color(0xFF2A3346),
    shadow: Color(0x33000000),
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? shadow,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

extension PaletteX on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

class AppTheme {
  AppTheme._();

  static ThemeData _base(Brightness brightness, AppPalette palette) {
    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      fontFamily: FontFamily.bahijJannaRegular,
      scaffoldBackgroundColor: palette.background,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: palette.surface,
      ),
      dividerColor: palette.border,
      datePickerTheme: DatePickerThemeData(
        backgroundColor: palette.surface,
        headerBackgroundColor: AppColors.primary,
        headerForegroundColor: Colors.white,
      ),
      extensions: [palette],
      splashFactory: InkRipple.splashFactory,
      shadowColor: palette.shadow,
      iconTheme: IconThemeData(color: palette.textPrimary),
    );
  }

  static final ThemeData light = _base(Brightness.light, AppPalette.light);
  static final ThemeData dark = _base(Brightness.dark, AppPalette.dark);
}
