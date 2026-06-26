import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_cubit.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_state.dart';
import 'package:cureta/features/medicines/widgets/add_medicine_step4_body_widget.dart';
import 'package:cureta/features/medicines/widgets/drug_interaction_dialog.dart';

class AddMedicineFourthStepVeiw extends StatelessWidget {
  const AddMedicineFourthStepVeiw({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddMedicineCubit, AddMedicineState>(
          listenWhen: (_, curr) => curr is AddMedicineSuccess,
          listener: (context, state) async {
            if (state is! AddMedicineSuccess) return;
            FocusManager.instance.primaryFocus?.unfocus();

            // Show interaction warning if the backend flagged conflicts.
            final interactions = state.interactions;
            if (interactions != null &&
                interactions.hasInteraction &&
                interactions.interactions.isNotEmpty) {
              await showDrugInteractionDialog(
                context,
                interactions: interactions,
              );
            }

            if (!context.mounted) return;
            context.push('/medicines/add/5');
          },
        ),
        BlocListener<AddMedicineCubit, AddMedicineState>(
          listenWhen: (_, curr) => curr is AddMedicineFailure,
          listener: (context, state) {
            if (state is AddMedicineFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage.tr()),
                  backgroundColor: context.colors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
      ],
      child: const AddMedicineStep4BodyWidget(),
    );
  }
}


