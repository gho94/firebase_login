import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/model/todo.dart';
import 'package:firebase_login/model/todo_test.dart';
import 'package:get/get.dart';

class TodoController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<Todo> todos = <Todo>[].obs;
  RxList<TodoTest> todoTests = <TodoTest>[].obs;
  RxList<String> comment = <String>[].obs;

  void loadTodo() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final docSnapshot = await _firestore.collection('todos').doc(userId).get();
    if (!docSnapshot.exists || docSnapshot.data() == null) return;

    todos.clear();
    docSnapshot.data()!.forEach((key, value) {
      todos.add(Todo.fromMap(value));
    });
  }

  void loadTodoTest() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final querySnapshot = await _firestore.collection('todosTest').doc(userId).collection("todo").get();

    if (querySnapshot.docs.isEmpty) return;

    todoTests.clear();
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
      todoTests.add(TodoTest.fromMap(doc.data(), doc.id));
    }
  }

  void loadTodoCommentTest(String id) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final querySnapshot = await _firestore.collection('todosTest').doc(userId).collection("todo").doc(id).collection("comment").get();

    if (querySnapshot.docs.isEmpty) return;

    comment.clear();
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
      comment.add(doc.data()["comment"]);
    }
  }

  void addTodoCommentTest(String id, String comment) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await _firestore.collection("todosTest").doc(userId).collection("todo").doc(id).collection("comment").add({"comment": comment});

    loadTodoCommentTest(id);
  }

  void addTodo(Todo todo) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final docSnapshot = await _firestore.collection("todos").doc(userId).get();
    final existingData = docSnapshot.exists ? docSnapshot.data()! : {};

    int nextTodoNumber = 0;
    if (existingData.isNotEmpty) {
      final todoNumbers = existingData.keys.map((key) {
        final numberStr = key.replaceAll(RegExp(r'[^0-9]'), '');
        return int.tryParse(numberStr) ?? 0;
      }).toList();
      nextTodoNumber = todoNumbers.isNotEmpty ? todoNumbers.reduce((a, b) => a > b ? a : b) + 1 : 0;
    }

    final todoId = "Todo$nextTodoNumber";
    final todoMap = todo.copyWith(id: todoId).toMap();

    await _firestore.collection("todos").doc(userId).set({
      todoId: todoMap,
    }, SetOptions(merge: true));

    loadTodo();
  }

  void addTodoTest(TodoTest todoTest) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await _firestore.collection("todosTest").doc(userId).collection("todo").add(todoTest.toMap());
  }

  void updateTodo(String id, Todo todo) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await _firestore.collection("todos").doc(userId).update({
      id: todo.toMap(),
    });

    loadTodo();
  }

  void updateTodoTest(String id, TodoTest todoTest) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await _firestore.collection("todosTest").doc(userId).collection("todo").doc(id).update(todoTest.toMap());

    loadTodoTest();
  }

  void deleteTodo(String id) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await _firestore.collection("todos").doc(userId).update({
      id: FieldValue.delete(),
    });

    loadTodo();
  }

  void deleteTodoTest(String id) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await _firestore.collection("todosTest").doc(userId).collection("todo").doc(id).delete();

    loadTodoTest();
  }
}
