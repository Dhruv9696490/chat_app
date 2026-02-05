import 'package:chat_app/core/cubit/currentTheme/theme_cubit.dart';
import 'package:chat_app/core/cubit/currentUser/current_user_cubit.dart';
import 'package:chat_app/core/theme/app_pallete.dart';
import 'package:chat_app/core/utils/loading_indicator.dart';
import 'package:chat_app/core/entities/user.dart';
import 'package:chat_app/core/utils/snack_bar.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/auth/presentation/pages/login_page.dart';
import 'package:chat_app/features/users/presentation/bloc/bloc/users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/chat_item_list.dart';

class UsersScreen extends StatefulWidget {
  static route(User user1) =>
      MaterialPageRoute(builder: (_) => UsersScreen(user: user1));

  final User user;
  const UsersScreen({super.key, required this.user});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    context.read<UsersBloc>().add(GetAllUsersEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context){
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
        if (state is CurrentUserLoggedIn) {
          showSnackBar(context, state.user.email);
        }
        if (state is CurrentUserInitial) {
          showSnackBar(context, "initial state");
        }
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: const Text("WhatsApp"),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: AppPallete.whiteColor,
                  size: 25,
                ),
              ),
              PopupMenuButton(
                iconSize: 25,
                iconColor: AppPallete.whiteColor,
                menuPadding: const EdgeInsets.all(0),
                onSelected: (value) {
                  if (value == 'LOGOUT') {
                    context.read<AuthBloc>().add(AuthSignOut());
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
                              ? const Icon(Icons.dark_mode_outlined)
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
            bottom: const TabBar(
              tabs: [
                Tab(text: 'HOME'),
                Tab(text: 'STATUS'),
                Tab(text: 'CALL'),
              ],
              indicatorWeight: 4,
            ),
          ),
          body: BlocListener<CurrentUserCubit, CurrentUserState>(
            listener: (context, state) {
              if (state is CurrentUserInitial) {
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
                  return TabBarView(
                    children: [
                      ContactList(list: state.users),
                      const Center(
                        child: Text(
                          "Status Screen",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          "Call Screen",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar( const SnackBar(content: Text("working")));
            },
            child: const Icon(Icons.comment, size: 30),
          ),
        ),
      ),
    );
  }
}
