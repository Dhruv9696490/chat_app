import 'package:chat_app/core/cubit/currentUser/current_user_cubit.dart';
import 'package:chat_app/core/theme/app_pallete.dart';
import 'package:chat_app/core/utils/loadingIndicator.dart';
import 'package:chat_app/core/entities/user.dart';
import 'package:chat_app/core/utils/snack_bar.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/auth/presentation/pages/login_page.dart';
import 'package:chat_app/features/users/presentation/bloc/bloc/users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/chat_item_list.dart';

class UsersScreen extends StatefulWidget {
  static route(User user1) => MaterialPageRoute(builder: (_) => UsersScreen(user: user1));

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
  Widget build(BuildContext context) {
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
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: AppPallete.appBarColor,
            title: const Text(
              "Chat App",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              PopupMenuButton(
                onSelected: (value) {
                  if (value == 'LOGOUT') {
                    // BlocProvider.of<AuthBloc>(context).add(AuthSignOut());
                    context.read<AuthBloc>().add(AuthSignOut());
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(value: 'SETTING', child: Text("Setting")),
                    PopupMenuItem(value: 'LOGOUT', child: Text("Logout")),
                  ];
                },
              ),
            ],
            bottom: TabBar(
              tabs: [
                Tab(text: 'Home'),
                Tab(text: 'STATUS'),
                Tab(text: 'CALL'),
              ],
              indicatorWeight: 4,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              indicatorColor: AppPallete.tabColor,
              labelColor: AppPallete.tabColor,
              unselectedLabelColor: Colors.grey,
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
                  return LoadingIndicator();
                }
                if (state is UsersBlocSuccess) {
                  return TabBarView(
                    children: [
                      ContactList(newList: state.users),
                      const Center(
                        child: Text(
                          "Status Screen",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          "Call Screen",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return SizedBox();
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("working")));
            },
            foregroundColor: Colors.white,
            backgroundColor: AppPallete.tabColor,
            child: Icon(Icons.comment, size: 30),
          ),
        ),
      ),
    );
  }
}
