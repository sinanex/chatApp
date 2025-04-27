import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      allDocs.sort(
        (a, b) => (a['time'] as Timestamp).compareTo(b['time'] as Timestamp),
      );
      return allDocs;
    });
  }

  Future<void> sendMessage(Messages message) async {
    await messages.add(message.toJson());
  }

  Stream<QuerySnapshot> getUsers() {
    return users.snapshots();
  }
}
