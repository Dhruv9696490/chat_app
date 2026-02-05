import 'package:chat_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final IconData icon;
  final String label;
  final bool isPasswordField;
  final bool obscure;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.icon,
    required this.label,
    this.isPasswordField = false,
    this.obscure = false ,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style:const TextStyle(
        color: Colors.black
      ),
      controller: widget.controller,
      obscureText: widget.isPasswordField ? obscure : false,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppPallete.messageColor,width: 1.5)
        ),
        prefixIcon: Icon(widget.icon,color: Colors.black87,),
        labelText: widget.label,
        labelStyle: const TextStyle(color: AppPallete.backgroundColor),
        suffixIcon: widget.isPasswordField
            ? IconButton(
          icon: Icon(
            !obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
                color: Colors.black87,
          ),
          onPressed: () {
            setState(() {
              obscure = !obscure;
            });
          },
        )
            : null,
      ),
    );
  }
}
