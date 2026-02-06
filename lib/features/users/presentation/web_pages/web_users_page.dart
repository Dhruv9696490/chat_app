import 'package:chat_app/core/cubit/currentTheme/theme_cubit.dart';
import 'package:chat_app/core/cubit/currentUser/current_user_cubit.dart';
import 'package:chat_app/core/theme/app_pallete.dart';
import 'package:chat_app/core/utils/loading_indicator.dart';
import 'package:chat_app/core/utils/snack_bar.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/auth/presentation/pages/login_page.dart';
import 'package:chat_app/features/chat/presentation/pages/chat_page.dart';
import 'package:chat_app/features/users/presentation/bloc/user_bloc/users_bloc.dart';
import 'package:chat_app/features/users/presentation/bloc/web_chat/web_chat_cubit.dart';
import 'package:chat_app/features/users/presentation/widgets/chat_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WebUsersPage extends StatefulWidget {
  const WebUsersPage({super.key});

  @override
  State<WebUsersPage> createState() => _WebUsersPageState();
}

class _WebUsersPageState extends State<WebUsersPage> {
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
    final isDark = context.watch<ThemeCubit>().state.isDark;
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
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: AppPallete.appBarColor,
                            ),
                            height: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "  WhatsApp",
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    color: AppPallete.whiteColor,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                isSearch
                                    ? Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            constraints: const BoxConstraints(
                                              maxWidth: 400,
                                            ),
                                            height: 45,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 8,
                                                  ),
                                              child: TextField(
                                                controller: controller,
                                                autofocus: true,
                                                decoration: InputDecoration(
                                                  hintText: 'Search',
                                                  prefixIcon: GestureDetector(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: const Icon(
                                                      Icons.search,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  filled: true,
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 0,
                                                      ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isSearch = !isSearch;
                                      controller.clear();
                                    });
                                  },
                                  icon: Icon(
                                    isSearch ? Icons.close : Icons.search,
                                    color: AppPallete.whiteColor,
                                    size: isSearch ? 30 : 25,
                                  ),
                                ),
                                PopupMenuButton(
                                  iconSize: 25,
                                  iconColor: AppPallete.whiteColor,
                                  menuPadding: const EdgeInsets.all(0),
                                  onSelected: (value) {
                                    if (value == 'LOGOUT') {
                                      context.read<AuthBloc>().add(
                                        AuthSignOut(),
                                      );
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
                                                ? const Icon(
                                                    Icons.dark_mode_outlined,
                                                  )
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
                          Expanded(
                            child: ContactList(
                              list: newList,
                            ),
                          ),
                        ],
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
                                    key: ValueKey(webChat.state!.receiverId),
                                    currentUserId: webChat.state!.currentUserId,
                                    receiverId: webChat.state!.receiverId,
                                    receiverName: webChat.state!.receiverName,
                                    user: webChat.state!.user,
                                    url: webChat.state!.url, isMobileView: false,
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
