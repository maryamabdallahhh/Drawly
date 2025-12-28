import 'package:flutter/material.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_colors.dart';

class GridPainter extends CustomPainter {
  final Matrix4 transform;

  const GridPainter({required this.transform});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = transform.getMaxScaleOnAxis();
    final translationX = transform.storage[12];
    final translationY = transform.storage[13];

    final paint = Paint()
      ..color = AppColors.gridDotColor
      ..strokeWidth = 1.0;

    final step = AppSizes.gridStep * scale;
    final startX = translationX % step;
    final startY = translationY % step;

    // Draw dots
    for (double x = startX; x < size.width; x += step) {
      for (double y = startY; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), AppSizes.gridDotSize * scale, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) {
    return oldDelegate.transform != transform;
  }
}
