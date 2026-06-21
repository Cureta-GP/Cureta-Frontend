import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/medicines/widgets/medicine_list_state_renderer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medicines/veiw_model/user_medicines_cubit.dart';
import 'package:cureta/features/medicines/widgets/medicine_list_controls_widget.dart';
import 'package:cureta/features/medicines/veiw_model/user_medicines_state.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:cureta/features/profile/view_model/profile_list_cubit.dart';
import 'package:cureta/features/profile/view_model/profile_list_state.dart';
import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/features/medical_records/widgets/user_records_header.dart';

class UserMedicinesVeiw extends StatelessWidget {
  const UserMedicinesVeiw({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<UserMedicinesCubit>()..init(),
      child: const _UserMedicinesBody(),
    );
  }
}

class _UserMedicinesBody extends StatefulWidget {
  const _UserMedicinesBody();
  @override
  State<_UserMedicinesBody> createState() => _UserMedicinesBodyState();
}

class _UserMedicinesBodyState extends State<_UserMedicinesBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openAddMedicine() async {
    await context.pushNamed(AppRoutes.medicinesAddStep1);
    if (mounted) {
      context.read<UserMedicinesCubit>().loadMedicines();
    }
  }

  Future<void> _openMedicineDetails(String medicineId) async {
    await context.pushNamed(
      AppRoutes.medicineDetails,
      pathParameters: {'id': medicineId},
    );
    if (mounted) {
      context.read<UserMedicinesCubit>().loadMedicines();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: BlocListener<ProfilesListCubit, ProfilesListState>(
          listenWhen: (previous, current) {
            if (previous is ProfilesSuccess && current is ProfilesSuccess) {
              return previous.selectedProfileId != current.selectedProfileId;
            }
            return false;
          },
          listener: (context, state) {
            context.read<UserMedicinesCubit>().init();
          },
          child: Column(
            children: [
              UserRecordsHeader(title: AppLocalizations.medicinesMyMedicines),
              SizedBox(height: context.spacing.md),
              // Only rebuilds when currentFilter changes
              BlocSelector<UserMedicinesCubit, UserMedicinesState, bool?>(
                selector: (state) =>
                    state is UserMedicinesLoaded ? state.currentFilter : null,
                builder: (context, selectedFilter) {
                  return MedicineListControlsWidget(
                    searchController: _searchController,
                    selectedFilter: selectedFilter,
                    onSearchChanged: (query) {
                      context.read<UserMedicinesCubit>().searchByName(query);
                    },
                    onFilterChanged: (value) {
                      context.read<UserMedicinesCubit>().filterByStatus(value);
                    },
                  );
                },
              ),
              // Only rebuilds when medicines list or sync state changes
              Expanded(
                child: MedicineListStateRendererWidget(
                  onRefresh: () {
                    return context.read<UserMedicinesCubit>().loadMedicines();
                  },
                  onAddTap: _openAddMedicine,
                  onMedicineTap: _openMedicineDetails,
                  onToggleMedicine: (id) {
                    context.read<UserMedicinesCubit>().toggleMedicine(id);
                  },
                  onDeleteMedicine: (id) {
                    context.read<UserMedicinesCubit>().deleteMedicine(id);
                  },
                  onRetrySync: () {
                    context.read<UserMedicinesCubit>().syncPendingMedicines();
                  },
                  onRetryLoad: () {
                    context.read<UserMedicinesCubit>().loadMedicines();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
