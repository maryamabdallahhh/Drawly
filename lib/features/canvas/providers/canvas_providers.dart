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
