import 'package:flutter/material.dart';

class PaintUtils {
  PaintUtils._();

  /// Create a standard drawing paint
  static Paint createDrawingPaint({
    required Color color,
    required double strokeWidth,
    required double opacity,
    bool isEraser = false,
  }) {
    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    if (isEraser) {
      return paint
        ..color = Colors.black
        ..blendMode = BlendMode.clear;
    }

    return paint
      ..color = color.withOpacity(opacity)
      ..blendMode = BlendMode.srcOver;
  }

  /// Create a grid dot paint
  static Paint createGridPaint({
    Color color = Colors.grey,
    double strokeWidth = 1.0,
  }) {
    return Paint()
      ..color = color
      ..strokeWidth = strokeWidth;
  }
}
