import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/canvas/models/canvas_element.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<CanvasElement>> streamElements(String boardId) {
    return _db
        .collection('boards')
        .doc(boardId)
        .collection('elements')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CanvasElement.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> addElement(String boardId, CanvasElement element) {
    return _db
        .collection('boards')
        .doc(boardId)
        .collection('elements')
        .add(element.toMap());
  }
}
