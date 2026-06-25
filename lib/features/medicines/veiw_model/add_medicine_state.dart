import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../data/models/drug_interaction_model.dart';
import '../data/models/medicine_model.dart';
import '../data/models/medicine_enums.dart';

sealed class AddMedicineState extends Equatable {
  const AddMedicineState();
}

final class AddMedicineInitial extends AddMedicineState {
  const AddMedicineInitial();
  @override
  List<Object?> get props => [];
}

final class AddMedicineStepUpdated extends AddMedicineState {
  final String medicineName;
  final String? imagePath;
  final DoseForm? doseForm;
  final String doseAmount;
  final String doseUnit;
  final Frequency? frequency;
  final List<TimeOfDay> alarmTimes;
  final DateTime startDate;
  final String notes;
  final Map<String, String> validationErrors;

  const AddMedicineStepUpdated({
    this.medicineName = '',
    this.imagePath,
    this.doseForm,
    this.doseAmount = '',
    this.doseUnit = '',
    this.frequency,
    this.alarmTimes = const [],
    required this.startDate,
    this.notes = '',
    this.validationErrors = const {},
  });

  AddMedicineStepUpdated copyWith({
    String? medicineName,
    String? imagePath,
    DoseForm? doseForm,
    String? doseAmount,
    String? doseUnit,
    Frequency? frequency,
    List<TimeOfDay>? alarmTimes,
    DateTime? startDate,
    String? notes,
    Map<String, String>? validationErrors,
  }) {
    return AddMedicineStepUpdated(
      medicineName: medicineName ?? this.medicineName,
      imagePath: imagePath ?? this.imagePath,
      doseForm: doseForm ?? this.doseForm,
      doseAmount: doseAmount ?? this.doseAmount,
      doseUnit: doseUnit ?? this.doseUnit,
      frequency: frequency ?? this.frequency,
      alarmTimes: alarmTimes ?? this.alarmTimes,
      startDate: startDate ?? this.startDate,
      notes: notes ?? this.notes,
      validationErrors: validationErrors ?? this.validationErrors,
    );
  }

  String get dose => doseAmount.isNotEmpty && doseUnit.isNotEmpty
      ? '$doseAmount $doseUnit'
      : doseAmount.isNotEmpty
      ? doseAmount
      : doseUnit;

  @override
  List<Object?> get props => [
    medicineName,
    imagePath,
    doseForm,
    doseAmount,
    doseUnit,
    frequency,
    alarmTimes,
    startDate,
    notes,
    validationErrors,
  ];
}

final class AddMedicineValidated extends AddMedicineState {
  final int stepNumber;
  final AddMedicineStepUpdated data;

  const AddMedicineValidated({required this.stepNumber, required this.data});

  @override
  List<Object?> get props => [stepNumber, data];
}

final class AddMedicineScanRequested extends AddMedicineState {
  final AddMedicineStepUpdated data;

  const AddMedicineScanRequested({required this.data});

  @override
  List<Object?> get props => [data];
}

final class AddMedicineLoading extends AddMedicineState {
  final AddMedicineStepUpdated data;

  const AddMedicineLoading({required this.data});

  @override
  List<Object?> get props => [data];
}

final class AddMedicineSuccess extends AddMedicineState {
  final MedicineModel medicine;
  final DrugInteractionModel? interactions;

  const AddMedicineSuccess({
    required this.medicine,
    this.interactions,
  });

  @override
  List<Object?> get props => [medicine, interactions];
}

final class AddMedicineFailure extends AddMedicineState {
  final String errorMessage;
  final AddMedicineStepUpdated data;
  final bool isDuplicate;

  const AddMedicineFailure({
    required this.errorMessage,
    required this.data,
    this.isDuplicate = false,
  });

  @override
  List<Object?> get props => [errorMessage, data, isDuplicate];
}
