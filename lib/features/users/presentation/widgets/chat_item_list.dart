import 'package:chat_app/core/cubit/currentUser/current_user_cubit.dart';
import 'package:chat_app/core/entities/user.dart';
import 'package:chat_app/core/utils/profile_image_view.dart';
import 'package:chat_app/features/chat/presentation/pages/chat_page.dart';
import 'package:chat_app/features/users/presentation/bloc/web_chat/web_chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../info.dart';

class ContactList extends StatelessWidget {
  final List<User> list;

  const ContactList({
    super.key,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final user = (context.read<CurrentUserCubit>().state as CurrentUserLoggedIn).user;
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        final chatInfo = info[index % info.length];
        return ListTile(
          onTap: () {
            width < 862
                ? Navigator.push(
                    context,
                    ChatPage.route(
                      true,
                      user,
                      user.uid,
                      item.uid,
                      item.name,
                      chatInfo['profilePic'] ?? '',
                    ),
                  )
                : context.read<WebChatCubit>().selectChat(
                    UserMessageScreen(
                      currentUserId: user.uid,
                      receiverId: item.uid,
                      receiverName: item.name,
                      user: user,
                      url: chatInfo['profilePic'] ?? '',
                    ),
                  );
          },

          contentPadding: const EdgeInsets.fromLTRB(9, 8, 16, 0),

          leading: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  return ProfileImageView(
                    tag: item.uid,
                    imageUrl: chatInfo['profilePic'] ?? '',
                  );
                },
              );
            },
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(chatInfo['profilePic'].toString()),
            ),
          ),

          title: Text(
            user.uid == item.uid ? '${user.name} (You)' : item.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          subtitle: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Text(
              chatInfo['message'].toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          trailing: Text(
            chatInfo['time'].toString(),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        );
      },
    );
  }
}
