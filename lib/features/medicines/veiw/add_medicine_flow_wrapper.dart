import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Provides a single [AddMedicineCubit] instance to every step (1–5) of the
/// add-medicine flow.  The cubit is created once when the ShellRoute mounts
/// and closed when the user leaves the flow, so form state persists while
/// the user navigates forward and backward through the steps.
class AddMedicineFlowWrapper extends StatefulWidget {
  const AddMedicineFlowWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<AddMedicineFlowWrapper> createState() => _AddMedicineFlowWrapperState();
}

class _AddMedicineFlowWrapperState extends State<AddMedicineFlowWrapper> {
  late final AddMedicineCubit _cubit;

  @override
  void initState() {
    super.initState();
    // Factory registration — creates a fresh instance for every flow session.
    _cubit = getIt<AddMedicineCubit>();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddMedicineCubit>.value(
      value: _cubit,
      child: widget.child,
    );
  }
}
