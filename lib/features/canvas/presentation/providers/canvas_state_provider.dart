import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tool_state_provider.dart';
import 'drawing_state_provider.dart';
import '../../domain/models/tool_type.dart';
import '../../domain/models/sub_tool_config.dart';
import '../../domain/models/drawing_settings.dart';
import '../../../../core/services/firestore_service.dart';
import '../../domain/models/canvas_element.dart';

// Firestore service
final firestoreServiceProvider = Provider((ref) => FirestoreService());

// Canvas elements stream
final boardElementsProvider =
    StreamProvider.family<List<CanvasElement>, String>((ref, boardId) {
      final service = ref.watch(firestoreServiceProvider);
      return service.streamElements(boardId);
    });

// Currently selected tool
final currentToolProvider = Provider<ToolType>((ref) {
  return ref.watch(toolStateProvider).selectedTool;
});

// Currently selected subtool
final currentSubToolProvider = Provider<SubToolConfig?>((ref) {
  return ref.watch(toolStateProvider).selectedSubTool;
});

// Current drawing settings
final currentDrawingSettingsProvider = Provider<DrawingSettings>((ref) {
  return ref.watch(drawingStateProvider).settings;
});

// Is currently in drawing mode
final isDrawingModeProvider = Provider<bool>((ref) {
  final subTool = ref.watch(currentSubToolProvider);
  if (subTool == null) return false;

  const drawingTools = ['Pen', 'Marker', 'Highlighter', 'Eraser'];
  return drawingTools.contains(subTool.label);
});

// Can undo/redo
final canUndoProvider = Provider<bool>((ref) {
  return ref.watch(drawingStateProvider).canUndo;
});

final canRedoProvider = Provider<bool>((ref) {
  return ref.watch(drawingStateProvider).canRedo;
});
