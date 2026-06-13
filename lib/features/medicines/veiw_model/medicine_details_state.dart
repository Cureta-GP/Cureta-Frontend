import 'package:equatable/equatable.dart';
import '../data/models/medicine_model.dart';
import '../data/models/dose_log_model.dart';

enum MedicineBusyMode {
  none,
  saving,
  deleting;

  bool get isActive => this != MedicineBusyMode.none;

  String? get lottiePath => switch (this) {
        saving => 'assets/animations/Update Successfully.json',
        deleting => 'assets/animations/Deleted Successfully.json',
        none => null,
      };
}

sealed class MedicineDetailsState extends Equatable {
  const MedicineDetailsState();

  @override
  List<Object?> get props => [];
}

class MedicineDetailsInitial extends MedicineDetailsState {
  const MedicineDetailsInitial();
}

class MedicineDetailsLoading extends MedicineDetailsState {
  const MedicineDetailsLoading();
}

class MedicineDetailsLoaded extends MedicineDetailsState {
  final MedicineModel medicine;
  final List<DoseLogModel> logs;
  final bool isEditing;
  final MedicineBusyMode busyMode;

  const MedicineDetailsLoaded({
    required this.medicine,
    this.logs = const [],
    this.isEditing = false,
    this.busyMode = MedicineBusyMode.none,
  });

  @override
  List<Object?> get props => [medicine, logs, isEditing, busyMode];

  MedicineDetailsLoaded copyWith({
    MedicineModel? medicine,
    List<DoseLogModel>? logs,
    bool? isEditing,
    MedicineBusyMode? busyMode,
  }) {
    return MedicineDetailsLoaded(
      medicine: medicine ?? this.medicine,
      logs: logs ?? this.logs,
      isEditing: isEditing ?? this.isEditing,
      busyMode: busyMode ?? this.busyMode,
    );
  }
}

class MedicineDetailsError extends MedicineDetailsState {
  final String messageKey;

  const MedicineDetailsError(this.messageKey);

  @override
  List<Object?> get props => [messageKey];
}
