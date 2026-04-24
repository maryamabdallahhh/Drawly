import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/drawing_path.dart';
import '../../domain/models/drawing_point.dart';
import '../../domain/models/drawing_settings.dart';
import '../../domain/models/drawing_tool_type.dart';
import '../../domain/models/resize_handle.dart';
import '../../../../core/utils/id_generator.dart';

/// Complete drawing state
class DrawingState {
  final List<DrawingPath> paths;
  final List<DrawingPoint>? currentPath;
  final DrawingSettings settings;
  final List<DrawingPath> redoStack;
  final List<Color> documentColors;
  final Set<String> selectedPathIds;

  const DrawingState({
    this.paths = const [],
    this.currentPath,
    required this.settings,
    this.redoStack = const [],
    this.documentColors = const [],
    this.selectedPathIds = const {},
  });

  DrawingState copyWith({
    List<DrawingPath>? paths,
    List<DrawingPoint>? Function()? currentPath,
    DrawingSettings? settings,
    List<DrawingPath>? redoStack,
    List<Color>? documentColors,
    Set<String>? selectedPathIds,
  }) {
    return DrawingState(
      paths: paths ?? this.paths,
      currentPath: currentPath != null ? currentPath() : this.currentPath,
      settings: settings ?? this.settings,
      redoStack: redoStack ?? this.redoStack,
      documentColors: documentColors ?? this.documentColors,
      selectedPathIds: selectedPathIds ?? this.selectedPathIds,
    );
  }

  bool get canUndo => paths.isNotEmpty;
  bool get canRedo => redoStack.isNotEmpty;
  bool get isDrawing => currentPath != null && currentPath!.isNotEmpty;
}

/// Drawing state notifier with business logic
class DrawingStateNotifier extends StateNotifier<DrawingState> {
  DrawingStateNotifier()
    : super(
        DrawingState(
          settings: DrawingSettings.forTool(DrawingToolType.pen),
          documentColors: const [
            Color(0xFF9C27B0),
            Colors.red,
            Color(0xFFFF9800),
          ],
        ),
      );

  /// Start a new drawing stroke
  void startPath(Offset position) {
    final paint = state.settings.toPaint();
    final point = DrawingPoint(position: position, paint: paint);
    state = state.copyWith(currentPath: () => [point]);
  }

  /// Add point to current path
  void addPoint(Offset position) {
    final current = state.currentPath;
    if (current == null || current.isEmpty) return;

    final point = DrawingPoint(position: position, paint: current.first.paint);
    
    if (state.settings.toolType.isShape) {
      // Shapes only need start and current end point (bounding box)
      state = state.copyWith(currentPath: () => [current.first, point]);
    } else {
      state = state.copyWith(currentPath: () => [...current, point]);
    }
  }

  /// Complete the current path
  void completePath() {
    final current = state.currentPath;
    if (current == null || current.isEmpty) return;

    final newPath = DrawingPath(
      id: IdGenerator.generateWithPrefix('path'),
      points: current,
      toolType: state.settings.toolType,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      paths: [...state.paths, newPath],
      currentPath: () => null,
      redoStack: [], // Clear redo stack on new action
    );
  }

  /// Cancel current path without saving
  void cancelPath() {
    state = state.copyWith(currentPath: () => null);
  }

  /// Update drawing settings
  void updateSettings(DrawingSettings settings) {
    state = state.copyWith(settings: settings);
  }

  /// Change tool type with default settings
  void changeToolType(DrawingToolType toolType) {
    state = state.copyWith(settings: DrawingSettings.forTool(toolType));
  }

  /// Update only color
  void updateColor(Color color) {
    state = state.copyWith(settings: state.settings.copyWith(color: color));
  }

  /// Update only stroke width
  void updateStrokeWidth(double width) {
    state = state.copyWith(
      settings: state.settings.copyWith(strokeWidth: width),
    );
  }

  /// Update only opacity
  void updateOpacity(double opacity) {
    state = state.copyWith(settings: state.settings.copyWith(opacity: opacity));
  }

  /// Undo last path
  void undo() {
    if (!state.canUndo) return;

    final lastPath = state.paths.last;
    state = state.copyWith(
      paths: state.paths.sublist(0, state.paths.length - 1),
      redoStack: [...state.redoStack, lastPath],
    );
  }

  /// Redo last undone path
  void redo() {
    if (!state.canRedo) return;

    final redoPath = state.redoStack.last;
    state = state.copyWith(
      paths: [...state.paths, redoPath],
      redoStack: state.redoStack.sublist(0, state.redoStack.length - 1),
    );
  }

  /// Clear all paths
  void clear() {
    state = state.copyWith(paths: [], currentPath: () => null, redoStack: []);
  }

  /// Add custom color to document palette
  void addDocumentColor(Color color) {
    if (state.documentColors.contains(color)) return;
    state = state.copyWith(documentColors: [...state.documentColors, color]);
  }

  /// Remove document color
  void removeDocumentColor(Color color) {
    state = state.copyWith(
      documentColors: state.documentColors
          .where((c) => c.toARGB32() != color.toARGB32())
          .toList(),
    );
  }

  /// Select a path at given position (for Selection Tool)
  void selectPathAt(Offset position) {
    // Reverse order so top-most paths are checked first
    for (int i = state.paths.length - 1; i >= 0; i--) {
      final path = state.paths[i];
      // Check if point is inside bounds.
      if (path.bounds.contains(position)) {
        state = state.copyWith(selectedPathIds: {path.id});
        return;
      }
    }
    // Clicked on empty space -> deselect
    state = state.copyWith(selectedPathIds: {});
  }

  void selectPathById(String id) {
    state = state.copyWith(selectedPathIds: {id});
  }

  void deselectPath() {
    state = state.copyWith(selectedPathIds: {});
  }
  
  void selectPathsInRect(Rect marquee) {
    final selectedIds = <String>{};
    for (final path in state.paths) {
      if (path.bounds.overlaps(marquee)) {
        selectedIds.add(path.id);
      }
    }
    state = state.copyWith(selectedPathIds: selectedIds);
  }

  void moveSelectedPath(Offset delta) {
    if (state.selectedPathIds.isEmpty) return;
    
    final newPaths = List<DrawingPath>.from(state.paths);
    
    for (int i = 0; i < newPaths.length; i++) {
      final path = newPaths[i];
      if (state.selectedPathIds.contains(path.id)) {
        final updatedPoints = path.points.map((point) {
          return DrawingPoint(
            position: point.position + delta,
            paint: point.paint,
          );
        }).toList();
        newPaths[i] = path.copyWith(points: updatedPoints);
      }
    }
    
    state = state.copyWith(paths: newPaths);
  }

  void resizeSelectedPath(Offset delta, ResizeHandle handle) {
    if (state.selectedPathIds.isEmpty) return;
    
    // Get unified bounds
    final selectedPaths = state.paths.where((p) => state.selectedPathIds.contains(p.id) && p.points.isNotEmpty).toList();
    if (selectedPaths.isEmpty) return;
    
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;
    
    for (final path in selectedPaths) {
      final bounds = path.bounds;
      if (bounds.left < minX) minX = bounds.left;
      if (bounds.top < minY) minY = bounds.top;
      if (bounds.right > maxX) maxX = bounds.right;
      if (bounds.bottom > maxY) maxY = bounds.bottom;
    }
    
    final bounds = Rect.fromLTRB(minX, minY, maxX, maxY);
    
    // Calculate new bounds based on drag
    double newLeft = bounds.left;
    double newTop = bounds.top;
    double newRight = bounds.right;
    double newBottom = bounds.bottom;
    
    switch (handle) {
      case ResizeHandle.topLeft:
        newLeft += delta.dx;
        newTop += delta.dy;
        break;
      case ResizeHandle.topCenter:
        newTop += delta.dy;
        break;
      case ResizeHandle.topRight:
        newRight += delta.dx;
        newTop += delta.dy;
        break;
      case ResizeHandle.centerLeft:
        newLeft += delta.dx;
        break;
      case ResizeHandle.centerRight:
        newRight += delta.dx;
        break;
      case ResizeHandle.bottomLeft:
        newLeft += delta.dx;
        newBottom += delta.dy;
        break;
      case ResizeHandle.bottomCenter:
        newBottom += delta.dy;
        break;
      case ResizeHandle.bottomRight:
        newRight += delta.dx;
        newBottom += delta.dy;
        break;
    }
    
    // Prevent invalid/inverted bounds
    if (newRight <= newLeft + 10) {
      if (handle == ResizeHandle.topLeft || handle == ResizeHandle.centerLeft || handle == ResizeHandle.bottomLeft) {
        newLeft = bounds.left;
      } else {
        newRight = bounds.right;
      }
    }
    
    if (newBottom <= newTop + 10) {
      if (handle == ResizeHandle.topLeft || handle == ResizeHandle.topCenter || handle == ResizeHandle.topRight) {
        newTop = bounds.top;
      } else {
        newBottom = bounds.bottom;
      }
    }
    
    final newBounds = Rect.fromLTRB(newLeft, newTop, newRight, newBottom);
    
    final scaleX = bounds.width == 0 ? 1 : newBounds.width / bounds.width;
    final scaleY = bounds.height == 0 ? 1 : newBounds.height / bounds.height;
    
    final newPaths = List<DrawingPath>.from(state.paths);
    
    for (int i = 0; i < newPaths.length; i++) {
      final path = newPaths[i];
      if (state.selectedPathIds.contains(path.id) && path.points.isNotEmpty) {
        final updatedPoints = path.points.map((point) {
          final relX = point.position.dx - bounds.left;
          final relY = point.position.dy - bounds.top;
          
          return DrawingPoint(
            position: Offset(newBounds.left + relX * scaleX, newBounds.top + relY * scaleY),
            paint: point.paint,
          );
        }).toList();
        newPaths[i] = path.copyWith(points: updatedPoints);
      }
    }
    
    state = state.copyWith(paths: newPaths);
  }
}

final drawingStateProvider =
    StateNotifierProvider<DrawingStateNotifier, DrawingState>((ref) {
      return DrawingStateNotifier();
    });
