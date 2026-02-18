import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class LoginContainer extends StatelessWidget {
  final Widget child;

  const LoginContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final radius = context.radius;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        //color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.xl * 2),
        ),
        shadows: [
          /*BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 50,
            offset: Offset(0, 25),
            spreadRadius: -12,
          ),*/
        ],
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 0),
        decoration: const BoxDecoration(
          /*gradient: LinearGradient(
            begin: Alignment(0.50, 0.00),
            end: Alignment(0.50, 1.00),
            colors: [Colors.white, Colors.white],
          ),*/
        ),
        child: child,
      ),
    );
  }
}
