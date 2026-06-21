import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_cubit.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_state.dart';
import 'package:cureta/features/medicines/widgets/add_medicine_step3_body_widget.dart';

class AddMedicineThirdStepVeiw extends StatelessWidget {
  const AddMedicineThirdStepVeiw({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddMedicineCubit, AddMedicineState>(
      listenWhen: (_, curr) =>
          curr is AddMedicineValidated && curr.stepNumber == 3,
      listener: (context, _) {
        FocusManager.instance.primaryFocus?.unfocus();
        context.push('/medicines/add/4');
      },
      child: const AddMedicineStep3BodyWidget(),
    );
  }
}
