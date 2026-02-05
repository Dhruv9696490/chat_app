import 'package:chat_app/core/theme/app_pallete.dart';
import 'package:chat_app/core/utils/profile_image_view.dart';
import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String url;
  final String receiverName;
  final String receiverUid;
  const ChatAppBar({
    super.key,
    required this.url,
    required this.receiverName,
    required this.receiverUid,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: AppPallete.whiteColor, size: 28),
      titleSpacing: 0,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  return ProfileImageView(
                    tag: receiverUid,
                    imageUrl: url,
                  );
                },
              );
            },
            child: CircleAvatar(backgroundImage: NetworkImage(url), radius: 28),
          ),
          const SizedBox(width: 8),
          Text(
            receiverName.split(' ')[0][0].toUpperCase() +
                receiverName.split(' ')[0].substring(1).toLowerCase(),
            style: const TextStyle(fontSize: 27),
          ),
          const Spacer(),
        ],
      ),
      actions: [
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
          // color: AppPallete.whiteColor,
          onSelected: (value) {
            if (value == 'Logout') {}
          },
          itemBuilder: (context) {
            return const [
              PopupMenuItem(value: 'Setting', child: Text("Setting")),
              PopupMenuItem(value: 'Logout', child: Text("Logout")),
            ];
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 13);
}
