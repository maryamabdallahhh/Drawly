import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Toolbar colors
  static const toolbarBackground = Colors.white;
  static const selectedPurple = Color(0xFFF2EAFF);
  static const selectedGrey = Color(0xFFE1E4E7);
  static const hoverGrey = Color(0xFFF2F3F5);
  static const iconPurple = Color(0xFF612DAE);

  // Drawing colors - Pen
  static final penColors = [
    Colors.black,
    Colors.grey[700]!,
    Colors.blue[900]!,
    Colors.red[900]!,
    Colors.green[900]!,
    Colors.purple[900]!,
  ];

  // Drawing colors - Marker
  static const markerColors = [
    Colors.black,
    Colors.red,
    Color(0xFFFF9800),
    Color(0xFF4CAF50),
    Color(0xFF9C27B0),
    Color(0xFF2196F3),
  ];

  // Drawing colors - Highlighter
  static const highlighterColors = [
    Colors.yellow,
    Color(0xFFFFEB3B),
    Color(0xFF8BC34A),
    Color(0xFF00BCD4),
    Color(0xFFFF4081),
    Color(0xFFFF9800),
  ];

  // UI colors
  static final tooltipBackground = Colors.grey[800]!;
  static const panelBackground = Colors.white;
  static final panelShadow = Colors.black.withOpacity(0.1);
  static final dividerColor = Colors.grey[300]!;
  static final borderColor = Colors.grey[300]!;
  static final gridDotColor = Colors.grey;
}
