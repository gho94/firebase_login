import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Login", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "ID",
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password",
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 48,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    Get.toNamed("/home");
                  } on FirebaseAuthException catch (exception) {
                    String errorMessage = '';
                    if (exception.code == 'user-not-found') {
                      errorMessage = '해당 이메일로 가입된 계정이 없습니다.';
                    } else if (exception.code == 'wrong-password') {
                      errorMessage = '비밀번호가 틀렸습니다.';
                    } else {
                      errorMessage = exception.message ?? '로그인에 실패했습니다.';
                    }
                    Get.snackbar("Error", errorMessage);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff8A2BE2)),
                child: const Text('Login', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 48,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () => Get.toNamed("/signUp"),
                child: const Text('Sign Up', style: TextStyle(color: Color(0xff8A2BE2))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
