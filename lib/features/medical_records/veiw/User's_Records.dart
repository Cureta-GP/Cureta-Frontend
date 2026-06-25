// ignore_for_file: file_names
import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/data/user_records_data.dart';
import 'package:cureta/features/medical_records/data/user_records_models.dart';
import 'package:cureta/features/medical_records/veiw_model/medical_records_cubit.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'package:cureta/features/medical_records/widgets/records_list_body.dart';
import 'package:cureta/features/medical_records/widgets/user_records_top_section.dart';
import 'package:cureta/features/profile/view_model/profile_list_cubit.dart';
import 'package:cureta/features/profile/view_model/profile_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserRecordsView extends StatefulWidget {
  const UserRecordsView({super.key, this.isActive = true});

  final bool isActive;

  @override
  State<UserRecordsView> createState() => _UserRecordsViewState();
}

class _UserRecordsViewState extends State<UserRecordsView> {
  final _searchController = TextEditingController();
  final _filterNotifier = ValueNotifier<String>(UserRecordFilterIds.all);
  String? _lastFetchedProfileId;
  void _fetchIfNeeded(BuildContext context, {bool forceRefresh = false}) {
    if (!widget.isActive) return;
    final profileState = context.read<ProfilesListCubit>().state;
    if (profileState is! ProfilesSuccess ||
        profileState.selectedProfileId == null) {
      return;
    }
    final profileId = profileState.selectedProfileId!;
    if (!forceRefresh && _lastFetchedProfileId == profileId) return;
    _lastFetchedProfileId = profileId;
    context.read<MedicalRecordsCubit>().fetchRecords(
      profileId: profileId,
      forceRefresh: forceRefresh,
    );
  }
  @override
  void dispose() {
    _searchController.dispose();
    _filterNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final filters = localizedUserRecordFilters();
    final hasProfilesCubit = context.read<ProfilesListCubit?>() != null;

    Widget child = BlocProvider(
      create: (_) => getIt<MedicalRecordsCubit>(),
      child: BlocListener<ProfilesListCubit, ProfilesListState>(
        listenWhen: (prev, curr) {
          final prevId = prev is ProfilesSuccess
              ? prev.selectedProfileId
              : null;
          final currId = curr is ProfilesSuccess
              ? curr.selectedProfileId
              : null;
          return prevId != currId && currId != null;
        },
        listener: (context, state) {
          if (state is ProfilesSuccess && state.selectedProfileId != null) {
            _fetchIfNeeded(context, forceRefresh: true);
          }
        },
        child: Builder(
          builder: (context) {
            _fetchIfNeeded(context);
            return Scaffold(
              backgroundColor: colors.background,
              body: SafeArea(
                child: RecordsListBody(
                  topSection: _TopSection(
                    searchController: _searchController,
                    filters: filters,
                    filterNotifier: _filterNotifier,
                  ),
                  searchController: _searchController,
                  filterNotifier: _filterNotifier,
                ),
              ),
            );
          },
        ),
      ),
    );

    if (!hasProfilesCubit) {
      child = BlocProvider(
        create: (_) =>
            ProfilesListCubit(getIt.get<ProfileRepository>())..getProfiles(),
        child: child,
      );
    }
    return child;
  }
}

class _TopSection extends StatelessWidget {
  const _TopSection({
    required this.searchController,
    required this.filters,
    required this.filterNotifier,
  });

  final TextEditingController searchController;
  final List<UserRecordFilter> filters;
  final ValueNotifier<String> filterNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: filterNotifier,
      builder: (context, selectedFilter, _) {
        return UserRecordsTopSection(
          searchController: searchController,
          filters: filters,
          selectedFilterId: selectedFilter,
          onFilterSelected: (id) => filterNotifier.value = id,
        );
      },
    );
  }
}
