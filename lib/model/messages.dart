import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  String name;
  String email;
  String senderId;
  String receiverId;
  String message;
  Timestamp? time;

  Messages({
    required this.name,
    required this.email,
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.time,
  });

  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      message: json['message'] ?? '',
      time: json['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'time': FieldValue.serverTimestamp(),
    };
  }
}
