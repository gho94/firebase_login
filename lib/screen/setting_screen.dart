import 'package:firebase_login/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              userController.logout();
              Get.toNamed("/login");
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Obx(() {
            final user = userController.user.value;
            if (user == null) {
              return const Text("로그인된 사용자가 없습니다.");
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text("name"),
                      ),
                      Text(user.displayName ?? "이름이 없습니다.")
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text("email"),
                      ),
                      Text(user.email ?? "이메일이 없습니다.")
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}