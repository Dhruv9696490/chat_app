import 'dart:ui';
import 'package:flutter/material.dart';

class ProfileImageView extends StatelessWidget {
  final String imageUrl;
  final String tag;

  const ProfileImageView({
    super.key,
    required this.imageUrl,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Stack(
        fit: StackFit.expand,
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),

          // 🔹 Sharp circular image
          Center(
            child: Hero(
              tag: tag,
              child: ClipOval(
                child: Image.network(
                  imageUrl,
                  width: 260,
                  height: 260,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
