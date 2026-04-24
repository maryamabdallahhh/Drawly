import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/drawing_path.dart';
import '../../domain/models/drawing_point.dart';
import '../../domain/models/drawing_settings.dart';
import '../../domain/models/drawing_tool_type.dart';
import '../../../../core/utils/id_generator.dart';

/// Complete drawing state
class DrawingState {
  final List<DrawingPath> paths;
  final List<DrawingPoint>? currentPath;
  final DrawingSettings settings;
  final List<DrawingPath> redoStack;
  final List<Color> documentColors;

  const DrawingState({
    this.paths = const [],
    this.currentPath,
    required this.settings,
    this.redoStack = const [],
    this.documentColors = const [],
  });

  DrawingState copyWith({
    List<DrawingPath>? paths,
    List<DrawingPoint>? Function()? currentPath,
    DrawingSettings? settings,
    List<DrawingPath>? redoStack,
    List<Color>? documentColors,
  }) {
    return DrawingState(
      paths: paths ?? this.paths,
      currentPath: currentPath != null ? currentPath() : this.currentPath,
      settings: settings ?? this.settings,
      redoStack: redoStack ?? this.redoStack,
      documentColors: documentColors ?? this.documentColors,
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
    state = state.copyWith(currentPath: () => [...current, point]);
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
}

final drawingStateProvider =
    StateNotifierProvider<DrawingStateNotifier, DrawingState>((ref) {
      return DrawingStateNotifier();
    });
