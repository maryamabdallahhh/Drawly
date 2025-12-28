import 'package:flutter/material.dart';
import 'package:vivid_canvas/features/canvas/domain/models/drawing_path.dart';
import 'package:vivid_canvas/features/canvas/domain/models/drawing_point.dart';
import 'package:vivid_canvas/features/canvas/presentation/widgets/canvas/drawing_canvas_painter.dart';

class DrawingCanvas extends StatelessWidget {
  final List<DrawingPath> paths;
  final List<DrawingPoint>? currentPath;
  final bool isEnabled;
  final Function(Offset) onDrawStart;
  final Function(Offset) onDrawUpdate;
  final VoidCallback onDrawEnd;

  const DrawingCanvas({
    super.key,
    required this.paths,
    this.currentPath,
    required this.isEnabled,
    required this.onDrawStart,
    required this.onDrawUpdate,
    required this.onDrawEnd,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DrawingCanvasPainter(paths: paths, currentPath: currentPath),
      child: isEnabled
          ? GestureDetector(
              onPanStart: (details) => onDrawStart(details.localPosition),
              onPanUpdate: (details) => onDrawUpdate(details.localPosition),
              onPanEnd: (_) => onDrawEnd(),
              child: Container(color: Colors.transparent),
            )
          : const SizedBox.expand(),
    );
  }
}
