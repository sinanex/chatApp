import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zync/model/model.dart';
import 'package:zync/services/firestore_services.dart';

class UserController extends GetxController {
  var usersList = <UserModel>[].obs;

  FirestoreService _firestoreService = FirestoreService();
  StreamSubscription<QuerySnapshot>? _userSubscription;

  @override
  void onInit() {
    super.onInit();
    _listenToUsers();
  }

  void _listenToUsers() {
    _userSubscription = _firestoreService.getUsers().listen((snapshot) {
      usersList.value =
          snapshot.docs.map((doc) {
            return UserModel.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();
        for(var user in usersList){
   log(user.uid);
        }
    });
  }

  @override
  void onClose() {
    _userSubscription?.cancel();
    super.onClose();
  }
}
