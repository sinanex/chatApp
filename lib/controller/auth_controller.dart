import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zync/model/single_user.dart';
import 'package:zync/services/auth_services.dart';
import 'package:zync/view/home_screen.dart';

class AuthController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  SingleUserModel? userModel;

  AuthService authService = AuthService();
  Future<String?> registerUser() async {
    try {
      await authService
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
      Get.offAll(() => HomeScreen());
    } catch (e) {
      Get.snackbar('login', e.toString());
    }
    return null;
  }

  void loginUser() async {
    try {
      await authService.loginEmail(
        email: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.offAll(() => HomeScreen());
    } catch (e) {
      Get.snackbar('login', e.toString());
    }
  }
}
