import 'package:equatable/equatable.dart';
import 'medicine_enums.dart';

class MedicinePayload extends Equatable {
  final String? profileId;
  final String name;
  final String dose;
  final Frequency frequency;
  final List<String> reminders;
  final String startDate;
  final String? endDate;
  final String? notes;
  final DoseForm? doseForm;

  const MedicinePayload({
    this.profileId,
    required this.name,
    required this.dose,
    required this.frequency,
    required this.reminders,
    required this.startDate,
    this.endDate,
    this.notes,
    this.doseForm,
  });

  Map<String, dynamic> toJson() {
    return {
      if (profileId != null) 'profile_id': profileId,
      'name': name,
      if (dose.isNotEmpty) 'dose': dose,
      'frequency': frequency.toJson(),
      // API expects an array of objects: [{"time": "HH:MM"}, ...]
      'reminders': reminders.map((t) => {'time': t}).toList(),
      'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }

  @override
  List<Object?> get props => [
    profileId,
    name,
    dose,
    frequency,
    reminders,
    startDate,
    endDate,
    notes,
    doseForm,
  ];
}
