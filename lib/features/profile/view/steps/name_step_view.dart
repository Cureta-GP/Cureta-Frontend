import 'package:flutter/material.dart';

class NameInputStep extends StatelessWidget {
  const NameInputStep({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        hintText: "Enter full name",
        border: OutlineInputBorder(),
      ),
    );
  }
}
