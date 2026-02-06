import 'package:chat_app/core/theme/app_pallete.dart';
import 'package:chat_app/core/utils/loading_indicator.dart';
import 'package:chat_app/core/utils/snack_bar.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/auth/presentation/pages/login_page.dart';
import 'package:chat_app/features/auth/presentation/widgets/gradient_button.dart';
import 'package:chat_app/features/auth/presentation/widgets/text_field.dart';
import 'package:chat_app/features/users/presentation/layout/responsive_layout.dart';
import 'package:chat_app/features/users/presentation/mobile_pages/users_page.dart';
import 'package:chat_app/features/users/presentation/web_pages/web_users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(
    builder: (_) {
      return const SignUpPage();
    },
  );

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscure = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return ResponsiveLayout(
                    mobile: UsersScreen(user: state.user),
                    web: const WebUsersPage(),
                  );
                },
              ),
              (route) => false,
            );
          }
          if (state is AuthFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const LoadingIndicator();
          }
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppPallete.messageColor, AppPallete.tabColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Card(
                    color: const Color.fromRGBO(237, 236, 236, 1),
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Create Account",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            "Sign up to get started",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          AuthTextField(
                            controller: nameController,
                            icon: Icons.person_outline,
                            label: 'Full Name',
                          ),
                          const SizedBox(height: 16),
                          AuthTextField(
                            controller: emailController,
                            icon: Icons.email_outlined,
                            label: 'Email',
                          ),
                          const SizedBox(height: 16),
                          AuthTextField(
                            controller: passwordController,
                            obscure: true,
                            isPasswordField: true,
                            icon: Icons.lock_outline,
                            label: 'Password',
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 55,
                            width: double.infinity,
                            child: GradientButton(
                              title: 'Sign Up',
                              color: AppPallete.messageColor,
                              onPressed: () {
                                if (emailController.text.isNotEmpty &&
                                    passwordController.text.isNotEmpty &&
                                    nameController.text.isNotEmpty) {
                                  BlocProvider.of<AuthBloc>(context).add(
                                    AuthSignUp(
                                      name: nameController.text.trim(),
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                    ),
                                  );
                                } else {
                                  showSnackBar(
                                    context,
                                    'please enter all fields',
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () => Navigator.pushAndRemoveUntil(
                                    context,
                                    LoginPage.route(),
                                    (_) => false,
                                  ),
                                  child: const Text(
                                    "Log In",
                                    style: TextStyle(
                                      color: AppPallete.messageColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
