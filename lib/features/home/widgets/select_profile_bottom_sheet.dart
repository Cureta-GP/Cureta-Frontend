import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SelectProfileBottomSheet extends StatelessWidget {
  const SelectProfileBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: spacing.lg),
          Text("Select Profile", style: typography.title),
          Text(
            "Switch between family members to track their progress.",
            style: typography.body.copyWith(color: colors.textSecondary),
          ),
          SizedBox(height: spacing.xl),

          _buildProfileTile(
            context,
            name: "John Doe",
            relation: "Primary Account (You)",
            isSelected: true,
          ),

          SizedBox(height: spacing.xl),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: "Add New Profile",
              onPressed: () {
                GoRouter.of(context).go(AppRoutes.addProfile, extra: true);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTile(
    BuildContext context, {
    required String name,
    required String relation,
    bool isSelected = false,
  }) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected
            ? colors.primary.withOpacity(0.05)
            : Colors.transparent,
        border: Border.all(color: isSelected ? colors.primary : colors.divider),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(relation),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: colors.primary)
            : const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
