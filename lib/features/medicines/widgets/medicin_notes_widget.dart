import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Notes text field — pure input, no Bloc dependency.
class MedicineNotesFieldWidget extends StatelessWidget {
  const MedicineNotesFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radius;

    return TextField(
      maxLines: 4,
      onChanged: (v) => context.read<AddMedicineCubit>().updateNotes(v),
      decoration: InputDecoration(
        hintText: 'medicines.notes_hint'.tr(),
        suffixIcon: Icon(Icons.edit_note, color: colors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.md),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.md),
          borderSide: BorderSide(color: colors.primary),
        ),
      ),
    );
  }
}