import 'package:firebase_login/controller/todo_controller.dart';
import 'package:firebase_login/model/todo.dart';
import 'package:firebase_login/model/todo_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoController todoController = Get.find<TodoController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("TodoList"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _showInputForm(context),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: todoController.todos.length,
                itemBuilder: (BuildContext context, int index) {
                  final todo = todoController.todos[index];
                  return ListTile(
                    leading: Checkbox(
                      value: todo.isCompleted,
                      onChanged: (value) {
                        final updateTodo = todo.copyWith(isCompleted: value);
                        todoController.updateTodo(todo.id!, updateTodo);
                      },
                    ),
                    title: Text(todo.title),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => todoController.deleteTodo(todo.id!),
                    ),
                  );
                },
              );
            }),
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: todoController.todoTests.length,
                itemBuilder: (BuildContext context, int index) {
                  final todo = todoController.todoTests[index];
                  return GestureDetector(
                    child: ListTile(
                      leading: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (value) {
                          final updateTodo = todo.copyWith(isCompleted: value);
                          todoController.updateTodoTest(todo.id, updateTodo);
                        },
                      ),
                      title: Text(todo.title),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => todoController.deleteTodoTest(todo.id),
                      ),
                    ),
                    onTap: () {
                      Get.toNamed("/comment", arguments: todo.id);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showInputForm(BuildContext context) {
    final TodoController todoController = Get.find<TodoController>();
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Todo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                final todo = Todo(
                  title: titleController.text,
                  isCompleted: false,
                );
                final todoTest = TodoTest(
                  id: "",
                  title: titleController.text,
                  isCompleted: false,
                );
                todoController.addTodo(todo);
                todoController.addTodoTest(todoTest);
                Navigator.pop(context);
              },
              child: const Text("저장"),
            ),
          ],
        );
      },
    );
  }
}
