import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/data/user_records_models.dart';
import 'package:cureta/features/medical_records/widgets/user_records_header.dart';
import 'package:cureta/features/medical_records/widgets/user_records_search_and_filters.dart';
import 'package:flutter/material.dart';

class UserRecordsTopSection extends StatelessWidget {
  const UserRecordsTopSection({
    super.key,
    required this.searchController,
    required this.filters,
    required this.selectedFilterId,
    required this.onFilterSelected,
  });

  final TextEditingController searchController;
  final List<UserRecordFilter> filters;
  final String selectedFilterId;
  final ValueChanged<String> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Container(
      color: colors.background,
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.sm,
        spacing.lg,
        spacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserRecordsHeader(title: AppLocalizations.recordsListTitle),
          SizedBox(height: spacing.md),
          UserRecordsSearchAndFilters(
            searchController: searchController,
            searchHint: AppLocalizations.recordsListSearchHint,
            filters: filters,
            selectedFilterId: selectedFilterId,
            onFilterSelected: onFilterSelected,
          ),
        ],
      ),
    );
  }
}
