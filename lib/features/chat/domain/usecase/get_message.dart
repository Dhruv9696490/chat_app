import 'package:chat_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/messages.dart';
import '../repository/chat_repository.dart';

class GetMessages {
  final ChatRepository repository;

  GetMessages(this.repository);

  
  Future<Either<Failure,Stream<List<Message>>>> call(String currentUserId, String receiverId)async{
    return await repository.getMessages(currentUserId, receiverId);
  }
}
