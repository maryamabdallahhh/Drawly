import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/canvas/domain/models/canvas_element.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<CanvasElement>> streamElements(String boardId) {
    return _firestore
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

  Future<void> addElement(String boardId, CanvasElement element) async {
    await _firestore
        .collection('boards')
        .doc(boardId)
        .collection('elements')
        .doc(element.id)
        .set(element.toMap());
  }

  Future<void> updateElement(String boardId, CanvasElement element) async {
    await _firestore
        .collection('boards')
        .doc(boardId)
        .collection('elements')
        .doc(element.id)
        .update(element.toMap());
  }

  Future<void> deleteElement(String boardId, String elementId) async {
    await _firestore
        .collection('boards')
        .doc(boardId)
        .collection('elements')
        .doc(elementId)
        .delete();
  }
}
