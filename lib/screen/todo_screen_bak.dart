// import 'package:firebase_login/controller/todo_controller_bak.dart';
// import 'package:firebase_login/model/todo_bak.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class TodoScreen extends StatelessWidget {
//   const TodoScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final TodoControllerBak todoController = Get.find<TodoControllerBak>();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("TodoList"),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () => _showInputForm(context),
//             icon: const Icon(Icons.add),
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Obx(() {
//               return ListView.builder(
//                 itemCount: todoController.todoList.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   final todo = todoController.todoList[index];
//                   return ListTile(
//                     leading: Checkbox(
//                       value: todo.isCompleted,
//                       onChanged: (value) {
//                         final updateTodo = todo.copyWith(isCompleted: value);
//                         todoController.updateTodo(index, updateTodo);
//                       },
//                     ),
//                     title: Text(todo.title),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.edit),
//                           onPressed: () => _showInputForm(context, todo),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.delete),
//                           onPressed: () => todoController.deleteTodo(todo.id!),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showInputForm(BuildContext context, [TodoBak? todo]) {
//     final TodoControllerBak todoController = Get.find<TodoControllerBak>();
//     final todoTextEditingController = TextEditingController(text: todo?.title);

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(todo == null ? "Todo 추가" : "Todo 수정"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: todoTextEditingController,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('취소'),
//             ),
//             TextButton(
//               onPressed: () {
//                 final title = todoTextEditingController.text;

//                 if (todo == null) {
//                   final newTodo = TodoBak(
//                     id: DateTime.now().millisecondsSinceEpoch,
//                     title: title,
//                     isCompleted: false,
//                     creator: "User",
//                     createdAt: DateTime.now(),
//                   );
//                   todoController.addTodo(newTodo);
//                 } else {
//                   final updatedTodo = todo.copyWith(
//                     title: title,
//                     modifier: "User",
//                     modifiedAt: DateTime.now(),
//                   );
//                   todoController.updateTodo(todo.id!, updatedTodo);
//                 }
//                 Navigator.pop(context);
//               },
//               child: Text(todo == null ? "저장" : "수정"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
