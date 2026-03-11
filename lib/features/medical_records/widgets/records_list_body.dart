import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/data/utils/records_filter.dart';
import 'package:cureta/features/medical_records/veiw_model/medical_records_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/medical_records_state.dart';
import 'package:cureta/features/medical_records/widgets/records_error_view.dart';
import 'package:cureta/features/medical_records/widgets/shimmer_record_card.dart';
import 'package:cureta/features/medical_records/widgets/user_record_card.dart';
import 'package:cureta/features/profile/view_model/profile_list_cubit.dart';
import 'package:cureta/features/profile/view_model/profile_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Separated widget so that BlocBuilder only rebuilds this part,
/// not the search bar or filter chips above.
/// Uses ValueListenableBuilder on search text to avoid setState.
class RecordsListBody extends StatelessWidget {
  const RecordsListBody({
    super.key,
    required this.searchController,
    required this.filterNotifier,
  });

  final TextEditingController searchController;
  final ValueNotifier<String> filterNotifier;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return BlocBuilder<MedicalRecordsCubit, MedicalRecordsState>(
      builder: (context, state) {
        if (state is MedicalRecordsLoading && !state.isRefresh) {
          return const ShimmerRecordsList();
        }
        if (state is MedicalRecordsFailure) {
          final profileState = context.read<ProfilesListCubit>().state;
          final profileId = profileState is ProfilesSuccess
              ? profileState.selectedProfileId
              : null;
          return RecordsErrorView(
            error: state.error.toString(),
            onRetry: profileId != null
                ? () => context.read<MedicalRecordsCubit>().fetchRecords(
                    profileId: profileId,
                    forceRefresh: true,
                  )
                : null,
          );
        }
        if (state is MedicalRecordsSuccess) {
          return ValueListenableBuilder<String>(
            valueListenable: filterNotifier,
            builder: (context, selectedFilter, _) {
              return ValueListenableBuilder<TextEditingValue>(
                valueListenable: searchController,
                builder: (context, searchValue, _) {
                  final visible = RecordsFilter.apply(
                    records: state.records,
                    filterId: selectedFilter,
                    query: searchValue.text,
                  );

                  if (visible.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(spacing.xl),
                        child: Text(
                          'No records found',
                          style: context.typography.medicalRecordHelper
                              .copyWith(color: colors.textSecondary),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    key: const PageStorageKey('userRecordsList'),
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    cacheExtent: 250,
                    padding: EdgeInsets.fromLTRB(
                      spacing.lg,
                      spacing.lg,
                      spacing.lg,
                      spacing.xxl * 2,
                    ),
                    itemCount: visible.length,
                    itemBuilder: (context, index) {
                      final record = visible[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: spacing.lg),
                        child: UserRecordCard(
                          key: ValueKey(record.id),
                          record: record,
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        }
        return const ShimmerRecordsList();
      },
    );
  }
}
