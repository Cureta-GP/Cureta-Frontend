import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class AddMemberCard extends StatelessWidget {
  final VoidCallback onTap;
  const AddMemberCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: colors.primary.withValues(alpha: 0.2),
            style: BorderStyle.solid,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: colors.primary.withValues(alpha: 0.1),
              child: Icon(Icons.add, color: colors.primary, size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              "Add Member",
              style: TextStyle(
                color: colors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
