import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/data/user_records_models.dart';
import 'package:cureta/features/medical_records/widgets/user_records_filter_chip.dart';
import 'package:cureta/features/medical_records/widgets/user_records_search_bar.dart';
import 'package:flutter/material.dart';

class UserRecordsSearchAndFilters extends StatelessWidget {
  const UserRecordsSearchAndFilters({
    super.key,
    required this.searchController,
    required this.searchHint,
    required this.filters,
    required this.selectedFilterId,
    required this.onFilterSelected,
    this.onFilterTap,
  });

  final TextEditingController searchController;
  final String searchHint;
  final List<UserRecordFilter> filters;
  final String selectedFilterId;
  final ValueChanged<String> onFilterSelected;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserRecordsSearchBar(
            controller: searchController,
            hint: searchHint,
            onFilterTap: onFilterTap,
          ),
          SizedBox(height: spacing.lg),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters
                  .map(
                    (filter) => Padding(
                      padding: EdgeInsets.only(right: spacing.md),
                      child: UserRecordsFilterChip(
                        label: filter.label,
                        selected: selectedFilterId == filter.id,
                        onTap: () => onFilterSelected(filter.id),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
    );
  }
}
