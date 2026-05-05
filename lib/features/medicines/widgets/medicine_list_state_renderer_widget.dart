import 'package:cureta/features/medicines/veiw_model/user_medicines_cubit.dart';
import 'package:cureta/features/medicines/veiw_model/user_medicines_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/features/medicines/widgets/medicine_list_content_widget.dart';
import 'package:cureta/features/medicines/widgets/medicine_list_error_widget.dart';
import 'package:cureta/features/medicines/widgets/medicine_list_shimmer_widget.dart';

class MedicineListStateRendererWidget extends StatelessWidget {
  const MedicineListStateRendererWidget({
    super.key,
    required this.onRefresh,
    required this.onAddTap,
    required this.onToggleMedicine,
    required this.onDeleteMedicine,
    required this.onMedicineTap,
    required this.onRetrySync,
    required this.onRetryLoad,
  });

  final Future<void> Function() onRefresh;
  final VoidCallback onAddTap;
  final ValueChanged<String> onToggleMedicine;
  final ValueChanged<String> onDeleteMedicine;
  final ValueChanged<String> onMedicineTap;
  final VoidCallback onRetrySync;
  final VoidCallback onRetryLoad;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserMedicinesCubit, UserMedicinesState>(
      buildWhen: (prev, curr) {
        // Don't rebuild the entire list for a loading refresh —
        // only rebuild when data actually changed or we transition
        // to/from error/initial.
        if (prev is UserMedicinesLoaded &&
            curr is UserMedicinesLoading &&
            curr.isRefresh) {
          return false;
        }
        return true;
      },
      builder: (context, state) {
        return switch (state) {
          UserMedicinesInitial() => const MedicineListShimmerWidget(),
          UserMedicinesLoading(:final isRefresh) =>
            isRefresh ? const SizedBox.shrink() : const MedicineListShimmerWidget(),
          UserMedicinesLoaded() => MedicineListContentWidget(
            state: state,
            onRefresh: onRefresh,
            onAddTap: onAddTap,
            onToggleMedicine: onToggleMedicine,
            onDeleteMedicine: onDeleteMedicine,
            onMedicineTap: onMedicineTap,
            onRetrySync: onRetrySync,
          ),
          UserMedicinesError() => MedicineListErrorWidget(
            messageKey: state.messageKey,
            onRetry: onRetryLoad,
          ),
          UserMedicinesSyncBanner() => MedicineListContentWidget(
            state: state.previousState,
            failedCount: state.failedCount,
            onRefresh: onRefresh,
            onAddTap: onAddTap,
            onToggleMedicine: onToggleMedicine,
            onDeleteMedicine: onDeleteMedicine,
            onMedicineTap: onMedicineTap,
            onRetrySync: onRetrySync,
          ),
        };
      },
    );
  }
}
