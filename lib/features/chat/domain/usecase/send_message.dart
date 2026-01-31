import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/messages.dart';
import '../repository/chat_repository.dart';

class SendMessage implements UseCase<void, Message> {
  final ChatRepository repository;
  SendMessage(this.repository);

  @override
  Future<Either<Failure, void>> call(Message message) async {
    return await repository.sendMessage(message);
  }
}
