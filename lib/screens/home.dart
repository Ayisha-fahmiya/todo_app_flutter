import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/services/todo_services.dart';
import 'package:todo_app/widgets/to_do_items.dart';

class Home extends StatelessWidget {
  Home({super.key});

  // FirebaseFirestore db = FirebaseFirestore.instance;
  final ToDoService toDoService = ToDoService();

  // final todosList = ToDo.todoList();

  final _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // db.collection("todo").snapshots().listen((snapshot) {});
    // final CollectionReference _todosRef =
    //     FirebaseFirestore.instance.collection('todo');

    return StreamBuilder<QuerySnapshot>(
      stream: toDoService.todoStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var docs = snapshot.data?.docs ?? [];
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: tdBGColor,
          appBar: _buldAppBar(),
          body: Column(
            children: [
              Container(
                height: 200,
                color: Colors.grey[100],
              ),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    height: 500,
                    child: ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, i) {
                        // DocumentReference docRef = _todosRef.doc(docs[i].id);
                        Map<String, dynamic> data =
                            docs[i].data() as Map<String, dynamic>;
                        return ToDoItem(
                          onDeleteItem: (value) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => AlertDialog(
                                title: const Text('Are you sure?'),
                                content: const Text(
                                    'Do you want to delete this todo'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // docRef.delete();
                                      toDoService.deleteTodo(docs[i].id);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                          onToDoChanged: (isDone) {
                            // docRef.update({'isDone': isDone});
                            toDoService.updateTodo(docs[i].id, isDone!);
                          },
                          todo: ToDo(
                            id: '1',
                            title: data['title'],
                            isDone: data['isDone'],
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    right: 24,
                    child: FloatingActionButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            height: 240,
                            // color: Colors.black,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 70,
                                  width: 300,
                                  child: TextField(
                                    controller: _todoController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    String title = _todoController.text;
                                    toDoService.addTodo(title);
                                    // _todosRef.add({
                                    //   'title': title,
                                    //   'isDone': false,
                                    // });

                                    Navigator.of(context).pop();
                                    _todoController.clear();
                                  },
                                  child: const Text('Submit'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: const Icon(Icons.add, size: 36),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // void _runFilter(String enteredKeyword) {
  AppBar _buldAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      leading: Icon(
        Icons.menu,
        color: tdBlack,
        size: 30,
      ),
      actions: const [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: CircleAvatar(
            backgroundImage: AssetImage(
              'assets/WhatsApp Image 2022-11-10 at 4.56.23 PM.jpeg',
            ),
          ),
        ),
      ],
    );
  }
}
