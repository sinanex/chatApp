import 'dart:developer';

class SingleUserModel {
  String? email;
  String name;
  String? uid;
  String profile;
  String bio;
  String? id;

  SingleUserModel({
    this.id,
    required this.bio,
    required this.profile,
    this.email,
    required this.name,
    this.uid,
  });

  factory SingleUserModel.fromMap(Map<String, dynamic> map, String? id) {
    log('document id $id');
    return SingleUserModel(
      id: id,
      bio: map['bio'] ?? 'add bio',
      profile: map['profile'] ?? '',
      uid: map['userid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bio': bio,
      'profile': profile,
      'userid': uid,
      'name': name,
      'email': email,
    };
  }
}
