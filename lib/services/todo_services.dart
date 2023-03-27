import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoService {
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('todo');

  Stream<QuerySnapshot> get todoStream => collectionReference.snapshots();

  Future<DocumentReference> addTodo(String title) {
    return collectionReference.add({'title': title, 'isDone': false});
  }

  Future<void> updateTodo(String id, bool isDone) {
    return collectionReference.doc(id).update({'isDone': isDone});
  }

  Future<void> deleteTodo(String id) {
    return collectionReference.doc(id).delete();
  }
}
