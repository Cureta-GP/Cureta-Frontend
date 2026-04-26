import 'dart:developer' as developer;
import 'package:flutter/services.dart';
import 'package:cureta/features/medicines/data/models/medicine_model.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static const _channel = MethodChannel('medicine_alarm');

  Future<void> scheduleMedicineAlarms(MedicineModel medicine) async {
    for (var i = 0; i < medicine.alarmTimes.length; i++) {
      final timeStr = medicine.alarmTimes[i];
      final scheduled = _nextOccurrence(timeStr);
      if (scheduled == null) continue;

      final id = _alarmId(medicine.id, i);
      await _invoke('scheduleAlarm', {
        'id': id,
        'medicine_name': medicine.name,
        'time_millis': scheduled.millisecondsSinceEpoch,
      });
    }
  }

  Future<void> cancelMedicineAlarms(String medicineId) async {
    for (var i = 0; i < _maxAlarmsPerMedicine; i++) {
      await _invoke('cancelAlarm', {'id': _alarmId(medicineId, i)});
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
      final result = await _channel.invokeMethod<bool>('canScheduleExactAlarms');
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

  static const int _maxAlarmsPerMedicine = 10;

  int _alarmId(String medicineId, int index) {
    final hex = medicineId.replaceAll('-', '');
    final part =
        hex.length >= 8 ? hex.substring(0, 8) : hex.padRight(8, '0');
    final base = int.parse(part, radix: 16) & 0x7FFFFFFF;
    return (base % 100000) * _maxAlarmsPerMedicine + index;
  }

  DateTime? _nextOccurrence(String timeStr) {
    final parts = timeStr.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;

    final now = DateTime.now();
    var scheduled = DateTime(now.year, now.month, now.day, hour, minute);
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
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
