import 'package:flutter/material.dart';
import 'package:vivid_canvas/features/canvas/domain/models/drawing_path.dart';
import 'package:vivid_canvas/features/canvas/domain/models/drawing_point.dart';
import 'package:vivid_canvas/features/canvas/domain/models/drawing_tool_type.dart';
import 'package:vivid_canvas/features/canvas/presentation/widgets/canvas/drawing_canvas_painter.dart';

class DrawingCanvas extends StatelessWidget {
  final List<DrawingPath> paths;
  final List<DrawingPoint>? currentPath;
  final DrawingToolType? currentToolType;
  final Set<String> selectedPathIds;
  final Rect? selectionMarquee;
  final bool isEnabled;
  final Function(Offset) onDrawStart;
  final Function(Offset, Offset) onDrawUpdate;
  final VoidCallback onDrawEnd;

  const DrawingCanvas({
    super.key,
    required this.paths,
    this.currentPath,
    this.currentToolType,
    this.selectedPathIds = const {},
    this.selectionMarquee,
    required this.isEnabled,
    required this.onDrawStart,
    required this.onDrawUpdate,
    required this.onDrawEnd,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DrawingCanvasPainter(
        paths: paths, 
        currentPath: currentPath, 
        currentToolType: currentToolType,
        selectedPathIds: selectedPathIds,
        selectionMarquee: selectionMarquee,
      ),
      child: isEnabled
          ? GestureDetector(
              // ✅ CRITICAL: Use translucent so it doesn't block everything
              behavior: HitTestBehavior.translucent,
              onPanStart: (details) {
                // print('🖌️ Pan START on canvas: ${details.localPosition}');
                onDrawStart(details.localPosition);
              },
              onTapUp: (details) {
                // Handles single tap (e.g. selection or drawing a dot)
                onDrawStart(details.localPosition);
                onDrawEnd();
              },
              onPanUpdate: (details) {
                onDrawUpdate(details.localPosition, details.delta);
              },
              onPanEnd: (_) {
                // print('🖌️ Pan END on canvas');
                onDrawEnd();
              },
              child: Container(color: Colors.transparent),
            )
          : Container(
              // ✅ When disabled, use opaque behavior to fully block gestures
              color: Colors.transparent,
            ),
    );
  }
}
