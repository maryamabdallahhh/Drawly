import 'package:flutter/material.dart';

@immutable
class DrawingPoint {
  final Offset position;
  final Paint paint;

  const DrawingPoint({required this.position, required this.paint});

  DrawingPoint copyWith({Offset? position, Paint? paint}) {
    return DrawingPoint(
      position: position ?? this.position,
      paint: paint ?? this.paint,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrawingPoint &&
          position == other.position &&
          paint == other.paint;

  @override
  int get hashCode => position.hashCode ^ paint.hashCode;
}
