import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../entities/messages.dart';

abstract interface class ChatRepository {
  Future<Either<Failure, void>> sendMessage(Message message);
  Future<Either<Failure, void>> deleteMessage(Message message);
  Future<Either<Failure, Stream<List<Message>>>> getMessages(String currentUserId, String receiverId);
}
