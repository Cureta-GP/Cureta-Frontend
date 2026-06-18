import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_cubit.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_state.dart';
import 'package:cureta/features/medicines/widgets/add_medicine_step2_body_widget.dart';

class AddMedicineSecondStepVeiw extends StatelessWidget {
  const AddMedicineSecondStepVeiw({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddMedicineCubit, AddMedicineState>(
      listenWhen: (_, curr) =>
          curr is AddMedicineValidated && curr.stepNumber == 2,
      listener: (context, _) {
        FocusManager.instance.primaryFocus?.unfocus();
        context.push('/medicines/add/3');
      },
      child: const AddMedicineStep2BodyWidget(),
    );
  }
}

