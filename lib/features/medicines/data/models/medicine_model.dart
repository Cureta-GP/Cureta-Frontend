import 'package:equatable/equatable.dart';
import 'medicine_enums.dart';

class MedicineModel extends Equatable {
  final String id;
  final String name;
  final DoseForm doseForm;
  final String doseAmount;
  final String doseUnit;
  final Frequency frequency;
  final List<String> alarmTimes;
  final DateTime startDate;
  final String? notes;
  final bool isActive;
  final bool isPaused;
  final SyncStatus syncStatus;
  final String? remoteId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String profileId;
  final String? imagePath;

  const MedicineModel({
    required this.id,
    required this.name,
    required this.doseForm,
    required this.doseAmount,
    required this.doseUnit,
    required this.frequency,
    required this.alarmTimes,
    required this.startDate,
    this.notes,
    this.isActive = true,
    this.isPaused = false,
    this.syncStatus = SyncStatus.pending,
    this.remoteId,
    required this.createdAt,
    required this.updatedAt,
    this.profileId = '',
    this.imagePath,
  });

  MedicineModel copyWith({
    String? id,
    String? name,
    DoseForm? doseForm,
    String? doseAmount,
    String? doseUnit,
    Frequency? frequency,
    List<String>? alarmTimes,
    DateTime? startDate,
    String? notes,
    bool? isActive,
    bool? isPaused,
    SyncStatus? syncStatus,
    String? remoteId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? profileId,
    String? imagePath,
  }) {
    return MedicineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      doseForm: doseForm ?? this.doseForm,
      doseAmount: doseAmount ?? this.doseAmount,
      doseUnit: doseUnit ?? this.doseUnit,
      frequency: frequency ?? this.frequency,
      alarmTimes: alarmTimes ?? this.alarmTimes,
      startDate: startDate ?? this.startDate,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      isPaused: isPaused ?? this.isPaused,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profileId: profileId ?? this.profileId,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    doseForm,
    doseAmount,
    doseUnit,
    frequency,
    alarmTimes,
    startDate,
    notes,
    isActive,
    isPaused,
    syncStatus,
    remoteId,
    createdAt,
    updatedAt,
    profileId,
    imagePath,
  ];
}
