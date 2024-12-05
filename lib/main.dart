import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_login/screen/home_screen.dart';
import 'package:firebase_login/screen/login_screen.dart';
import 'package:firebase_login/screen/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Login Example",
      initialRoute: "/login",
      getPages: [
        GetPage(name: "/login", page: () => const LoginScreen()),
        GetPage(name: "/signUp", page: () => const SignUpScreen()),
        GetPage(name: "/home", page: () => const HomeScreen()),
      ],
    );
  }
}
