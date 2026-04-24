import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.iconPurple,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.iconPurple,
        thumbColor: AppColors.iconPurple,
        overlayColor: AppColors.iconPurple.withValues(alpha: 0.2),
      ),
    );
  }

  // Shadow styles
  static List<BoxShadow> get toolbarShadow => [
    BoxShadow(
      color: AppColors.panelShadow,
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get panelShadow => [
    BoxShadow(
      color: AppColors.panelShadow,
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get tooltipShadow => [
    const BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
  ];
}
