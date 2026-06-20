import 'dart:convert';
import 'medicine_model.dart';
import 'medicine_enums.dart';

class MedicineDto {
  final String? id;
  final String? profileId;
  final String name;
  final String dose;
  final Frequency frequency;
  final List<String> reminders;
  final bool withFood;
  final String startDate;
  final String? endDate;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;
  final List<Map<String, dynamic>> rawReminders;

  const MedicineDto({
    this.id,
    this.profileId,
    required this.name,
    required this.dose,
    required this.frequency,
    required this.reminders,
    required this.withFood,
    required this.startDate,
    this.endDate,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.rawReminders = const [],
  });

  factory MedicineDto.fromJson(Map<String, dynamic> json) {
    final doseString = json['dose'] as String? ?? '';

    // API returns reminders as either:
    //   • [{"time": "08:00"}, ...]  (current server contract)
    //   • ["08:00", ...]            (legacy / fallback)
    final raw = json['reminders'] as List<dynamic>? ?? [];
    final rawReminders = raw.whereType<Map<String, dynamic>>().toList();
    final remindersList = raw
        .map((e) {
          if (e is Map<String, dynamic>) {
            return e['time']?.toString() ?? '';
          }
          return e.toString();
        })
        .where((t) => t.isNotEmpty)
        .toList();

    return MedicineDto(
      id: json['id']?.toString(),
      profileId: json['profile_id']?.toString(),
      name: json['name'] as String? ?? '',
      dose: doseString,
      frequency: Frequency.fromJson(json['frequency'] as String? ?? 'daily'),
      reminders: remindersList,
      withFood: json['with_food'] as bool? ?? false,
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date']?.toString(),
      notes: json['notes']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      rawReminders: rawReminders,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      'name': name,
      if (dose.isNotEmpty) 'dose': dose,
      'frequency': frequency.toJson(),
      // Serialize back to object form to stay consistent with the API contract.
      'reminders': reminders.map((t) => {'time': t}).toList(),
      'with_food': withFood,
      'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }

  MedicineModel toDomain(
    String localId, {
    SyncStatus syncStatus = SyncStatus.pending,
    String? remoteId,
    String profileId = '',
  }) {
    final doseParts = _parseDose(dose);
    final now = DateTime.now();
    final parsedCreatedAt = DateTime.tryParse(createdAt ?? '');
    final parsedUpdatedAt = DateTime.tryParse(updatedAt ?? '');
    final fallbackCreatedAt = parsedCreatedAt ?? now;
    // If server omits updated_at, avoid "now" to prevent remote stale data overriding local edits.
    final fallbackUpdatedAt =
        parsedUpdatedAt ??
        parsedCreatedAt ??
        DateTime.fromMillisecondsSinceEpoch(0);

    return MedicineModel(
      id: localId,
      profileId: profileId,
      name: name,
      doseForm: DoseForm.pill,
      doseAmount: doseParts['amount'] ?? '',
      doseUnit: doseParts['unit'] ?? '',
      frequency: frequency,
      alarmTimes: reminders,
      startDate: DateTime.tryParse(startDate) ?? now,
      notes: notes,
      isActive: true,
      syncStatus: syncStatus,
      remoteId: remoteId ?? id,
      createdAt: fallbackCreatedAt,
      updatedAt: fallbackUpdatedAt,
    );
  }

  static MedicineDto fromDomain(MedicineModel model, {String? profileId}) {
    final dose = model.doseAmount.isNotEmpty && model.doseUnit.isNotEmpty
        ? '${model.doseAmount} ${model.doseUnit}'
        : model.doseAmount.isNotEmpty
        ? model.doseAmount
        : model.doseUnit;

    return MedicineDto(
      id: model.remoteId,
      profileId: profileId,
      name: model.name,
      dose: dose,
      frequency: model.frequency,
      reminders: model.alarmTimes,
      withFood: false,
      startDate: model.startDate.toIso8601String(),
      endDate: null,
      notes: model.notes,
      createdAt: model.createdAt.toIso8601String(),
      updatedAt: model.updatedAt.toIso8601String(),
    );
  }

  static Map<String, String> _parseDose(String doseString) {
    if (doseString.isEmpty) {
      return {'amount': '', 'unit': ''};
    }

    final regex = RegExp(r'^([\d.]+)\s*(.*)$');
    final match = regex.firstMatch(doseString.trim());

    if (match != null) {
      return {
        'amount': match.group(1) ?? '',
        'unit': match.group(2)?.trim() ?? '',
      };
    }

    return {'amount': '', 'unit': doseString};
  }

  String toJsonString() => jsonEncode(toJson());

  factory MedicineDto.fromJsonString(String jsonString) {
    return MedicineDto.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }
}
