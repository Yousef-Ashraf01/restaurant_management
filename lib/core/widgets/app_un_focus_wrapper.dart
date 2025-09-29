import 'package:flutter/material.dart';

class AppUnfocusWrapper extends StatelessWidget {
  final Widget child;
  const AppUnfocusWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: child,
    );
  }
}
