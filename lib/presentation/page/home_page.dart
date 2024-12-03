import 'package:app_money_record/config/session.dart';
import 'package:app_money_record/presentation/page/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            const Text('Home Page'),
            IconButton(onPressed: () {
              Session.delete();
              Get.off(() => const LoginPage());
            }, icon: const Icon(Icons.logout))
          ],
        ),
      ),
    );
  }
}