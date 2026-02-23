import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/profile/model/relationship_model.dart';
import 'package:cureta/features/profile/widgets/icon_text_container.dart';
import 'package:flutter/material.dart';

class RelationSelectionStep extends StatelessWidget {
  const RelationSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return GridView.builder(
      itemCount: relationshipOptions.length,
      padding: EdgeInsets.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.md,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: spacing.md,
        crossAxisSpacing: spacing.md,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final option = relationshipOptions[index];

        return IconTextContainer(
          label: option.name,
          iconPath: option.iconPath,

          onTap: () {},
        );
      },
    );
  }
}
