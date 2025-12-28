import 'package:flutter/material.dart';

import 'drawing_point.dart';
import 'drawing_tool_type.dart';

@immutable
class DrawingPath {
  final String id;
  final List<DrawingPoint> points;
  final DrawingToolType toolType;
  final DateTime timestamp;

  const DrawingPath({
    required this.id,
    required this.points,
    required this.toolType,
    required this.timestamp,
  });

  bool get isEmpty => points.isEmpty;
  bool get isNotEmpty => points.isNotEmpty;
  int get length => points.length;

  DrawingPath copyWith({
    String? id,
    List<DrawingPoint>? points,
    DrawingToolType? toolType,
    DateTime? timestamp,
  }) {
    return DrawingPath(
      id: id ?? this.id,
      points: points ?? this.points,
      toolType: toolType ?? this.toolType,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrawingPath &&
          id == other.id &&
          points == other.points &&
          toolType == other.toolType &&
          timestamp == other.timestamp;

  @override
  int get hashCode =>
      id.hashCode ^ points.hashCode ^ toolType.hashCode ^ timestamp.hashCode;
}
