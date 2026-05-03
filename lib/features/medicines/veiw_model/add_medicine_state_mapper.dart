import 'add_medicine_state.dart';

extension AddMedicineStateMapper on AddMedicineState {
  AddMedicineStepUpdated get formData {
    return switch (this) {
      AddMedicineInitial() => AddMedicineStepUpdated(startDate: DateTime.now()),
      AddMedicineStepUpdated data => data,
      AddMedicineValidated data => data.data,
      AddMedicineScanRequested data => data.data,
      AddMedicineLoading data => data.data,
      AddMedicineFailure data => data.data,
      AddMedicineSuccess() => AddMedicineStepUpdated(startDate: DateTime.now()),
    };
  }
}
