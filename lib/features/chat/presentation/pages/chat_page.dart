import 'package:chat_app/core/utils/loadingIndicator.dart';
import 'package:chat_app/features/auth/domain/entities/user.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/auth/presentation/pages/login_page.dart';
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
    if (_controller.text.trim().isEmpty) return;

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
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
            Navigator.pushReplacement(context, LoginPage.route());
          }
          if (state is AuthLoading) {
            LoadingIndicator();
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, size: 40),
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.url),
                        radius: 30,
                      ),
                      SizedBox(width: 8),
                      Text(
                        widget.receiverName.split(' ')[0],
                        style: TextStyle(fontSize: 27),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.search, color: Colors.grey),
                      ),
                      PopupMenuButton(
                        iconColor: Colors.grey,
                        onSelected: (value) {
                          if (value == 'Logout') {}
                        },
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: 'Setting',
                              child: Text("Setting"),
                            ),
                            PopupMenuItem(
                              value: 'Logout',
                              child: Text("Logout"),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    if (state is ChatLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ChatLoaded) {
                      final messages = state.messages;
                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (_, index) {
                          final msg = messages[index];
                          final isMe = msg.senderId == widget.currentUserId;
                          return Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? Colors.blueAccent
                                    : Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                msg.text,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is ChatError) {
                      return Center(child: Text(state.message));
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.black12,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(Icons.send,size: 37,),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

