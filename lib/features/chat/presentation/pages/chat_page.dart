import 'package:chat_app/core/entities/user.dart';
import 'package:chat_app/core/utils/snack_bar.dart';
import 'package:chat_app/features/chat/presentation/widgets/chat_app_bar.dart';
import 'package:chat_app/features/chat/presentation/widgets/chat_box.dart';
import 'package:chat_app/features/chat/presentation/widgets/chat_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/messages.dart';
import '../bloc/chat_bloc.dart';

class ChatPage extends StatefulWidget {
  final String currentUserId;
  final String receiverId;
  final String receiverName;
  final String url;
  final User user;

  static route(
    User user,
    String currentUserId,
    String receiverId,
    String receiverName,
    String url,
  ) => MaterialPageRoute(
    builder: (_) {
      return ChatPage(
        user: user,
        currentUserId: currentUserId,
        receiverId: receiverId,
        receiverName: receiverName,
        url: url,
      );
    },
  );

  const ChatPage({
    super.key,
    required this.currentUserId,
    required this.receiverId,
    required this.receiverName,
    required this.user,
    required this.url,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(
      GetMessagesEvent(widget.currentUserId, widget.receiverId),
    );
  }

  void sendMessage() {
    if (_controller.text.trim().isEmpty) {
      showSnackBar(context, "enter any message");
      return;
    }

    final message = Message(
      id: '',
      senderId: widget.currentUserId,
      receiverId: widget.receiverId,
      text: _controller.text.trim(),
      timestamp: DateTime.now(),
    );

    context.read<ChatBloc>().add(SendMessageEvent(message));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ChatAppBar(url: widget.url, receiverName: widget.receiverName),
            ChatBox(currentUserId: widget.currentUserId),
            ChatField(controller: _controller, onPressed: sendMessage)
          ],
        ),
      ),
    );
  }
}
