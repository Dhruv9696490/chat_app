import 'package:chat_app/core/error/exception.dart';
import 'package:chat_app/features/chat/data/model/message_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract interface class ChatLocalDataSource {
  Future<List<MessageModel>> getAllMessage();
  Future<void> uploadMessage({required List<MessageModel> messages});
}

class ChatLocalDataSourceImple implements ChatLocalDataSource {
  final Box box;
  ChatLocalDataSourceImple({required this.box});
  @override
  Future<List<MessageModel>> getAllMessage() async {
    final List<MessageModel> list = [];
    try {
      for (var key in box.keys) {
        list.add(MessageModel.fromJson(box.get(key), null));
      }
      return list;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> uploadMessage({required List<MessageModel> messages}) async {
    try {
      for (int i = 0; i < messages.length; i++) {
        await box.put(messages[i].id, messages[i].toJson());
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
