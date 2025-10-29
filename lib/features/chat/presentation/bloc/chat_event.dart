part of 'chat_bloc.dart';

abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final Message message;

  SendMessageEvent(this.message);
}

class GetMessagesEvent extends ChatEvent {
  final String currentUserId;
  final String receiverId;

  GetMessagesEvent(this.currentUserId, this.receiverId);
}
