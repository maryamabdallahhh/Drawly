import 'package:flutter/material.dart';

class DrawingPath {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  DrawingPath({
    required this.points,
    this.color = Colors.black,
    this.strokeWidth = 3.0,
  });
}
