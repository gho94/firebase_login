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
  final _nameController = TextEditingController();

  bool _isLoading = false;
  bool _showPassword = true;

  Future<void> registerUser() async {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      Get.snackbar("Error", "유효한 이메일을 입력하세요.");
      return;
    }

    if (_passwordController.text.length < 6) {
      Get.snackbar("Error", "비밀번호는 최소 6자 이상이어야 합니다.");
      return;
    }

    if (_nameController.text.isEmpty) {
      Get.snackbar("Error", "이름을 입력해주세요.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      User? user = userCredential.user;
      await user?.updateDisplayName(_nameController.text);
      await user?.reload();
      user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        "name": _nameController.text,
        "email": _emailController.text,
      });

      Get.snackbar("Success", "회원가입이 완료되었습니다.");

      await Future.delayed(const Duration(seconds: 1));

      Get.toNamed("/login");
    } on FirebaseAuthException catch (exception) {
      Get.snackbar("Error", exception.code);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SignUp"),
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
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.account_circle),
                        border: OutlineInputBorder(),
                        hintText: "name",
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 48,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
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
