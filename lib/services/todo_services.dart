import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoService {
  // final String? uid;
  // ToDoService({this.uid});
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

  // Future gettingUserData(String email) async {
  //   QuerySnapshot snapshot =
  //       await collectionReference.where("email", isEqualTo: email).get();
  //   return snapshot;
  // }
}
