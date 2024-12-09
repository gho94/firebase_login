import 'package:firebase_login/controller/todo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommetScreen extends StatelessWidget {
  const CommetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String id = Get.arguments;
    final TodoController todoController = Get.find<TodoController>();
    todoController.loadTodoCommentTest(id);
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(id),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: todoController.comment.length,
                  itemBuilder: (BuildContext context, int index) {
                    final comment = todoController.comment[index];
                    return ListTile(
                      title: Text(comment),
                    );
                  },
                );
              }),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () => todoController.addTodoCommentTest(id, controller.text),
                    icon: const Icon(Icons.add),
                  ),
                  border: const OutlineInputBorder(),
                  hintText: "comment",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
