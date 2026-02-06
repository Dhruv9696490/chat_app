import 'package:chat_app/core/entities/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WebChatCubit extends Cubit<UserMessageScreen?> {
  WebChatCubit() : super(null);
  void selectChat(UserMessageScreen userMessageScreen) {
    emit(userMessageScreen);
  }

  void unSelectChat() {
    emit(null);
  }
}

class UserMessageScreen {
  final String currentUserId;
  final String receiverId;
  final String receiverName;
  final User user;
  final String url;

  UserMessageScreen({
    required this.currentUserId,
    required this.receiverId,
    required this.receiverName,
    required this.user,
    required this.url,
  });
}
