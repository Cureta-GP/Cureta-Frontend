import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

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
  final Set<String> _selectedItems = {};
  final TextEditingController _otherController = TextEditingController();

  List<String> get _items {
    if (widget.type == MedicalConditionType.chronic) {
      return [
        'diabetes',
        'hypertension',
        'heart_disease',
        'asthma',
        'thyroid',
        'arthritis',
        'other',
      ];
    } else {
      return [
        'food',
        'dairy',
        'drug',
        'respiratory',
        'skin',
        'insect',
        'pet',
        'no_allergy',
        'other',
      ];
    }
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  void _toggleItem(String item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        if (item == 'no_allergy') {
          _selectedItems.clear();
          _selectedItems.add(item);
        } else {
          _selectedItems.remove('no_allergy');
          _selectedItems.add(item);
        }
      }
    });
  }

  String _getLocalizedItem(String item) {
    switch (item) {
      case 'diabetes':
        return AppLocalizations.profilesMedicalConditionsDiabetes;
      case 'hypertension':
        return AppLocalizations.profilesMedicalConditionsHypertension;
      case 'heart_disease':
        return AppLocalizations.profilesMedicalConditionsHeartDisease;
      case 'asthma':
        return AppLocalizations.profilesMedicalConditionsAsthma;
      case 'thyroid':
        return AppLocalizations.profilesMedicalConditionsThyroid;
      case 'arthritis':
        return AppLocalizations.profilesMedicalConditionsArthritis;
      case 'food':
        return AppLocalizations.profilesMedicalConditionsFood;
      case 'dairy':
        return AppLocalizations.profilesMedicalConditionsDairy;
      case 'drug':
        return AppLocalizations.profilesMedicalConditionsDrug;
      case 'respiratory':
        return AppLocalizations.profilesMedicalConditionsRespiratory;
      case 'skin':
        return AppLocalizations.profilesMedicalConditionsSkin;
      case 'insect':
        return AppLocalizations.profilesMedicalConditionsInsect;
      case 'pet':
        return AppLocalizations.profilesMedicalConditionsPet;
      case 'no_allergy':
        return AppLocalizations.profilesMedicalConditionsNoAllergy;
      case 'other':
        return AppLocalizations.profilesMedicalConditionsOther;
      default:
        return item;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final radius = context.radius;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._items.map((item) {
            final isSelected = _selectedItems.contains(item);

            return Padding(
              padding: EdgeInsets.only(bottom: spacing.sm),
              child: InkWell(
                onTap: () => _toggleItem(item),
                borderRadius: BorderRadius.circular(radius.md),
                child: Container(
                  padding: EdgeInsets.all(spacing.md),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.primary.withOpacity(0.1)
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
          if (_selectedItems.contains('other')) ...[
            SizedBox(height: spacing.md),
            CustomTextField(
              controller: _otherController,
              hint: AppLocalizations.profilesMedicalConditionsOther,
              label: AppLocalizations.profilesMedicalConditionsOther,
            ),
          ],
          SizedBox(height: spacing.xxl * 4),
        ],
      ),
    );
  }
}
