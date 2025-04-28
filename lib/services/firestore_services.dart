import 'dart:io';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zync/model/messages.dart'; // Important import for CombineLatestStream

class FirestoreService {
  final CollectionReference messages = FirebaseFirestore.instance.collection(
    'messages',
  );
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );
  final firebaseAuth = FirebaseAuth.instance.currentUser?.uid;

  Stream<List<QueryDocumentSnapshot>> getMessages(String uid) {
    final myId = FirebaseAuth.instance.currentUser?.uid;

    var senderToReceiver =
        messages
            .where('senderId', isEqualTo: myId)
            .where('receiverId', isEqualTo: uid)
            .snapshots();

    var receiverToSender =
        messages
            .where('senderId', isEqualTo: uid)
            .where('receiverId', isEqualTo: myId)
            .snapshots();

    return CombineLatestStream.combine2(senderToReceiver, receiverToSender, (
      QuerySnapshot a,
      QuerySnapshot b,
    ) {
      final allDocs = [...a.docs, ...b.docs];
      return allDocs;
    });
  }

  Future<void> sendMessage(Messages message) async {
    await messages.add(message.toJson());
  }

  Stream<QuerySnapshot> getUsers() {
    return users.snapshots();
  }

  Future<String?> uploadImageToFirebase(XFile imageFile) async {
    log('Uploading image...');
    try {
      final File file = File(imageFile.path);
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference storageRef = FirebaseStorage.instance.ref().child(
        'images/$fileName',
      );
      final UploadTask uploadTask = storageRef.putFile(file);

      final TaskSnapshot snapshot = await uploadTask;

      final String downloadUrl = await snapshot.ref.getDownloadURL();

      log('Upload successful: $downloadUrl');
      return downloadUrl;
    } on FirebaseException catch (e) {
      log('Error uploading image: $e');
      return null;
    }
  }
}
