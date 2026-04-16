import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/profile/data/models/relationship_model.dart';
import 'package:cureta/features/profile/view_model/profile_cubit.dart'; // أضيفي هذا
import 'package:cureta/features/profile/view_model/profile_state.dart'; // أضيفي هذا
import 'package:cureta/features/profile/widgets/icon_text_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

class RelationSelectionStep extends StatelessWidget {
  const RelationSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
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
            
            final isSelected = state.relationship == option.name;

            return IconTextContainer(
              label: option.name,
              iconPath: option.iconPath,
              isSelected: isSelected, 
              onTap: () {
                context.read<ProfileCubit>().updateRelation(option.name);
              },
            );
          },
        );
      },
    );
  }
}