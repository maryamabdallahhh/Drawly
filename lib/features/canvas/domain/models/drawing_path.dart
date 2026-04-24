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

  Rect get bounds {
    if (points.isEmpty) return Rect.zero;
    if (points.length == 1) {
      final pos = points.first.position;
      final strokeWidth = points.first.paint.strokeWidth;
      return Rect.fromCenter(center: pos, width: strokeWidth, height: strokeWidth);
    }
    
    if (toolType.isShape) {
      // Shapes use start and end points as bounds
      return Rect.fromPoints(points.first.position, points.last.position);
    }
    
    // For freehand paths, find the min and max coordinates
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;
    
    for (final point in points) {
      if (point.position.dx < minX) minX = point.position.dx;
      if (point.position.dy < minY) minY = point.position.dy;
      if (point.position.dx > maxX) maxX = point.position.dx;
      if (point.position.dy > maxY) maxY = point.position.dy;
    }
    
    // Add padding based on stroke width to ensure bounds completely cover the ink
    final strokePadding = points.first.paint.strokeWidth / 2;
    return Rect.fromLTRB(
      minX - strokePadding, 
      minY - strokePadding, 
      maxX + strokePadding, 
      maxY + strokePadding
    );
  }

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
