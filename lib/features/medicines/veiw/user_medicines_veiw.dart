import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cureta/features/medicines/veiw_model/user_medicines_cubit.dart';
import 'package:cureta/features/medicines/veiw_model/user_medicines_state.dart';
import 'package:cureta/features/medicines/widgets/medicine_card_widget.dart';
import 'package:cureta/features/medicines/widgets/medicine_empty_state_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

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

class _UserMedicinesVeiwBody extends StatelessWidget {
  const _UserMedicinesVeiwBody();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.chatBackground,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: colors.textPrimary),
          onPressed: () {},
        ),
        title: Text(
          'medicines.my_medicines'.tr(),
          style: context.typography.medicalRecordScreenTitle.copyWith(
            color: colors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: colors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<UserMedicinesCubit, UserMedicinesState>(
        builder: (context, state) {
          return switch (state) {
            UserMedicinesInitial() => const SizedBox.shrink(),
            UserMedicinesLoading() => _buildShimmer(context),
            UserMedicinesLoaded() => _buildList(context, state),
            UserMedicinesError() => _buildError(context, state.messageKey),
            UserMedicinesSyncBanner() => _buildList(
              context,
              state.previousState,
              failedCount: state.failedCount,
            ),
          };
        },
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: FloatingActionButton.extended(
          onPressed: () async {
            await context.push<void>('/medicines/add/1');
            // Refresh the list whether the user pressed back through the
            // steps OR used context.go('/medicines') from the success screen.
            // GoRouter completes the push Future in both cases.
            if (context.mounted) {
              context.read<UserMedicinesCubit>().loadMedicines();
            }
          },
          backgroundColor: colors.primary,
          foregroundColor: colors.background,
          label: Text(
            'medicines.add_medicine'.tr(),
            style: context.typography.medicalRecordButton,
          ),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    final spacing = context.spacing;
    return Shimmer.fromColors(
      baseColor: context.colors.divider,
      highlightColor: context.colors.surface,
      child: ListView.separated(
        padding: EdgeInsetsDirectional.only(
          start: spacing.xl,
          end: spacing.xl,
          top: spacing.md,
          bottom: spacing.xxl * 4,
        ),
        itemCount: 5,
        separatorBuilder: (_, _) => SizedBox(height: spacing.md),
        itemBuilder: (_, _) => Container(
          height: 100,
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(context.radius.lg),
          ),
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    UserMedicinesLoaded state, {
    int? failedCount,
  }) {
    final spacing = context.spacing;

    if (state.filteredMedicines.isEmpty) {
      return MedicineEmptyStateWidget(
        onAddTap: () => context.push('/medicines/add/1'),
      );
    }

    return ListView.separated(
      padding: EdgeInsetsDirectional.only(
        start: spacing.xl,
        end: spacing.xl,
        top: spacing.md,
        bottom: spacing.xxl * 4,
      ),
      itemCount: state.filteredMedicines.length,
      separatorBuilder: (_, _) => SizedBox(height: spacing.md),
      itemBuilder: (context, index) {
        final medicine = state.filteredMedicines[index];
        return MedicineCardWidget(
          medicine: medicine,
          onTap: () {},
          onToggle: (_) {
            context.read<UserMedicinesCubit>().toggleMedicine(medicine.id);
          },
          onDelete: () {
            context.read<UserMedicinesCubit>().deleteMedicine(medicine.id);
          },
        );
      },
    );
  }

  Widget _buildError(BuildContext context, String messageKey) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: context.colors.error),
          SizedBox(height: context.spacing.md),
          Text(
            messageKey.tr(),
            style: context.typography.body.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: context.spacing.lg),
          ElevatedButton(
            onPressed: () {
              context.read<UserMedicinesCubit>().loadMedicines();
            },
            child: Text('medicines.retry'.tr()),
          ),
        ],
      ),
    );
  }
}
