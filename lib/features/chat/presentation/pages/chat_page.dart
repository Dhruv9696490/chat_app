import 'package:chat_app/core/cubit/currentTheme/theme_cubit.dart';
import 'package:chat_app/core/entities/user.dart';
import 'package:chat_app/core/theme/app_pallete.dart';
import 'package:chat_app/core/utils/profile_image_view.dart';
import 'package:chat_app/core/utils/snack_bar.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/chat/presentation/bloc/selected_message/selected_cubit.dart';
import 'package:chat_app/features/chat/presentation/widgets/chat_box.dart';
import 'package:chat_app/features/chat/presentation/widgets/chat_field.dart';
import 'package:chat_app/features/users/presentation/bloc/web_chat/web_chat_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/messages.dart';
import '../bloc/chat/chat_bloc.dart';

class ChatPage extends StatefulWidget {
  final bool isMobileView;
  final String currentUserId;
  final String receiverId;
  final String receiverName;
  final String url;
  final User user;

  static route(
    bool isMobileView,
    User user,
    String currentUserId,
    String receiverId,
    String receiverName,
    String url,
  ) => MaterialPageRoute(
    builder: (_) {
      return ChatPage(
        isMobileView: isMobileView,
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
    required this.isMobileView,
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
      isEdited: false,
    );

    context.read<ChatBloc>().add(SendMessageEvent(message));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.read<ThemeCubit>().state.isDark;
    final isSelected = context.watch<SelectedCubit>().state;
    final screenWidth = MediaQuery.of(context).size.width;

    if (widget.isMobileView && screenWidth > 862) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<WebChatCubit>().selectChat(
            UserMessageScreen(
              currentUserId: widget.currentUserId,
              receiverId: widget.receiverId,
              receiverName: widget.receiverName,
              user: widget.user,
              url: widget.url,
            ),
          );
          Navigator.pop(context);
        }
      });
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: AppPallete.appBarColor,
          toolbarHeight: kIsWeb ? 90 : null,
          leading: isSelected != null
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    context.read<SelectedCubit>().deleteMessage();
                  },
                )
              : null,
          iconTheme: const IconThemeData(
            color: AppPallete.whiteColor,
            size: 28,
          ),
          titleSpacing: 0,
          title: isSelected != null
              ? const Text('1 selected', style: TextStyle(fontSize: 20))
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return ProfileImageView(
                              tag: widget.receiverId,
                              imageUrl: widget.url,
                            );
                          },
                        );
                      },
                      child: SizedBox(
                        height: 70,
                        child: Padding(
                          padding: kIsWeb
                              ? const EdgeInsets.only(left: 8, right: 8)
                              : const EdgeInsets.only(right: 8),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(widget.url),
                            radius: 28,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.receiverName.split(' ')[0][0].toUpperCase() +
                          widget.receiverName
                              .split(' ')[0]
                              .substring(1)
                              .toLowerCase(),
                      style: const TextStyle(fontSize: 27),
                    ),
                    const Spacer(),
                  ],
                ),
          actions: isSelected != null
              ? [
                  if (isSelected.senderId == widget.currentUserId)
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: AppPallete.whiteColor,
                      ),
                      onPressed: () {
                        editMessage(isSelected);
                      },
                    ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: AppPallete.whiteColor,
                    ),
                    onPressed: () {
                      deleteMessage(isSelected);
                    },
                  ),
                ]
              : [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.call),
                    color: AppPallete.whiteColor,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.videocam_outlined,
                      color: AppPallete.whiteColor,
                    ),
                  ),
                  PopupMenuButton(
                    iconColor: AppPallete.whiteColor,
                    iconSize: 25,
                    onSelected: (value) {
                      if (value == 'LOGOUT') {
                        context.read<AuthBloc>().add(AuthSignOut());
                      }
                      if (value == 'THEME') {
                        context.read<ThemeCubit>().changeTheme();
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: 'SETTING',
                          child: Row(
                            children: [
                              Icon(Icons.settings),
                              SizedBox(width: 8),
                              Text("Setting"),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'THEME',
                          child: Row(
                            children: [
                              !isDark
                                  ? const Icon(Icons.dark_mode_outlined)
                                  : const Icon(Icons.sunny),
                              const SizedBox(width: 8),
                              !isDark
                                  ? const Text("Dark Mode")
                                  : const Text("Light Mode"),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'LOGOUT',
                          child: Row(
                            children: [
                              Icon(Icons.logout),
                              SizedBox(width: 8),
                              Text("Logout"),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: isDark
                ? const AssetImage(
                    'assets/images/whatsapp_black_background.png',
                  )
                : const AssetImage(
                    'assets/images/whatsapp_white_background.png',
                  ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              ChatBox(currentUserId: widget.currentUserId),
              Padding(
                padding: kIsWeb
                    ? const EdgeInsets.fromLTRB(8, 0, 8, 20)
                    : const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                child: ChatField(controller: _controller, onSend: sendMessage),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void editMessage(Message message) {
    final controller = TextEditingController(text: message.text);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            child: ChatField(
              controller: controller,
              onSend: () {
                if (controller.text.isEmpty) {
                  showSnackBar(context, 'enter any message');
                }
                final msg = Message(
                  isEdited: true,
                  id: message.id,
                  senderId: message.senderId,
                  receiverId: message.receiverId,
                  text: controller.text.trim(),
                  timestamp: message.timestamp,
                );
                context.read<ChatBloc>().add(UpdateMessageEvent(msg));
                controller.clear();
                context.read<SelectedCubit>().deleteMessage();
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  void deleteMessage(Message message) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Do you want to delete this message?"),
          actions: [
            TextButton(
              onPressed: () {
                context.read<ChatBloc>().add(DeleteMessageEvent(message));
                context.read<SelectedCubit>().deleteMessage();
                Navigator.pop(context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: AppPallete.errorColor),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<SelectedCubit>().deleteMessage();
                Navigator.pop(context);
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }
}
