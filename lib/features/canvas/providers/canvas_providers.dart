import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/canvas_element.dart';
import '../../../core/services/firestore_service.dart';

// Provides the Service instance
final firestoreServiceProvider = Provider((ref) => FirestoreService());

final boardElementsProvider =
    StreamProvider.family<List<CanvasElement>, String>((ref, boardId) {
      final service = ref.watch(firestoreServiceProvider);
      return service.streamElements(boardId);
    });

final hoverStateProvider = StateProvider.family<bool, String>(
  (ref, toolId) => false,
);

// Provider for the selected tool (default is 'selection-tool')
final selectedToolProvider = StateProvider<String>(
  (ref) => 'assets/icons/selection.png',
);
