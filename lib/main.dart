import 'package:chat_app/core/cubit/currentTheme/theme_cubit.dart';
import 'package:chat_app/core/cubit/currentUser/current_user_cubit.dart';
import 'package:chat_app/core/theme/app_theme.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/auth/presentation/pages/login_page.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:chat_app/features/splash/presentation/splash_screen.dart';
import 'package:chat_app/features/users/presentation/bloc/bloc/users_bloc.dart';
import 'package:chat_app/features/users/presentation/pages/users_page.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/injection_container.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            return getIt<AuthBloc>();
          },
        ),
        BlocProvider(
          create: (_) {
            return ThemeCubit();
          },
        ),
        BlocProvider(
          create: (_) {
            return getIt<CurrentUserCubit>();
          },
        ),
        BlocProvider(
          create: (_) {
            return getIt<UsersBloc>();
          },
        ),
        BlocProvider(
          create: (_) {
            return getIt<ChatBloc>();
          },
        ),
      ],
      child:const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemeCubit, ThemeState, bool>(
      selector: (state) {
        return state.isDark;
      },
      builder: (context, isDark) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                Navigator.pushAndRemoveUntil(
                  context,
                  UsersScreen.route(state.user),
                  (_) => false,
                );
              }
              if (state is AuthUnathenticated) {
                Navigator.pushAndRemoveUntil(
                  context,
                  LoginPage.route(),
                  (_) => false,
                );
              }
            },
            child: const SplashScreen(),
          ),
        );
      },
    );
  }
}
