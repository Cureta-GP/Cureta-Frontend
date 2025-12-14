// widgets/login_link.dart
import 'package:flutter/material.dart';

class Link extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback? onTap;

  const Link({
    super.key,
    required this.text,
    required this.actionText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          /*style: const TextStyle(
            color: Color(0xFF495565),
            fontSize: 16,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),*/
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: const TextStyle(
              color: Color(0xFF00A1A9),
              fontSize: 16,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w700,
              height: 1.50,
            ),
          ),
        ),
      ],
    );
  }
}
