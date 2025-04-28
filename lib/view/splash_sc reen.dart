import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zync/view/home_screen.dart';
import 'package:zync/view/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Zync",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
    );
  }

  void _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2)); // optional delay for splash effect

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
            log('user get $user');
      Get.offAll(() => HomeScreen());
    } else {
      log('user null $user');
      Get.offAll(() => LoginScreen());
    }
  }
}
