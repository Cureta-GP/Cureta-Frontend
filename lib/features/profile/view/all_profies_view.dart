import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/profile/model/relationship_model.dart';
import 'package:cureta/features/profile/widgets/add_member_card.dart';
import 'package:cureta/features/profile/widgets/icon_text_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AllProfiesView extends StatelessWidget {
  const AllProfiesView({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final typography = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: spacing.lg, top: spacing.md),
          child: Text(
            "FAMILY PROFILES",
            style: typography.homeWelcomeBack.copyWith(
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: context.colors.textSecondary.withOpacity(0.7),
            ),
          ),
        ),

        Expanded(
          child: GridView.builder(
            itemCount: familyProfiles.length + 1,
            padding: EdgeInsets.all(spacing.lg),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: spacing.md,
              crossAxisSpacing: spacing.md,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              if (index < familyProfiles.length) {
                final option = familyProfiles[index];
                return IconTextContainer(
                  label: option.name,
                  iconPath: option.iconPath,
                  onTap: () {},
                );
              } else {
                return AddMemberCard(
                  onTap: () {
                    GoRouter.of(context).go(AppRoutes.addProfile);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
