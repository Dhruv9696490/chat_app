import 'package:chat_app/core/cubit/currentTheme/theme_cubit.dart';
import 'package:chat_app/core/cubit/currentUser/current_user_cubit.dart';
import 'package:chat_app/core/theme/app_pallete.dart';
import 'package:chat_app/core/utils/loading_indicator.dart';
import 'package:chat_app/core/utils/snack_bar.dart';
import 'package:chat_app/features/auth/presentation/pages/login_page.dart';
import 'package:chat_app/features/chat/presentation/pages/chat_page.dart';
import 'package:chat_app/features/users/presentation/bloc/user_bloc/users_bloc.dart';
import 'package:chat_app/features/users/presentation/bloc/web_chat/web_chat_cubit.dart';
import 'package:chat_app/features/users/presentation/widgets/chat_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersPageWeb extends StatefulWidget {
  const UsersPageWeb({super.key});

  @override
  State<UsersPageWeb> createState() => _UsersPageWebState();
}

class _UsersPageWebState extends State<UsersPageWeb> {
  final controller = TextEditingController();
  bool isSearch = false;
  @override
  void initState() {
    context.read<UsersBloc>().add(GetAllUsersEvent());
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final webChat = context.watch<WebChatCubit>();
    final isDark = context.read<ThemeCubit>().state.isDark;
    return BlocListener<CurrentUserCubit, CurrentUserState>(
      listener: (context, state) {
        if (state is CurrentUserLoggedOut) {
          Navigator.pushAndRemoveUntil(
            context,
            LoginPage.route(),
            (_) => false,
          );
        }
      },
      child: Scaffold(
        body: BlocListener<CurrentUserCubit, CurrentUserState>(
          listener: (context, state) {
            if (state is CurrentUserLoggedOut) {
              Navigator.pushAndRemoveUntil(
                context,
                LoginPage.route(),
                (_) => false,
              );
            }
          },
          child: BlocConsumer<UsersBloc, UsersBlocState>(
            listener: (context, state) {
              if (state is UsersBlocFailure) {
                showSnackBar(context, state.message);
              }
            },
            builder: (BuildContext context, UsersBlocState state) {
              if (state is UsersBlocLoading) {
                return const LoadingIndicator();
              }
              if (state is UsersBlocSuccess) {
                final newList = state.users.where((element) {
                  return element.name.toLowerCase().contains(
                    controller.text.trim().toLowerCase(),
                  );
                }).toList();
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Column(
                        children: [Expanded(child: ContactList(list: newList))],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.70,
                      decoration: BoxDecoration(
                        border: const Border(
                          left: BorderSide(color: AppPallete.dividerColor),
                        ),
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
                      child: (webChat.state == null)
                          ? null
                          : Column(
                              children: [
                                Expanded(
                                  child: ChatPage(
                                    currentUserId: webChat.state!.currentUserId,
                                    receiverId: webChat.state!.receiverId,
                                    receiverName: webChat.state!.receiverName,
                                    user: webChat.state!.user,
                                    url: webChat.state!.url,
                                    isMobileView: false,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
