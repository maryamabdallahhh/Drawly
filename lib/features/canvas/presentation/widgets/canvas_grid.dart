import 'package:flutter/material.dart';

class InfiniteGridPainter extends CustomPainter {
  final Matrix4 transform; // We pass the current zoom/pan state

  InfiniteGridPainter(this.transform);

  @override
  void paint(Canvas canvas, Size size) {
    //   zoom level and offsets from the matrix
    double scale = transform.getMaxScaleOnAxis();
    double translationX = transform.storage[12];
    double translationY = transform.storage[13];

    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0;

    double step = 30.0 * scale; // The dots scale

    //   where the first dot should start based on movement
    double startX = translationX % step;
    double startY = translationY % step;

    //   Draw dots across the entire visible screen
    for (double x = startX; x < size.width; x += step) {
      for (double y = startY; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 1.0 * scale, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant InfiniteGridPainter oldDelegate) {
    return oldDelegate.transform != transform;
  }
}
