import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:zync/model/messages.dart';
import 'package:zync/services/firestore_services.dart';

class Controller extends GetxController {
  var messageList = <Messages>[].obs;
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription<List<QueryDocumentSnapshot>>? _chatSubscription;

  final String uid;

  Controller(this.uid);

  @override
  void onInit() {
    log('Controller initialized and listening to messages...');
    super.onInit();
    _listenMessages(uid);
  }

  void _listenMessages(String uid) {
    _chatSubscription?.cancel();
    
    _chatSubscription = _firestoreService.getMessages(uid).listen(
      (List<QueryDocumentSnapshot> docs) {
        try {
          final messages = docs
              .where((doc) => doc.exists && doc.data() != null)
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                data['id'] = doc.id;
                return Messages.fromJson(data);
              })
              .toList();

          messages.sort((a, b) => a.time!.compareTo(b.time!));
          
          messageList.value = messages;
          
          log('Fetched ${messageList.length} messages');
          for (final msg in messageList) {
            log('Message: ${msg.message} (${msg.time})');
          }
        } catch (e, stacktrace) {
          log('Error processing messages', error: e, stackTrace: stacktrace);
          messageList.value = [];
        }
      },
      onError: (error) {
        log('Error in message stream: $error', error: error);
        messageList.value = [];
      },
      cancelOnError: false,
    );
  }

  @override
  void onClose() {
    _chatSubscription?.cancel();
    super.onClose();
  }
}
