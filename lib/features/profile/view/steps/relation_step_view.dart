import 'package:flutter/material.dart';

class RelationSelectionStep extends StatelessWidget {
  const RelationSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: ["Son", "Daughter", "Mother", "Father", "Spouse", "Other"]
          .map((e) => Chip(label: Text(e)))
          .toList(),
    );
  }
}
