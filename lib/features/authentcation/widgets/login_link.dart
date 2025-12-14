// widgets/login_link.dart
import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/utils/navigation_helper.dart';
import 'package:flutter/material.dart';

class LoginLink extends StatelessWidget {
  const LoginLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account? ',
          style: TextStyle(
            color: Color(0xFF495565),
            fontSize: 16,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
        GestureDetector(
          onTap: () {
            Nav.push(context, AppRoutes.login);
          },
          child: const Text(
            'Login',
            style: TextStyle(
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