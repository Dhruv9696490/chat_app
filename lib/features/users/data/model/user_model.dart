import 'package:chat_app/core/entities/user.dart';

class UserModel extends User {
  UserModel({required super.uid, required super.email, required super.name});
  Map<String, dynamic> toJson() {
    return {'uid': uid, 'email': email, 'name': name};
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
    );
  }
}
