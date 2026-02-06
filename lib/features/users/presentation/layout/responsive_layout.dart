import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget web;
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.web,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        if (constraint.maxWidth > 862) {
          return web;
        }
        return mobile;
      },
    );
  }
}
