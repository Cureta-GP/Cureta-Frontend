import 'package:cureta/features/medicines/widgets/add_medicine_step1_body_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_cubit.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_state.dart';


class AddMedicineFirstStepVeiw extends StatelessWidget {
  const AddMedicineFirstStepVeiw({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocListener handles navigation only — zero builder rebuilds from it.
    return BlocListener<AddMedicineCubit, AddMedicineState>(
      listenWhen: (_, curr) =>
          curr is AddMedicineValidated && curr.stepNumber == 1,
      listener: (context, _) {
        FocusManager.instance.primaryFocus?.unfocus();
        context.push('/medicines/add/2');
      },
      child: const AddMedicineStep1BodyWidget(),
    );
  }
}

