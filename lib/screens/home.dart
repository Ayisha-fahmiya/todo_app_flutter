import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/screens/login_page.dart';
import 'package:todo_app/services/todo_services.dart';
import 'package:todo_app/widgets/to_do_items.dart';
import '../services/auth_services.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // FirebaseFirestore db = FirebaseFirestore.instance;
  final ToDoService toDoService = ToDoService();

  // final todosList = ToDo.todoList();
  final _todoController = TextEditingController();

  AuthServices authServices = AuthServices();

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      return e.message;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          key: _key,
          resizeToAvoidBottomInset: false,
          backgroundColor: tdBGColor,
          appBar: _buldAppBar(),
          drawer: Drawer(
            child: Column(
              children: [
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () async {
                    await pickImage();
                  },
                  child: image == null
                      ? const CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              AssetImage("assets/accountProfile.png"),
                        )
                      : CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.white,
                          backgroundImage: FileImage(image!),
                        ),
                ),
                const SizedBox(height: 24),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: Colors.grey[200],
                  height: 60,
                  child: ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text("Log out"),
                    onTap: () async {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Logout"),
                            content:
                                const Text("Are you sure you want to logout?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await authServices.signOut();
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                      (route) => false);
                                },
                                child: const Text(
                                  "Logout",
                                  style: TextStyle(
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
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
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.black),
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
          body: ListView(
            children: [
              SizedBox(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await pickImage();
                      },
                      child: image == null
                          ? const CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  AssetImage("assets/accountProfile.png"),
                            )
                          : CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.white,
                              backgroundImage: FileImage(image!),
                            ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Ayisha Fahmiya",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
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
      leading: IconButton(
        onPressed: () {
          _key.currentState?.openDrawer();
        },
        icon: const Icon(
          Icons.menu,
          color: Colors.black,
        ),
      ),
    );
  }
}
