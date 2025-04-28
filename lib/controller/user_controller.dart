import 'dart:developer';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:zync/model/single_user.dart';
import 'package:zync/services/auth_services.dart';

class UserDataController extends GetxController {
  Rx<SingleUserModel?> singleUserModel = Rx<SingleUserModel?>(null);

  AuthService service = AuthService();

  @override
  void onInit() {
    super.onInit();
    log('calling userdata........................cc');
    getUserData();
  }

  void getUserData() async {
    try {
      singleUserModel.value = await service.getUserData();
    } catch (e) {
      log('Error fetching user data: $e');
    }
  }
}
