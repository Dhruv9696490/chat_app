import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget {
  final String url;
  final String receiverName;
  const ChatAppBar({super.key, required this.url, required this.receiverName});

  @override
  Widget build(BuildContext context) {
    return Row(
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
            CircleAvatar(backgroundImage: NetworkImage(url), radius: 30),
            SizedBox(width: 8),
            Text(
              receiverName.split(' ')[0],
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
                  PopupMenuItem(value: 'Setting', child: Text("Setting")),
                  PopupMenuItem(value: 'Logout', child: Text("Logout")),
                ];
              },
            ),
          ],
        ),
      ],
    );
  }
}
