import 'package:flutter/material.dart';

class AppColors {
  // Light theme
  static const lightBg = Color(0xFFFAF6F0);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurface2 = Color(0xFFFAF6F0);
  static const lightBorder = Color(0xFFE8DDD0);
  static const lightBorderNote = Color(0xFFF0E8D0);
  static const lightText = Color(0xFF3D2B1F);
  static const lightTextSub = Color(0xFFB8A090);
  static const lightTextMid = Color(0xFF5C4033);
  static const lightAccent = Color(0xFFD4A96A);
  static const lightAccentHover = Color(0xFFB8894E);
  static const lightAccentLabel = Color(0xFF8B6840);
  static const lightTag = Color(0xFFF5EFE6);
  static const lightTagText = Color(0xFF8B6840);
  static const lightProgressBg = Color(0xFFF0E8DC);
  static const lightNoteBg = Color(0xFFFFFDF7);
  static const lightInputBg = Color(0xFFFAF6F0);
  static const lightDeleteBorder = Color(0xFFFFCDD2);
  static const lightDeleteText = Color(0xFFE57373);

  // Dark theme
  static const darkBg = Color(0xFF0F0F14);
  static const darkSurface = Color(0xFF1C1C26);
  static const darkSurface2 = Color(0xFF16161F);
  static const darkBorder = Color(0xFF2E2E3E);
  static const darkBorderNote = Color(0xFF2E2E3E);
  static const darkText = Color(0xFFEDE8FF);
  static const darkTextSub = Color(0xFF6A6A8A);
  static const darkTextMid = Color(0xFFC4BFDB);
  static const darkAccent = Color(0xFFA78BFA);
  static const darkAccentLabel = Color(0xFFA78BFA);
  static const darkTag = Color(0xFF2A1F4A);
  static const darkTagText = Color(0xFFA78BFA);
  static const darkProgressBg = Color(0xFF2A2A3A);
  static const darkNoteBg = Color(0xFF1A1A2A);
  static const darkInputBg = Color(0xFF16161F);
  static const darkDeleteBorder = Color(0xFF4A2030);
  static const darkDeleteText = Color(0xFFF87171);

  static const progressGreen1 = Color(0xFF66BB6A);
  static const progressGreen2 = Color(0xFFA5D6A7);
}

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightAccent,
        secondary: AppColors.lightAccentLabel,
        surface: AppColors.lightSurface,
      ),
      fontFamily: 'Georgia',
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkAccent,
        secondary: AppColors.darkAccentLabel,
        surface: AppColors.darkSurface,
      ),
      fontFamily: 'Georgia',
    );
  }
}

class AppColorsTheme {
  final bool isDark;
  const AppColorsTheme(this.isDark);

  Color get bg => isDark ? AppColors.darkBg : AppColors.lightBg;
  Color get surface => isDark ? AppColors.darkSurface : AppColors.lightSurface;
  Color get surface2 => isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
  Color get border => isDark ? AppColors.darkBorder : AppColors.lightBorder;
  Color get borderNote => isDark ? AppColors.darkBorderNote : AppColors.lightBorderNote;
  Color get text => isDark ? AppColors.darkText : AppColors.lightText;
  Color get textSub => isDark ? AppColors.darkTextSub : AppColors.lightTextSub;
  Color get textMid => isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
  Color get accent => isDark ? AppColors.darkAccent : AppColors.lightAccent;
  Color get accentLabel => isDark ? AppColors.darkAccentLabel : AppColors.lightAccentLabel;
  Color get tag => isDark ? AppColors.darkTag : AppColors.lightTag;
  Color get tagText => isDark ? AppColors.darkTagText : AppColors.lightTagText;
  Color get progressBg => isDark ? AppColors.darkProgressBg : AppColors.lightProgressBg;
  Color get noteBg => isDark ? AppColors.darkNoteBg : AppColors.lightNoteBg;
  Color get inputBg => isDark ? AppColors.darkInputBg : AppColors.lightInputBg;
  Color get deleteBorder => isDark ? AppColors.darkDeleteBorder : AppColors.lightDeleteBorder;
  Color get deleteText => isDark ? AppColors.darkDeleteText : AppColors.lightDeleteText;

  LinearGradient get heroBg => isDark
      ? const LinearGradient(
          colors: [Color(0xFF1E1A33), Color(0xFF2D2250)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      : const LinearGradient(
          colors: [Color(0xFFF5EFE6), Color(0xFFEAD8BE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

  LinearGradient get progressGrad => isDark
      ? const LinearGradient(colors: [Color(0xFFA78BFA), Color(0xFFC4B5FD)])
      : const LinearGradient(colors: [Color(0xFFD4A96A), Color(0xFFE8C48A)]);

  LinearGradient get progressGreen =>
      const LinearGradient(colors: [AppColors.progressGreen1, AppColors.progressGreen2]);

  Color get doneCardBg => isDark ? const Color(0xFF1A2E1F) : const Color(0xFFE8F5E9);
  Color get donedCardBgDisabled => isDark ? const Color(0xFF4A4A5A) : const Color(0xFFB8A090);
}
