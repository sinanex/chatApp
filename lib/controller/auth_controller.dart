import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:zync/services/auth_services.dart';

class AuthController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  AuthService authService = AuthService();
  Future<String?> registerUser() async {
    try {
      authService
          .registerEmail(
            name: nameController.text.trim(),
            email: usernameController.text.trim(),
            password: passwordController.text.trim(),
          )
          .then((user) {
            if (user != null) {
              return 'login success';
            }
          });
    } on FirebaseException catch (e) {
      log(e.toString());
    }
  }

  void loginUser() async {
    try {
      authService.loginEmail(
        email: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseException catch (e) {
      log(e.toString());
    }
  }
}
