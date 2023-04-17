import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/model/todo.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoChanged;
  final onDeleteItem;

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          onToDoChanged(todo.isDone ? false : true);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        tileColor: Colors.white,
        leading: Icon(
          todo.isDone ? Icons.check_box_rounded : Icons.check_box_outline_blank,
          color: tdBlue,
        ),
        title: Text(
          todo.title!,
          style: TextStyle(
            fontSize: 16,
            color: tdBlack,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: TextButton(
                  child: const Text("Delete"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onDeleteItem(todo.id);
                  },
                ),
              ),
            ];
          },
        ),
        // trailing: Container(
        //   padding: const EdgeInsets.all(0),
        //   margin: const EdgeInsets.symmetric(vertical: 12),
        //   height: 35,
        //   width: 35,
        //   decoration: BoxDecoration(
        //     color: tdRed,
        //     borderRadius: BorderRadius.circular(5),
        //   ),
        //   child: IconButton(
        //     onPressed: () {
        //       onDeleteItem(todo.id);
        //     },
        //     icon: const Icon(
        //       Icons.delete,
        //     ),
        //     color: Colors.white,
        //     iconSize: 18,
        //   ),
        // ),
      ),
    );
  }
}
