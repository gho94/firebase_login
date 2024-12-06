import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.value = FirebaseAuth.instance.currentUser;

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      this.user.value = user;
    });
  }

  Future<void> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
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

  Future<void> signUp(String email, String password, String name) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      await user?.updateDisplayName(name);
      await user?.reload();
      user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        "name": name,
        "email": email,
      });

      Get.snackbar("Success", "회원가입이 완료되었습니다.");
    } on FirebaseAuthException catch (exception) {
      throw exception.message ?? "회원가입에 실패했습니다.";
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
