import 'package:cureta/features/medicines/widgets/medicine_list_state_renderer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medicines/veiw_model/user_medicines_cubit.dart';
import 'package:cureta/features/medicines/widgets/medicine_list_controls_widget.dart';
import 'package:cureta/features/medicines/widgets/medicine_screen_app_bar_widget.dart';
import 'package:cureta/features/medicines/veiw_model/user_medicines_state.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:cureta/core/localization/app_localizations.dart';

class UserMedicinesVeiw extends StatelessWidget {
  const UserMedicinesVeiw({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<UserMedicinesCubit>()..init(),
      child: const _UserMedicinesVeiwBody(),
    );
  }
}

class _UserMedicinesVeiwBody extends StatefulWidget {
  const _UserMedicinesVeiwBody();

  @override
  State<_UserMedicinesVeiwBody> createState() => _UserMedicinesVeiwBodyState();
}

class _UserMedicinesVeiwBodyState extends State<_UserMedicinesVeiwBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openAddMedicine() async {
    await context.push<void>('/medicines/add/1');
    if (mounted) {
      context.read<UserMedicinesCubit>().loadMedicines();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.chatBackground,
      appBar: const MedicineScreenAppBarWidget(),
      body: Column(
        children: [
          BlocBuilder<UserMedicinesCubit, UserMedicinesState>(
            buildWhen: (previous, current) {
              if (previous is UserMedicinesLoaded && current is UserMedicinesLoaded) {
                return previous.currentFilter != current.currentFilter;
              }
              return true;
            },
            builder: (context, state) {
              final selectedFilter = state is UserMedicinesLoaded ? state.currentFilter : null;
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
          Expanded(
            child: MedicineListStateRendererWidget(
              onRefresh: () {
                return context.read<UserMedicinesCubit>().loadMedicines();
              },
              onAddTap: _openAddMedicine,
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
      floatingActionButton: Padding(
        padding: EdgeInsetsDirectional.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: FloatingActionButton.extended(
          onPressed: _openAddMedicine,
          backgroundColor: colors.primary,
          foregroundColor: colors.background,
          label: Text(
            AppLocalizations.medicinesAddMedicine,
            style: context.typography.medicalRecordButton,
          ),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
