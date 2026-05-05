import 'package:cureta/features/medicines/veiw_model/add_medicine_state_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_cubit.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_state.dart';

/// Generic validation error row — rebuilds only when [fieldKey]'s error changes.
/// Uses [AppLocalizations.dynamicTr] for l10n key resolution.
class MedicineValidationErrorWidget extends StatelessWidget {
  const MedicineValidationErrorWidget({
    super.key,
    required this.fieldKey,
    this.useTrExtension = false,
  });

  final String fieldKey;

  /// If true, translates via `.tr()` extension (easy_localization).
  /// If false, uses [AppLocalizations.dynamicTr].
  final bool useTrExtension;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;
    final spacing = context.spacing;

    return BlocSelector<AddMedicineCubit, AddMedicineState, String?>(
      selector: (state) => state.formData.validationErrors[fieldKey],
      builder: (context, error) {
        if (error == null) return const SizedBox.shrink();
        final text = useTrExtension
            ? error // caller can wrap with .tr() themselves if needed
            : AppLocalizations.dynamicTr(error);
        return Padding(
          padding: EdgeInsetsDirectional.only(top: spacing.sm),
          child: AnimatedSwitcher(
            duration: context.durations.fast,
            child: Text(
              text,
              key: ValueKey(error),
              style: typography.label.copyWith(color: colors.error),
            ),
          ),
        );
      },
    );
  }
}
