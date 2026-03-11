import 'package:cureta/features/medical_records/data/utils/records_filter.dart';
import 'package:cureta/features/medical_records/veiw_model/medical_records_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/medical_records_state.dart';
import 'package:cureta/features/medical_records/widgets/records_list_states_view.dart';
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
    required this.topSection,
    required this.searchController,
    required this.filterNotifier,
  });

  final Widget topSection;
  final TextEditingController searchController;
  final ValueNotifier<String> filterNotifier;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicalRecordsCubit, MedicalRecordsState>(
      builder: (context, state) {
        if (state is MedicalRecordsLoading && !state.isRefresh) {
          return RecordsLoadingScroll(topSection: topSection);
        }
        if (state is MedicalRecordsFailure) {
          final profileState = context.read<ProfilesListCubit>().state;
          final profileId = profileState is ProfilesSuccess
              ? profileState.selectedProfileId
              : null;
          return RecordsErrorScroll(
            topSection: topSection,
            errorText: state.error.toString(),
            profileId: profileId,
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
                    return RecordsEmptyScroll(topSection: topSection);
                  }
                  return RecordsSuccessScroll(
                    topSection: topSection,
                    records: visible,
                  );
                },
              );
            },
          );
        }
        return RecordsInitialScroll(topSection: topSection);
      },
    );
  }
}
