class UserModel {
  String email;
  String name;
  String uid;

  UserModel({
    required this.email,
    required this.name,
    required this.uid,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['userid']??'',
      email: map['email'] ?? '',
      name: map['name'] ?? '',

    );
  }
}
