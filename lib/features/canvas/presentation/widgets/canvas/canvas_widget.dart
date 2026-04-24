import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivid_canvas/features/canvas/presentation/providers/canvas_state_provider.dart';
import 'package:vivid_canvas/features/canvas/presentation/providers/drawing_state_provider.dart';
import 'package:vivid_canvas/features/canvas/presentation/providers/ui_state_provider.dart';
import 'package:vivid_canvas/features/canvas/presentation/providers/tool_state_provider.dart';
import 'package:vivid_canvas/features/canvas/domain/models/tool_type.dart';
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
  bool _isDraggingMarquee = false;
  Offset? _marqueeStart;
  Offset? _marqueeCurrent;
  ResizeHandle? _activeResizeHandle;
  MouseCursor _cursor = SystemMouseCursors.basic;

  Rect? get _currentMarquee {
    if (_isDraggingMarquee && _marqueeStart != null && _marqueeCurrent != null) {
      return Rect.fromPoints(_marqueeStart!, _marqueeCurrent!);
    }
    return null;
  }

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
            child: MouseRegion(
              cursor: _cursor,
              onHover: _handleHover,
              child: RepaintBoundary(
                child: DrawingCanvas(
                  paths: drawingState.paths,
                  currentPath: drawingState.currentPath,
                  currentToolType: drawingState.settings.toolType,
                  selectedPathIds: drawingState.selectedPathIds,
                  selectionMarquee: _currentMarquee,
                  isEnabled: isCanvasEnabled,
                  onDrawStart: _handleDrawStart,
                  onDrawUpdate: _handleDrawUpdate,
                  onDrawEnd: _handleDrawEnd,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleBackgroundTap(TapDownDetails details) {
    final drawingState = ref.read(drawingStateProvider);
    
    // Convert global position to local position
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final localPosition = renderBox.globalToLocal(details.globalPosition);
      
      bool hitHandleOrSelectedShape = false;
      if (drawingState.selectedPathIds.isNotEmpty) {
        if (_hitTestHandle(localPosition, drawingState) != null) {
          hitHandleOrSelectedShape = true;
        } else {
          for (final path in drawingState.paths) {
            if (drawingState.selectedPathIds.contains(path.id) && path.bounds.contains(localPosition)) {
               hitHandleOrSelectedShape = true;
               break;
            }
          }
        }
      }

      if (!hitHandleOrSelectedShape) {
        // Global Deselection on background tap only if we didn't hit the active object
        ref.read(drawingStateProvider.notifier).deselectPath();
      }
    }
    
    // Close panels when tapping background (not toolbar area)
    final toolbarRect = Rect.fromLTWH(100, 50, 400, 600);
    if (!toolbarRect.contains(details.globalPosition)) {
      ref.read(uiStateProvider.notifier).closeAllPanels();
    }
  }

  void _handleHover(PointerEvent event) {
    if (!ref.read(isSelectionModeProvider)) {
      if (_cursor != SystemMouseCursors.basic) {
        setState(() => _cursor = SystemMouseCursors.basic);
      }
      return;
    }

    final position = event.localPosition;
    final drawingState = ref.read(drawingStateProvider);
    
    // Check if hovering over a handle
    final handle = _hitTestHandle(position, drawingState);
    if (handle != null) {
      MouseCursor newCursor;
      switch (handle) {
        case ResizeHandle.topLeft:
        case ResizeHandle.bottomRight:
          newCursor = SystemMouseCursors.resizeUpLeftDownRight;
          break;
        case ResizeHandle.topRight:
        case ResizeHandle.bottomLeft:
          newCursor = SystemMouseCursors.resizeUpRightDownLeft;
          break;
        case ResizeHandle.topCenter:
        case ResizeHandle.bottomCenter:
          newCursor = SystemMouseCursors.resizeUpDown;
          break;
        case ResizeHandle.centerLeft:
        case ResizeHandle.centerRight:
          newCursor = SystemMouseCursors.resizeLeftRight;
          break;
      }
      if (_cursor != newCursor) {
        setState(() => _cursor = newCursor);
      }
      return;
    }
    
    // Check if hovering over ANY shape
    bool hoveredShape = false;
    for (int i = drawingState.paths.length - 1; i >= 0; i--) {
      if (drawingState.paths[i].bounds.contains(position)) {
        hoveredShape = true;
        break;
      }
    }
    
    if (hoveredShape) {
      if (_cursor != SystemMouseCursors.move) {
        setState(() => _cursor = SystemMouseCursors.move);
      }
    } else {
      if (_cursor != SystemMouseCursors.basic) {
        setState(() => _cursor = SystemMouseCursors.basic);
      }
    }
  }

  ResizeHandle? _hitTestHandle(Offset position, DrawingState state) {
    if (state.selectedPathIds.isEmpty) return null;
    
    final selectedPaths = state.paths.where((p) => state.selectedPathIds.contains(p.id) && p.points.isNotEmpty).toList();
    if (selectedPaths.isEmpty) return null;
    
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;
    
    for (final path in selectedPaths) {
      final b = path.bounds;
      if (b.left < minX) minX = b.left;
      if (b.top < minY) minY = b.top;
      if (b.right > maxX) maxX = b.right;
      if (b.bottom > maxY) maxY = b.bottom;
    }
    
    final bounds = Rect.fromLTRB(minX, minY, maxX, maxY);
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
        _isDraggingMarquee = false;
      } else {
        _activeResizeHandle = null;
        
        bool hitSelected = false;
        if (drawingState.selectedPathIds.isNotEmpty) {
          for (final path in drawingState.paths) {
            if (drawingState.selectedPathIds.contains(path.id) && path.bounds.contains(position)) {
              hitSelected = true;
              break;
            }
          }
        }
        
        if (hitSelected) {
          _isDraggingSelection = true;
          _isDraggingMarquee = false;
        } else {
          ref.read(drawingStateProvider.notifier).selectPathAt(position);
          final newState = ref.read(drawingStateProvider);
          if (newState.selectedPathIds.isNotEmpty) {
             _isDraggingSelection = true;
             _isDraggingMarquee = false;
          } else {
             _isDraggingSelection = false;
             setState(() {
               _isDraggingMarquee = true;
               _marqueeStart = position;
               _marqueeCurrent = position;
             });
          }
        }
      }
    } else {
      ref.read(drawingStateProvider.notifier).startPath(position);
    }
  }

  void _handleDrawUpdate(Offset position, Offset delta) {
    if (ref.read(isSelectionModeProvider)) {
      if (_isDraggingMarquee) {
        setState(() {
          _marqueeCurrent = position;
        });
        final marquee = _currentMarquee;
        if (marquee != null) {
          ref.read(drawingStateProvider.notifier).selectPathsInRect(marquee);
        }
      } else if (_isDraggingSelection) {
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
      if (_isDraggingMarquee) {
        setState(() {
          _isDraggingMarquee = false;
          _marqueeStart = null;
          _marqueeCurrent = null;
        });
      }
      _isDraggingSelection = false;
      _activeResizeHandle = null;
    } else {
      ref.read(drawingStateProvider.notifier).completePath();
      
      final drawingState = ref.read(drawingStateProvider);
      if (drawingState.settings.toolType.isShape) {
         if (drawingState.paths.isNotEmpty) {
           ref.read(drawingStateProvider.notifier).selectPathById(drawingState.paths.last.id);
         }
         ref.read(toolStateProvider.notifier).selectTool(ToolType.selection);
      }
    }
  }
}
