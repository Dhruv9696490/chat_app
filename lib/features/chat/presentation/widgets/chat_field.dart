import 'package:chat_app/core/cubit/currentTheme/theme_cubit.dart';
import 'package:chat_app/core/theme/app_pallete.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatField({super.key, required this.controller, required this.onSend});

  @override
  State<ChatField> createState() => _ChatFieldState();
}

class _ChatFieldState extends State<ChatField> {
  bool _showEmoji = false;
  @override
  Widget build(BuildContext context) {
    final isDark = context.read<ThemeCubit>().state.isDark;
    final fieldColor = isDark ? AppPallete.darkField : AppPallete.whiteColor;
    final iconColor = isDark ? Colors.grey[300] : Colors.grey[700];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: fieldColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _showEmoji = !_showEmoji;
                        });
                      },
                      child: Icon(
                        Icons.emoji_emotions_outlined,
                        color: iconColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        style: TextStyle(
                          color: isDark
                              ? AppPallete.whiteColor
                              : AppPallete.blackColor,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Message',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(Icons.attach_file, color: iconColor),
                    const SizedBox(width: 8),
                    Icon(Icons.camera_alt, color: iconColor),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 24,
              backgroundColor: AppPallete.appBarColor,
              child: IconButton(
                onPressed: widget.onSend,
                icon: const Icon(Icons.send, color: AppPallete.whiteColor),
              ),
            ),
          ],
        ),
        Offstage(
          offstage: !_showEmoji,
          child: EmojiPicker(
            textEditingController: widget.controller,
            config: Config(
              emojiTextStyle: const TextStyle(color: Colors.red),
              height: 256,
              checkPlatformCompatibility: true,
              viewOrderConfig: const ViewOrderConfig(),
              emojiViewConfig: EmojiViewConfig(
                emojiSizeMax:
                    28 *
                    (foundation.defaultTargetPlatform == TargetPlatform.iOS
                        ? 1.2
                        : 1.0),
              ),
              skinToneConfig: SkinToneConfig(
                dialogBackgroundColor: fieldColor,
                indicatorColor: AppPallete.appBarColor,
                enabled: false,
              ),
              categoryViewConfig: CategoryViewConfig(
                backgroundColor: fieldColor,
                dividerColor: AppPallete.appBarColor,
                indicatorColor: AppPallete.appBarColor,
                iconColorSelected: AppPallete.appBarColor,
              ),
              bottomActionBarConfig: const BottomActionBarConfig(
                enabled: false,
              ),
              searchViewConfig: SearchViewConfig(
                backgroundColor: fieldColor,
                buttonIconColor: AppPallete.appBarColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
