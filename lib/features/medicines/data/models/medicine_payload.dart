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
  final String? imagePath;
  final String? language;

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
    this.imagePath,
    this.language,
  });

  Map<String, dynamic> toJson({bool includeReminders = true}) {
    final formattedStart = startDate.contains('T') ? startDate.split('T')[0] : startDate;
    final formattedEnd = (endDate != null && endDate!.contains('T')) ? endDate!.split('T')[0] : endDate;

    return {
      if (profileId != null) 'profile_id': profileId,
      'name': name,
      if (dose.isNotEmpty) 'dose': dose,
      'frequency': frequency.toJson(),
      if (includeReminders) 'reminders': reminders.map((t) => {'time': t}).toList(),
      'start_date': formattedStart,
      if (formattedEnd != null) 'end_date': formattedEnd,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
      if (imagePath != null && imagePath!.isNotEmpty) 'image_path': imagePath,
      if (doseForm != null) 'dose_form': doseForm!.toJson(),
      if (language != null) 'language': language,
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
    imagePath,
    language,
  ];
}
