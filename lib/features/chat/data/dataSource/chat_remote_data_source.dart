import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exception.dart';
import '../../domain/entities/messages.dart';

abstract interface class ChatRemoteDataSource {
  Future<void> sendMessage(Message message);

  Stream<List<Message>> getMessages(String currentUserId, String receiverId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;

  ChatRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> sendMessage(Message message) async {
    try {
      await firestore
          .collection('chats')
          .doc(_getChatId(message.senderId, message.receiverId))
          .collection('messages')
          .add(message.toMap());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<Message>> getMessages(String currentUserId, String receiverId) {
    try {
      return firestore
          .collection('chats')
          .doc(_getChatId(currentUserId, receiverId))
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => Message.fromMap(doc.data(), doc.id))
                .toList();
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
