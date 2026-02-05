import 'package:chat_app/core/constant/constant.dart';
import 'package:chat_app/features/chat/data/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exception.dart';

abstract interface class ChatRemoteDataSource {
  Future<void> sendMessage(MessageModel message);
  Stream<List<MessageModel>> getMessages(
    String currentUserId,
    String receiverId,
  );
  Future<void> deleteMessage(MessageModel message);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;
  ChatRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> deleteMessage(MessageModel message) async {
    try {
      await firestore
          .collection('chats')
          .doc(_getChatId(message.senderId, message.receiverId))
          .collection('messages')
          .doc(message.id)
          .update({'text': Constant.deletedMessage});
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> sendMessage(MessageModel message) async {
    try {
      await firestore
          .collection('chats')
          .doc(_getChatId(message.senderId, message.receiverId))
          .collection('messages')
          .add(Map<String, dynamic>.from(message.toJson()));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<MessageModel>> getMessages(
    String currentUserId,
    String receiverId,
  ) {
    try {
      return firestore
          .collection('chats')
          .doc(_getChatId(currentUserId, receiverId))
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((item) {
              return MessageModel.fromJson(item.data(), item.id);
            }).toList();
          });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  String _getChatId(String senderId, String receiverId) {
    return senderId.hashCode <= receiverId.hashCode
        ? '${senderId}_$receiverId'
        : '${receiverId}_$senderId';
  }
}
