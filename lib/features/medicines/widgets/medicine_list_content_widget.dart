import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medicines/data/models/medicine_model.dart';
import 'package:cureta/features/medicines/widgets/medicine_card_widget.dart';
import 'package:cureta/features/medicines/widgets/medicine_empty_state_widget.dart';
import 'package:cureta/features/medicines/widgets/medicine_sync_banner_widget.dart';
import 'package:cureta/features/medicines/veiw_model/user_medicines_state.dart';
import 'package:flutter/material.dart';

class MedicineListContentWidget extends StatelessWidget {
  const MedicineListContentWidget({
    super.key,
    required this.state,
    required this.onRefresh,
    required this.onAddTap,
    required this.onToggleMedicine,
    required this.onDeleteMedicine,
    required this.onRetrySync,
    this.failedCount,
  });

  final UserMedicinesLoaded state;
  final Future<void> Function() onRefresh;
  final VoidCallback onAddTap;
  final ValueChanged<String> onToggleMedicine;
  final ValueChanged<String> onDeleteMedicine;
  final VoidCallback onRetrySync;
  final int? failedCount;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final showSyncBanner = failedCount != null && failedCount! > 0;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: state.filteredMedicines.isEmpty
          ? ListView(
              padding: EdgeInsetsDirectional.only(
                start: spacing.xl,
                end: spacing.xl,
                top: spacing.md,
                bottom: spacing.xxl * 4,
              ),
              children: [
                if (showSyncBanner)
                  MedicineSyncBannerWidget(
                    failedCount: failedCount!,
                    onRetry: onRetrySync,
                  ),
                MedicineEmptyStateWidget(onAddTap: onAddTap),
              ],
            )
          : ListView.separated(
              padding: EdgeInsetsDirectional.only(
                start: spacing.xl,
                end: spacing.xl,
                top: spacing.md,
                bottom: spacing.xxl * 4,
              ),
              itemCount:
                  state.filteredMedicines.length + (showSyncBanner ? 1 : 0),
              separatorBuilder: (_, _) => SizedBox(height: spacing.md),
              itemBuilder: (context, index) {
                if (showSyncBanner && index == 0) {
                  return MedicineSyncBannerWidget(
                    failedCount: failedCount!,
                    onRetry: onRetrySync,
                  );
                }
                final offset = showSyncBanner ? 1 : 0;
                final MedicineModel medicine =
                    state.filteredMedicines[index - offset];
                return MedicineCardWidget(
                  medicine: medicine,
                  onTap: () {},
                  onToggle: (_) => onToggleMedicine(medicine.id),
                  onDelete: () => onDeleteMedicine(medicine.id),
                );
              },
            ),
    );
  }
}
