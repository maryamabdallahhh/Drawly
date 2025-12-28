import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivid_canvas/features/canvas/presentation/providers/canvas_state_provider.dart';
import 'package:vivid_canvas/features/canvas/presentation/providers/drawing_state_provider.dart';
import 'package:vivid_canvas/features/canvas/presentation/providers/ui_state_provider.dart';
import 'drawing_canvas.dart';
import 'grid_painter.dart';

class CanvasWidget extends ConsumerStatefulWidget {
  const CanvasWidget({super.key});

  @override
  ConsumerState<CanvasWidget> createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends ConsumerState<CanvasWidget> {
  late TransformationController _transformController;

  @override
  void initState() {
    super.initState();
    _transformController = TransformationController();
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final drawingState = ref.watch(drawingStateProvider);
    final isDrawingMode = ref.watch(isDrawingModeProvider);

    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTapDown: _handleBackgroundTap,
      child: Stack(
        children: [
          // Infinite grid background
          Positioned.fill(
            child: ValueListenableBuilder<Matrix4>(
              valueListenable: _transformController,
              builder: (context, matrix, _) {
                return CustomPaint(painter: GridPainter(transform: matrix));
              },
            ),
          ),

          // Drawing layer
          Positioned.fill(
            child: RepaintBoundary(
              child: DrawingCanvas(
                paths: drawingState.paths,
                currentPath: drawingState.currentPath,
                isEnabled: isDrawingMode,
                onDrawStart: _handleDrawStart,
                onDrawUpdate: _handleDrawUpdate,
                onDrawEnd: _handleDrawEnd,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleBackgroundTap(TapDownDetails details) {
    // Close panels when tapping background (not toolbar area)
    final toolbarRect = Rect.fromLTWH(100, 50, 400, 600);
    if (!toolbarRect.contains(details.globalPosition)) {
      ref.read(uiStateProvider.notifier).closeAllPanels();
    }
  }

  void _handleDrawStart(Offset position) {
    ref.read(uiStateProvider.notifier).closeAllPanels();
    ref.read(drawingStateProvider.notifier).startPath(position);
  }

  void _handleDrawUpdate(Offset position) {
    ref.read(drawingStateProvider.notifier).addPoint(position);
  }

  void _handleDrawEnd() {
    ref.read(drawingStateProvider.notifier).completePath();
  }
}
