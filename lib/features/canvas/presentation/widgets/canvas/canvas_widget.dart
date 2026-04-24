import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivid_canvas/features/canvas/presentation/providers/canvas_state_provider.dart';
import 'package:vivid_canvas/features/canvas/presentation/providers/drawing_state_provider.dart';
import 'package:vivid_canvas/features/canvas/presentation/providers/ui_state_provider.dart';
import 'package:vivid_canvas/features/canvas/domain/models/resize_handle.dart';
import 'drawing_canvas.dart';
import 'grid_painter.dart';

class CanvasWidget extends ConsumerStatefulWidget {
  const CanvasWidget({super.key});

  @override
  ConsumerState<CanvasWidget> createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends ConsumerState<CanvasWidget> {
  late TransformationController _transformController;
  bool _isDraggingSelection = false;
  ResizeHandle? _activeResizeHandle;

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
    final isSelectionMode = ref.watch(isSelectionModeProvider);
    final isCanvasEnabled = isDrawingMode || isSelectionMode;

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
                currentToolType: drawingState.settings.toolType,
                selectedPathId: drawingState.selectedPathId,
                isEnabled: isCanvasEnabled,
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

  ResizeHandle? _hitTestHandle(Offset position, DrawingState state) {
    if (state.selectedPathId == null) return null;
    
    final index = state.paths.indexWhere((p) => p.id == state.selectedPathId);
    if (index == -1) return null;
    final path = state.paths[index];
    
    final bounds = path.bounds;
    const hitSlop = 16.0;
    
    bool containsPoint(Offset center) {
      return Rect.fromCenter(center: center, width: hitSlop * 2, height: hitSlop * 2).contains(position);
    }
    
    if (containsPoint(bounds.topLeft)) return ResizeHandle.topLeft;
    if (containsPoint(bounds.topCenter)) return ResizeHandle.topCenter;
    if (containsPoint(bounds.topRight)) return ResizeHandle.topRight;
    if (containsPoint(bounds.centerLeft)) return ResizeHandle.centerLeft;
    if (containsPoint(bounds.centerRight)) return ResizeHandle.centerRight;
    if (containsPoint(bounds.bottomLeft)) return ResizeHandle.bottomLeft;
    if (containsPoint(bounds.bottomCenter)) return ResizeHandle.bottomCenter;
    if (containsPoint(bounds.bottomRight)) return ResizeHandle.bottomRight;
    
    return null;
  }

  void _handleDrawStart(Offset position) {
    ref.read(uiStateProvider.notifier).closeAllPanels();
    
    if (ref.read(isSelectionModeProvider)) {
      final drawingState = ref.read(drawingStateProvider);
      final handle = _hitTestHandle(position, drawingState);
      
      if (handle != null) {
        _activeResizeHandle = handle;
        _isDraggingSelection = true;
      } else {
        _activeResizeHandle = null;
        ref.read(drawingStateProvider.notifier).selectPathAt(position);
        
        final newState = ref.read(drawingStateProvider);
        _isDraggingSelection = newState.selectedPathId != null;
      }
    } else {
      ref.read(drawingStateProvider.notifier).startPath(position);
    }
  }

  void _handleDrawUpdate(Offset position, Offset delta) {
    if (ref.read(isSelectionModeProvider)) {
      if (_isDraggingSelection) {
        if (_activeResizeHandle != null) {
          ref.read(drawingStateProvider.notifier).resizeSelectedPath(delta, _activeResizeHandle!);
        } else {
          ref.read(drawingStateProvider.notifier).moveSelectedPath(delta);
        }
      }
    } else {
      ref.read(drawingStateProvider.notifier).addPoint(position);
    }
  }

  void _handleDrawEnd() {
    if (ref.read(isSelectionModeProvider)) {
      _isDraggingSelection = false;
      _activeResizeHandle = null;
    } else {
      ref.read(drawingStateProvider.notifier).completePath();
    }
  }
}
