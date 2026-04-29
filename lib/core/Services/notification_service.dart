import 'dart:developer' as developer;
import 'package:flutter/services.dart';
import 'package:cureta/features/medicines/data/models/medicine_model.dart';
import 'alarm_id_helper.dart';
import 'tz_helper.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static const _channel = MethodChannel('medicine_alarm');

  Future<void> scheduleMedicineAlarms(MedicineModel medicine) async {
    for (var i = 0; i < medicine.alarmTimes.length; i++) {
      final scheduled = _parseTzTime(medicine.alarmTimes[i]);
      if (scheduled == null) continue;

      final id = alarmId(medicine.id, medicine.profileId, i);
      await _invoke('scheduleAlarm', {
        'id': id,
        'local_id': medicine.id,
        'medicine_name': medicine.name,
        'dose_amount':
            '${medicine.doseAmount} ${medicine.doseUnit}'.trim(),
        'image_path': medicine.imagePath ?? '',
        'time_millis': scheduled.millisecondsSinceEpoch,
        'frequency': medicine.frequency.name,
      });
    }
  }

  Future<void> cancelMedicineAlarms(
    String medicineId, {
    String profileId = '',
  }) async {
    for (var i = 0; i < maxAlarmsPerMedicine; i++) {
      await _invoke(
        'cancelAlarm',
        {'id': alarmId(medicineId, profileId, i)},
      );
    }
  }

  Future<void> triggerAlarm(String medicineName) async {
    await _invoke('triggerAlarm', {'medicine_name': medicineName});
  }

  Future<void> stopAlarm() async {
    await _invoke('stopAlarm');
  }

  Future<bool> canScheduleExactAlarms() async {
    try {
      final result =
          await _channel.invokeMethod<bool>('canScheduleExactAlarms');
      return result ?? true;
    } on PlatformException catch (e) {
      developer.log('canScheduleExactAlarms error: $e',
          name: 'NotificationService');
      return true;
    }
  }

  Future<void> openExactAlarmSettings() async {
    await _invoke('openExactAlarmSettings');
  }

  Future<void> rescheduleAllAlarms() async {
    await _invoke('rescheduleAllAlarms');
  }

  /// Parses "HH:mm" and returns the next TZ-aware occurrence.
  DateTime? _parseTzTime(String timeStr) {
    final parts = timeStr.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return nextTzOccurrence(hour, minute);
  }

  Future<void> _invoke(String method, [Map<String, dynamic>? args]) async {
    try {
      await _channel.invokeMethod<void>(method, args);
    } on PlatformException catch (e) {
      developer.log(
        'MethodChannel "$method" failed: ${e.code} — ${e.message}',
        name: 'NotificationService',
      );
    } on MissingPluginException {
      // Running on iOS or a test environment — ignore silently.
    }
  }
}
