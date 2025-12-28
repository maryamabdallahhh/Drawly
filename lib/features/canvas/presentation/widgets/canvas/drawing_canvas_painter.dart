import 'package:flutter/material.dart';

import '../../../domain/models/drawing_path.dart';
import '../../../domain/models/drawing_point.dart';

class DrawingCanvasPainter extends CustomPainter {
  final List<DrawingPath> paths;
  final List<DrawingPoint>? currentPath;

  const DrawingCanvasPainter({required this.paths, this.currentPath});

  @override
  void paint(Canvas canvas, Size size) {
    // Save layer for blend modes to work correctly
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    // Draw completed paths
    for (final path in paths) {
      _drawPath(canvas, path.points);
    }

    // Draw current active path
    if (currentPath != null && currentPath!.isNotEmpty) {
      _drawPath(canvas, currentPath!);
    }

    canvas.restore();
  }

  void _drawPath(Canvas canvas, List<DrawingPoint> points) {
    if (points.isEmpty) return;

    if (points.length == 1) {
      // Single tap - draw a dot
      final point = points.first;
      canvas.drawCircle(
        point.position,
        point.paint.strokeWidth / 2,
        point.paint,
      );
      return;
    }

    // Draw smooth path
    final paint = points.first.paint;
    final path = Path();

    path.moveTo(points.first.position.dx, points.first.position.dy);

    // Use quadratic Bezier curves for smoother lines
    for (int i = 1; i < points.length; i++) {
      final p0 = points[i - 1].position;
      final p1 = points[i].position;

      // Control point is midpoint
      final midX = (p0.dx + p1.dx) / 2;
      final midY = (p0.dy + p1.dy) / 2;

      if (i == 1) {
        path.lineTo(midX, midY);
      } else {
        path.quadraticBezierTo(p0.dx, p0.dy, midX, midY);
      }
    }

    // Complete the path to the last point
    final lastPoint = points.last.position;
    path.lineTo(lastPoint.dx, lastPoint.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant DrawingCanvasPainter oldDelegate) {
    return oldDelegate.paths != paths || oldDelegate.currentPath != currentPath;
  }
}
