import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medicines/widgets/medicine_filter_choice_chip_widget.dart';
import 'package:cureta/core/localization/app_localizations.dart';

class MedicineListControlsWidget extends StatelessWidget {
  const MedicineListControlsWidget({
    super.key,
    required this.searchController,
    required this.selectedFilter,
    required this.onSearchChanged,
    required this.onFilterChanged,
  });

  final TextEditingController searchController;
  final bool? selectedFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<bool?> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final colors = context.colors;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        spacing.lg,
        spacing.md,
        spacing.lg,
        spacing.sm,
      ),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: AppLocalizations.medicinesSearchHint,
              prefixIcon: Icon(Icons.search, color: colors.icon),
              filled: true,
              fillColor: colors.surface,
              contentPadding: EdgeInsetsDirectional.symmetric(
                horizontal: spacing.lg,
                vertical: spacing.md,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.radius.lg),
                borderSide: BorderSide(color: colors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.radius.lg),
                borderSide: BorderSide(color: colors.primary),
              ),
            ),
          ),
          SizedBox(height: spacing.sm),
          Row(
            children: [
              MedicineFilterChoiceChipWidget(
                label: AppLocalizations.medicinesFilterAll,
                isSelected: selectedFilter == null,
                onTap: () => onFilterChanged(null),
              ),
              SizedBox(width: spacing.sm),
              MedicineFilterChoiceChipWidget(
                label: AppLocalizations.medicinesFilterActive,
                isSelected: selectedFilter == true,
                onTap: () => onFilterChanged(true),
              ),
              SizedBox(width: spacing.sm),
              MedicineFilterChoiceChipWidget(
                label: AppLocalizations.medicinesFilterPaused,
                isSelected: selectedFilter == false,
                onTap: () => onFilterChanged(false),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
