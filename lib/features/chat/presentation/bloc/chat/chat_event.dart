part of 'chat_bloc.dart';

abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final Message message;
  SendMessageEvent(this.message);
}
class DeleteMessageEvent extends ChatEvent {
  final Message message;
  DeleteMessageEvent(this.message);
}
class UpdateMessageEvent extends ChatEvent {
  final Message message;
  UpdateMessageEvent(this.message);
}

class GetMessagesEvent extends ChatEvent {
  final String currentUserId;
  final String receiverId;

  GetMessagesEvent(this.currentUserId, this.receiverId);
}
