import '../entities/messages.dart';
import '../repository/chat_repository.dart';

class GetMessages {
  final ChatRepository repository;

  GetMessages(this.repository);

  Stream<List<Message>> call(String currentUserId, String receiverId) {
    return repository.getMessages(currentUserId, receiverId);
  }
}
