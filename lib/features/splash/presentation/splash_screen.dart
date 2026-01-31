import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(seconds: 3), () {
    //   // ignore: use_build_context_synchronously
    //   context.read<AuthBloc>().add(AuthGetCurrentUser());
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/backgroundImageW.png',fit: BoxFit.cover,),
          Image.asset('assets/images/whatsapp-logo.png',alignment: AlignmentGeometry.center,scale: 2,),
        ],
      ),
    );
  }
}
