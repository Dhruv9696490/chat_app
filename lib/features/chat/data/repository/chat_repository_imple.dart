import 'package:chat_app/features/chat/data/model/message_model.dart';
import 'package:chat_app/features/chat/domain/entities/messages.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../domain/repository/chat_repository.dart';
import '../dataSource/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Either<Failure, Stream<List<Message>>> getMessages(
    String currentUserId,
    String receiverId,
  ) {
    try {
      final res = remoteDataSource.getMessages(currentUserId, receiverId);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.error));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(Message message) async {
    try {
      await remoteDataSource.sendMessage(
        MessageModel(
          id: message.id,
          senderId: message.senderId,
          receiverId: message.receiverId,
          text: message.text,
          timestamp: message.timestamp,
        ),
      );
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.error));
    }
  }
}
