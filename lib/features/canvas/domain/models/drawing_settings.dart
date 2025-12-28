import 'package:flutter/material.dart';

import '../../../../core/utils/paint_utils.dart';
import 'drawing_tool_type.dart';

@immutable
class DrawingSettings {
  final Color color;
  final double strokeWidth;
  final double opacity;
  final DrawingToolType toolType;

  const DrawingSettings({
    required this.color,
    required this.strokeWidth,
    required this.opacity,
    required this.toolType,
  });

  /// Factory for tool-specific defaults
  factory DrawingSettings.forTool(DrawingToolType tool) {
    switch (tool) {
      case DrawingToolType.pen:
        return const DrawingSettings(
          color: Colors.black,
          strokeWidth: 2.0,
          opacity: 1.0,
          toolType: DrawingToolType.pen,
        );
      case DrawingToolType.marker:
        return const DrawingSettings(
          color: Colors.blue,
          strokeWidth: 8.0,
          opacity: 0.9,
          toolType: DrawingToolType.marker,
        );
      case DrawingToolType.highlighter:
        return const DrawingSettings(
          color: Colors.yellow,
          strokeWidth: 20.0,
          opacity: 0.4,
          toolType: DrawingToolType.highlighter,
        );
      case DrawingToolType.eraser:
        return const DrawingSettings(
          color: Colors.white,
          strokeWidth: 30.0,
          opacity: 1.0,
          toolType: DrawingToolType.eraser,
        );
    }
  }

  /// Convert settings to Paint object
  Paint toPaint() {
    return PaintUtils.createDrawingPaint(
      color: color,
      strokeWidth: strokeWidth,
      opacity: opacity,
      isEraser: toolType.isEraser,
    );
  }

  DrawingSettings copyWith({
    Color? color,
    double? strokeWidth,
    double? opacity,
    DrawingToolType? toolType,
  }) {
    return DrawingSettings(
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      opacity: opacity ?? this.opacity,
      toolType: toolType ?? this.toolType,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrawingSettings &&
          color == other.color &&
          strokeWidth == other.strokeWidth &&
          opacity == other.opacity &&
          toolType == other.toolType;

  @override
  int get hashCode =>
      color.hashCode ^
      strokeWidth.hashCode ^
      opacity.hashCode ^
      toolType.hashCode;
}
