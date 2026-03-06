import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/profile/view_model/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BloodTypeStep extends StatelessWidget {
  const BloodTypeStep({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProfileCubit>().state;
    final cubit = context.read<ProfileCubit>();
    final types = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.5),
      itemCount: types.length,
      itemBuilder: (context, index) {
        final isSelected = state.bloodType == types[index];
        return GestureDetector(
          onTap: () => cubit.updateBloodType(types[index]),
          child: Container(
            margin: EdgeInsets.all(context.spacing.xs),
            decoration: BoxDecoration(
              color: isSelected ? context.colors.primary : Colors.white,
              borderRadius: BorderRadius.circular(context.radius.md),
              border: Border.all(color: context.colors.primary),
            ),
            alignment: Alignment.center,
            child: Text(types[index], style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
          ),
        );
      },
    );
  }
}