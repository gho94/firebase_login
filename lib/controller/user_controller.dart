import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/controller/todo_controller.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.value = _auth.currentUser;
    _auth.authStateChanges().listen((User? user) {
      this.user.value = user;
    });
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        "name": name,
        "email": email,
      });

      User? user = userCredential.user;
      await user?.updateDisplayName(name);
      await user?.reload();
      user = _auth.currentUser;

      Get.snackbar("Success", "회원가입이 완료되었습니다.");
    } on FirebaseAuthException catch (exception) {
      throw exception.message ?? "회원가입에 실패했습니다.";
    }
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user.value = userCredential.user;

      Get.find<TodoController>().loadTodo();
      Get.find<TodoController>().loadTodoTest();
    } on FirebaseAuthException catch (exception) {
      String errorMessage = "";
      if (exception.code == "user-not-found") {
        errorMessage = "해당 이메일로 가입된 계정이 없습니다.";
      } else if (exception.code == "wrong-password") {
        errorMessage = "비밀번호가 틀렸습니다.";
      } else {
        errorMessage = exception.message ?? "로그인에 실패했습니다.";
      }
      throw errorMessage;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    user.value = null;
    Get.snackbar("Success", "로그아웃이 완료되었습니다.");
  }
}
