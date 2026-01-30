import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/messages.dart';
import '../../domain/repository/chat_repository.dart';
import '../dataSource/chat_remote_data_source.dart';
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> sendMessage(Message message) async {
    try {
      await remoteDataSource.sendMessage(message);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.error));
    }
  }

  @override
  Stream<List<Message>> getMessages(String currentUserId, String receiverId) {
    return remoteDataSource.getMessages(currentUserId, receiverId);
  }
}
