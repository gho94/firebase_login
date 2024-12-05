import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static final instance = UserService();
  UserCredential? userCredential;

  Future<bool> loginUser(String email, String password) async {
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (exception) {
      throw Exception(exception);
    }
  }
}
