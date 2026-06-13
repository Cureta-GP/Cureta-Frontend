import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/profile/data/models/allergy_option.dart';
import 'package:cureta/features/profile/data/models/chronic_disease_option.dart';
import 'package:cureta/features/profile/view_model/profile_cubit.dart';
import 'package:cureta/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MedicalConditionType { chronic, allergy }

class MedicalConditionsStep extends StatefulWidget {
  final MedicalConditionType type;

  const MedicalConditionsStep({
    super.key,
    this.type = MedicalConditionType.chronic,
  });

  @override
  State<MedicalConditionsStep> createState() => _MedicalConditionsStepState();
}

class _MedicalConditionsStepState extends State<MedicalConditionsStep> {
  final TextEditingController _otherController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileCubit>().state;
    _otherController.text = widget.type == MedicalConditionType.chronic
        ? state.otherChronicText
        : state.otherAllergyText;
  }

  List<String> get _items {
    if (widget.type == MedicalConditionType.chronic) {
      return ChronicDiseaseOption.values.map((e) => e.backendName).toList();
    } else {
      return AllergyOption.values.map((e) => e.backendName).toList();
    }
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  void _toggleItem(String item) {
    final cubit = context.read<ProfileCubit>();
    if (widget.type == MedicalConditionType.chronic) {
      cubit.toggleChronic(item);
    } else {
      cubit.toggleAllergy(item);
    }
  }

  String _getLocalizedItem(String item) {
    if (widget.type == MedicalConditionType.chronic) {
      return ChronicDiseaseOptionX.fromBackendName(item)?.localizedName ?? item;
    }
    return AllergyOptionX.fromBackendName(item)?.localizedName ?? item;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final radius = context.radius;
    final state = context.watch<ProfileCubit>().state;
    final selectedItems = widget.type == MedicalConditionType.chronic
        ? state.chronicConditions
        : state.allergies;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._items.map((item) {
            final isSelected = selectedItems.contains(item);

            return Padding(
              padding: EdgeInsets.only(bottom: spacing.sm),
              child: InkWell(
                onTap: () => _toggleItem(item),
                borderRadius: BorderRadius.circular(radius.md),
                child: Container(
                  padding: EdgeInsets.all(spacing.md),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.primary.withValues(alpha: 0.1)
                        : colors.background,
                    borderRadius: BorderRadius.circular(radius.md),
                    border: Border.all(
                      color: isSelected ? colors.primary : colors.divider,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getLocalizedItem(item),
                          style: typography.medicalRecordChoice.copyWith(
                            color: isSelected
                                ? colors.primary
                                : colors.textPrimary,
                          ),
                        ),
                      ),
                      Checkbox(
                        value: isSelected,
                        onChanged: (_) => _toggleItem(item),
                        activeColor: colors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(radius.sm),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          if (selectedItems.contains('other')) ...[
            SizedBox(height: spacing.md),
            CustomTextField(
              controller: _otherController,
              hint: AppLocalizations.profilesMedicalConditionsOther,
              label: AppLocalizations.profilesMedicalConditionsOther,
              onChanged: (val) {
                if (widget.type == MedicalConditionType.chronic) {
                  context.read<ProfileCubit>().updateOtherChronicText(val);
                } else {
                  context.read<ProfileCubit>().updateOtherAllergyText(val);
                }
              },
            ),
          ],
          SizedBox(height: spacing.xxl * 4),
        ],
      ),
    );
  }
}
