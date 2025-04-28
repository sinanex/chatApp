import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zync/model/single_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );
  Future<User?> registerEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        users.add({'name': name, 'email': email, 'userid': result.user!.uid});
      }
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    }
  }

  Future<User?> loginEmail({
    required String email,
    required String password,
  }) async {
    try {
      log('logginn   .. $email $password');
      UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.trim(), password: password);

      return result.user;
    } on FirebaseAuthException catch (e) {
      log('Firebase Auth Error: ${e.code} - ${e.message}');

      switch (e.code) {
        case 'invalid-email':
          throw 'The email address is badly formatted.';
        case 'user-disabled':
          throw 'This account has been disabled.';
        case 'user-not-found':
          throw 'No account found with this email.';
        case 'wrong-password':
          throw 'Incorrect password. Please try again.';
        default:
          throw 'Login failed. Please try again later.';
      }
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<SingleUserModel?> getUserData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final response = await users.where('userid', isEqualTo: uid).get();

    if (response.docs.isNotEmpty) {
      final userData = response.docs.first.data() as Map<String, dynamic>;
      final docID = response.docs.first.id;
      log(docID);
      return SingleUserModel.fromMap(userData, docID);
    } else {
      return null;
    }
  }

  Future<void> editUserData(SingleUserModel user) async {
    log(user.id.toString());
    try {
      await users.doc(user.id).update(user.toMap());
    } on FirebaseException catch (e) {
      throw e.toString();
    }
  }
}
