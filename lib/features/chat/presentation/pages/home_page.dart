import 'package:chat_app/core/theme/app_pallete.dart';
import 'package:chat_app/core/utils/loadingIndicator.dart';
import 'package:chat_app/features/auth/domain/entities/user.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/chat_item_list.dart';


class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
        BlocProvider.of<AuthBloc>(context).add(AuthGetAllUser());
        super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: AppPallete.appBarColor,
            title: const Text("Chat App", style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              PopupMenuButton(onSelected: (value) {
                if (value == 'LOGOUT') {
                  BlocProvider.of<AuthBloc>(context).add(AuthSignOut());
                }
              },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        value: 'SETTING',
                        child: Text("Setting")),
                    PopupMenuItem(
                        value: 'LOGOUT',
                        child: Text("Logout")),
                  ];
                },)
            ],
            bottom: TabBar(tabs: [
              Tab(text: 'Home'),
              Tab(text: 'STATUS'),
              Tab(text: 'CALL'),
            ],
              indicatorWeight: 4,
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold
              ),
              indicatorColor: AppPallete.tabColor,
              labelColor: AppPallete.tabColor,
              unselectedLabelColor: Colors.grey,
            ),
          ),
          body: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if(state is AuthInitial){
                Navigator.pushReplacement(context, LoginPage.route());
              }
            },
            builder: (BuildContext context, AuthState state){
              if(state is AuthAllUser){
                return TabBarView(children: [
                  ContactList(list: state.list, user: widget.user,),
                  const Center(child: Text("Status Screen", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.grey,
                  ),),),
                  const Center(child: Text("Call Screen", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.grey,
                  )),),
                ],);
              }
              return LoadingIndicator();
            },
          ),
          floatingActionButton: FloatingActionButton(onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("working")));
          },
            foregroundColor: Colors.white,
            backgroundColor: AppPallete.tabColor,
            child: Icon(Icons.comment, size: 30,),)),
    );
  }
}
