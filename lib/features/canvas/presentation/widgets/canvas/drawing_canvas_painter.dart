import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../domain/models/drawing_path.dart';
import '../../../domain/models/drawing_point.dart';
import '../../../domain/models/drawing_tool_type.dart';

class DrawingCanvasPainter extends CustomPainter {
  final List<DrawingPath> paths;
  final List<DrawingPoint>? currentPath;
  final DrawingToolType? currentToolType;

  const DrawingCanvasPainter({required this.paths, this.currentPath, this.currentToolType});

  @override
  void paint(Canvas canvas, Size size) {
    // Save layer for blend modes to work correctly
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    // Draw completed paths
    for (final path in paths) {
      if (path.toolType.isShape) {
        _drawShape(canvas, path.points, path.toolType);
      } else {
        _drawPath(canvas, path.points);
      }
    }

    // Draw current active path
    if (currentPath != null && currentPath!.isNotEmpty && currentToolType != null) {
      if (currentToolType!.isShape) {
        _drawShape(canvas, currentPath!, currentToolType!);
      } else {
        _drawPath(canvas, currentPath!);
      }
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

  void _drawShape(Canvas canvas, List<DrawingPoint> points, DrawingToolType type) {
    if (points.isEmpty) return;
    final start = points.first;
    final end = points.last;
    final paint = start.paint;

    final rect = Rect.fromPoints(start.position, end.position);

    switch (type) {
      case DrawingToolType.rectangle:
        canvas.drawRect(rect, paint);
        break;
      case DrawingToolType.circle:
        canvas.drawOval(rect, paint);
        break;
      case DrawingToolType.roundedRectangle:
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)), paint);
        break;
      case DrawingToolType.triangle:
        final path = Path();
        path.moveTo(rect.center.dx, rect.top);
        path.lineTo(rect.right, rect.bottom);
        path.lineTo(rect.left, rect.bottom);
        path.close();
        canvas.drawPath(path, paint);
        break;
      case DrawingToolType.downTriangle:
        final path = Path();
        path.moveTo(rect.left, rect.top);
        path.lineTo(rect.right, rect.top);
        path.lineTo(rect.center.dx, rect.bottom);
        path.close();
        canvas.drawPath(path, paint);
        break;
      case DrawingToolType.heart:
        final path = Path();
        final width = rect.width;
        final height = rect.height;
        final x = rect.left;
        final y = rect.top;

        path.moveTo(x + 0.5 * width, y + 0.35 * height);
        path.cubicTo(x + 0.5 * width, y + 0.1 * height,
                     x + 1.0 * width, y + 0.1 * height,
                     x + 1.0 * width, y + 0.4 * height);
        path.cubicTo(x + 1.0 * width, y + 0.7 * height,
                     x + 0.5 * width, y + 0.9 * height,
                     x + 0.5 * width, y + 1.0 * height);
        path.cubicTo(x + 0.5 * width, y + 0.9 * height,
                     x + 0.0 * width, y + 0.7 * height,
                     x + 0.0 * width, y + 0.4 * height);
        path.cubicTo(x + 0.0 * width, y + 0.1 * height,
                     x + 0.5 * width, y + 0.1 * height,
                     x + 0.5 * width, y + 0.35 * height);
        path.close();
        canvas.drawPath(path, paint);
        break;
      case DrawingToolType.hexagonal:
        final path = Path();
        path.moveTo(rect.center.dx, rect.top);
        path.lineTo(rect.right, rect.top + rect.height * 0.25);
        path.lineTo(rect.right, rect.top + rect.height * 0.75);
        path.lineTo(rect.center.dx, rect.bottom);
        path.lineTo(rect.left, rect.top + rect.height * 0.75);
        path.lineTo(rect.left, rect.top + rect.height * 0.25);
        path.close();
        canvas.drawPath(path, paint);
        break;
      case DrawingToolType.asterisk: // Actually a Star
        final path = Path();
        final center = rect.center;
        final outerRadius = math.min(rect.width, rect.height) / 2;
        final innerRadius = outerRadius * 0.4;
        
        for (int i = 0; i < 10; i++) {
          final radius = i.isEven ? outerRadius : innerRadius;
          final angle = (math.pi * i / 5) - (math.pi / 2); // Start at top
          
          final x = center.dx + radius * math.cos(angle);
          final y = center.dy + radius * math.sin(angle);
          
          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
        break;
      default:
        canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant DrawingCanvasPainter oldDelegate) {
    return oldDelegate.paths != paths || oldDelegate.currentPath != currentPath || oldDelegate.currentToolType != currentToolType;
  }
}
