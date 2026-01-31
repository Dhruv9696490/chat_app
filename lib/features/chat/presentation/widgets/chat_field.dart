import 'package:flutter/material.dart';

class ChatField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onPressed;
  const ChatField({super.key, required this.controller, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.black12,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.send, size: 37),
          ),
        ],
      ),
    );
  }
}
