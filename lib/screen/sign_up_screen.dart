import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _showPassword = true;

  Future<void> registerUser() async {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      // Invalid email
      Get.snackbar("Error", "유효한 이메일을 입력하세요.");
      return;
    }

    if (_passwordController.text.length < 6) {
      // Password too short
      Get.snackbar("Error", "비밀번호는 최소 6자 이상이어야 합니다.");
      return;
    }

    setState(() {
      _isLoading = true; // Show loading
    });

    try {
      // Firebase Auth를 사용하여 사용자 등록
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Firestore에 사용자 정보 저장
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        //'name': _nameController.text,
        'email': _emailController.text,
        // 'profileimage':
        //     _defaultProfileImageUrl, // Firebase Storage의 기본 프로필 이미지 URL 저장
      });

      // 스낵바 표시
      Get.snackbar("Success", "회원가입이 완료되었습니다.");

      // 1초 후 로그인 페이지로 이동
      await Future.delayed(const Duration(seconds: 1));

      // 회원가입 후 로그인 페이지로 이동
      Get.toNamed("/login");
    } on FirebaseAuthException catch (exception) {
      // Error handling
      //Get.snackbar("Error", "회원가입에 실패했습니다.");
      Get.snackbar("Error", exception.code);
    } finally {
      setState(() {
        _isLoading = false; // Hide loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SignUP"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.people_alt),
                        border: OutlineInputBorder(),
                        hintText: "Email",
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          icon: _showPassword ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                        ),
                        border: const OutlineInputBorder(),
                        hintText: "Password",
                      ),
                      obscureText: _showPassword,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          //가입
                          registerUser();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff8A2BE2)),
                        child: const Text('회원가입', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
