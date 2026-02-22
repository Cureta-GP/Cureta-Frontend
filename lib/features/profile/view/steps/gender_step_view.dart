import 'package:flutter/material.dart';

class GenderSelectionStep extends StatelessWidget {
  const GenderSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
       
      children: [
        
        ListTile(title: const Text("Male"), leading: Radio<int>(value: 1, groupValue: 1, onChanged: (v) {})),
        ListTile(title: const Text("Female"), leading: Radio<int>(value: 2, groupValue: 1, onChanged: (v) {})),
      ],
    );
  }
}
