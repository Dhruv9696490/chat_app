import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/features/chat/domain/entities/messages.dart';
import 'package:chat_app/features/chat/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateMessage implements UseCase<void, Message> {
  final ChatRepository repository;
  UpdateMessage(this.repository);
  @override
  Future<Either<Failure, void>> call(Message params) async{
    return await repository.updateMessage(params);
  }
}
