import 'package:chat_app/core/error/exception.dart';
import 'package:chat_app/features/users/data/model/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract interface class UsersLocalDataSource {
  Future<void> uploadUsers({required List<UserModel> users});
  Future<List<UserModel>> getAllUsers();
}

class UsersLocalDataSourceImple implements UsersLocalDataSource {
  final Box box;
  UsersLocalDataSourceImple({required this.box});
  @override
  Future<void> uploadUsers({required List<UserModel> users}) async {
    try {
      await box.clear();
      for (int i = 0; i < users.length; i++) {
        await box.put(i.toString(), users[i].toJson());
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final List<UserModel> list = [];
    try {
      for (int i = 0; i < box.length; i++) {
        list.add(UserModel.fromJson(box.get(i.toString())));
      }
      return list;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
