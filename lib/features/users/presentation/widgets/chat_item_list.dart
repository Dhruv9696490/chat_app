import 'package:chat_app/core/cubit/currentUser/current_user_cubit.dart';
import 'package:chat_app/core/entities/user.dart';
import 'package:chat_app/features/chat/presentation/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_pallete.dart';
import '../../../../info.dart';

class ContactList extends StatelessWidget {
  final List<User> newList;

  const ContactList({super.key, required this.newList});

  @override
  Widget build(BuildContext context) {
    final user = (context.read<CurrentUserCubit>().state as CurrentUserLoggedIn).user;
    final list = newList;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          
          final item = list[index];
          return Column(
            children: [
              InkWell(
                onTap: () {
                  final receiver = list[index];
                  Navigator.push(
                    context,
                    ChatPage.route(
                      user,
                      user.uid,
                      receiver.uid,
                      receiver.name,
                      info[index % info.length]['profilePic'] ?? "",
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        info[index % info.length]['profilePic'].toString(),
                      ),
                      radius: 30,
                    ),
                    title: Text(
                      !(user.uid == item.uid)
                          ? item.name.toUpperCase() 
                          : "${user.name} (You)",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        info[index % info.length]['message'].toString(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    trailing: Text(
                      info[index % info.length]['time'].toString(),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(color: AppPallete.dividerColor, indent: 85),
            ],
          );
        },
      ),
    );
  }
}
