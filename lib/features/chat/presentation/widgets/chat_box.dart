import 'package:chat_app/core/constant/constant.dart';
import 'package:chat_app/core/cubit/currentTheme/theme_cubit.dart';
import 'package:chat_app/core/theme/app_pallete.dart';
import 'package:chat_app/core/utils/loading_indicator.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:chat_app/features/chat/presentation/bloc/selected_message/selected_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ChatBox extends StatelessWidget {
  final String currentUserId;
  const ChatBox({super.key, required this.currentUserId});
  @override
  Widget build(BuildContext context) {
    final isDark = context.read<ThemeCubit>().state.isDark;
    final isSelected = context.read<SelectedCubit>();
    return Expanded(
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const LoadingIndicator();
          } else if (state is ChatLoaded) {
            final messages = state.messages;
            return ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (_, index) {
                final msg = messages[index];
                final isMe = msg.senderId == currentUserId;
                return Container(
                  width: double.infinity,
                  color: isSelected.state?.id == msg.id
                      ? Colors.blue.withAlpha(80)
                      : null,
                  child: Align(
                    alignment: isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        isSelected.state == null
                            ? null
                            : isSelected.deleteMessage();
                      },
                      onLongPress: () {
                        isMe
                            ? msg.text != Constant.deletedMessage
                                  ? isSelected.newMessage(msg)
                                  : null
                            : null;
                      },
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark
                              ? isMe
                                    ? AppPallete.senderMessageForDark
                                    : AppPallete.reciverMessageForDark
                              : isMe
                              ? AppPallete.senderMessageForLight
                              : AppPallete.reciverMessageForLight,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(isMe ? 16 : 0),
                            bottomRight: Radius.circular(isMe ? 0 : 16),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              msg.text,
                              style: TextStyle(
                                color: msg.text != Constant.deletedMessage
                                    ? isDark
                                          ? Colors.white
                                          : Colors.black
                                    : isDark
                                    ? Colors.white60
                                    : Colors.grey[600],
                                fontSize: 15,
                                fontStyle: msg.text != Constant.deletedMessage
                                    ? null
                                    : FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  msg.isEdited ? '(edited) ' : '',
                                  style: const TextStyle(
                                    color: AppPallete.greyColor,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  DateFormat('h:mm a').format(msg.timestamp),
                                  style: const TextStyle(
                                    color: AppPallete.greyColor,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
    );
  }
}
