// widgets/signup_header.dart
import 'package:flutter/material.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390,
      padding: const EdgeInsets.only(top: 64, bottom: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Create Account',
            textAlign: TextAlign.center,
            style: TextStyle(
             // color: Color(0xFF133A3E),
              fontSize: 32,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
              height: 1.03,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Join Cureta today',
            textAlign: TextAlign.center,
            style: TextStyle(
              //color: Color(0xFF495565),
              fontSize: 16,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ],
      ),
    );
  }
}