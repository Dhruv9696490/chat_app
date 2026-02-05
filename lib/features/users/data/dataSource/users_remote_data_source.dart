import 'package:chat_app/core/error/exception.dart';
import 'package:chat_app/features/users/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class UsersRemoteDataSource {
  Future<List<UserModel>> getAllUsers();
}

class UserRemoteDataSourceImple implements UsersRemoteDataSource {
  final FirebaseFirestore firestore;
  UserRemoteDataSourceImple({required this.firestore});
  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      final snapshot = await firestore.collection('users').get();
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
