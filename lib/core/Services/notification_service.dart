import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:cureta/features/medicines/data/models/medicine_model.dart';
import 'package:cureta/core/Services/GetItServices.dart' as get_it_services;
import 'alarm_id_helper.dart';
import 'tz_helper.dart';
import 'package:cureta/features/medicines/data/models/medicine_enums.dart';
import 'package:cureta/features/medicines/data/repo/medicine_repository.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static const _channel = MethodChannel('medicine_alarm');
  final _alarmActionsSyncedController = StreamController<void>.broadcast();

  Stream<void> get alarmActionsSynced => _alarmActionsSyncedController.stream;

  void initCallHandler() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onAlarmAction') {
        final args = Map<String, dynamic>.from(call.arguments as Map);
        final action = args['action'] as String?;
        final localId = args['local_id'] as String?;
        final remoteId = args['remote_id'] as String?;
        final scheduledAtMillis = (args['scheduled_at_millis'] as num?)
            ?.toInt();
        final scheduledAt = scheduledAtMillis == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                scheduledAtMillis,
                isUtc: true,
              );
        if (action != null && localId != null) {
          await _handleAlarmAction(
            localId,
            action,
            remoteId: remoteId,
            scheduledAt: scheduledAt,
          );
        }
      }
    });
    _consumePendingAlarmActions().ignore();
  }

  Future<void> _handleAlarmAction(
    String localId,
    String action, {
    String? remoteId,
    DateTime? scheduledAt,
  }) async {
    try {
      final repo = get_it_services.getIt<MedicineRepository>();
      await repo.logMedicationAction(
        localId,
        action,
        remoteId: remoteId,
        scheduledAt: scheduledAt,
      );
      if (!_alarmActionsSyncedController.isClosed) {
        _alarmActionsSyncedController.add(null);
      }
    } catch (e) {
      developer.log(
        'Failed to handle alarm action: $e',
        name: 'NotificationService',
      );
    }
  }

  Future<void> _consumePendingAlarmActions() async {
    try {
      final pending = await _channel.invokeMethod<List<dynamic>>(
        'consumePendingAlarmActions',
      );
      if (pending == null || pending.isEmpty) return;
      developer.log(
        'Found ${pending.length} pending alarm action(s) to sync',
        name: 'NotificationService',
      );
      for (final item in pending) {
        if (item is! Map) continue;
        final map = Map<String, dynamic>.from(item);
        final action = map['action'] as String?;
        final localId = map['local_id'] as String?;
        final remoteId = map['remote_id'] as String?;
        final scheduledAtMillis = (map['scheduled_at_millis'] as num?)?.toInt();
        final scheduledAt = scheduledAtMillis == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                scheduledAtMillis,
                isUtc: true,
              );
        if (action == null || localId == null) continue;
        developer.log(
          'Sync pending alarm action: action=$action, local_id=$localId, remote_id=$remoteId, scheduled_at_millis=$scheduledAtMillis',
          name: 'NotificationService',
        );
        await _handleAlarmAction(
          localId,
          action,
          remoteId: remoteId,
          scheduledAt: scheduledAt,
        );
      }

      // Also try to sync any previously queued dose logs
      final repo = get_it_services.getIt<MedicineRepository>();
      repo.syncPendingDoseLogs().ignore();
    } on PlatformException catch (e) {
      developer.log(
        'consumePendingAlarmActions failed: ${e.code} — ${e.message}',
        name: 'NotificationService',
      );
    } on MissingPluginException {
      // Running on iOS or a test environment — ignore silently.
    }
  }

  Future<void> syncPendingAlarmActions() async {
    await _consumePendingAlarmActions();
  }

  Future<void> scheduleMedicineAlarms(MedicineModel medicine) async {
    if (medicine.frequency == Frequency.asNeeded) return;

    for (var i = 0; i < medicine.alarmTimes.length; i++) {
      int? targetWeekday;
      if (medicine.frequency == Frequency.weekly) {
        targetWeekday = medicine.startDate.toLocal().weekday;
      }
      
      final scheduled = _parseTzTime(medicine.alarmTimes[i], targetWeekday: targetWeekday);
      if (scheduled == null) continue;

      final id = alarmId(medicine.id, medicine.profileId, i);
      await _invoke('scheduleAlarm', {
        'id': id,
        'local_id': medicine.id,
        'remote_id': medicine.remoteId ?? '',
        'medicine_name': medicine.name,
        'dose_amount': '${medicine.doseAmount} ${medicine.doseUnit}'.trim(),
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
      await _invoke('cancelAlarm', {'id': alarmId(medicineId, profileId, i)});
    }
  }

  /// Cancels every scheduled medicine alarm and clears the native alarm
  /// registry. Call this on logout so the previous user's reminders never
  /// fire again (and are not resurrected after a device reboot).
  Future<void> cancelAllAlarms() async {
    await _invoke('cancelAllAlarms');
  }

  Future<void> triggerAlarm(String medicineName) async {
    await _invoke('triggerAlarm', {'medicine_name': medicineName});
  }

  Future<void> stopAlarm() async {
    await _invoke('stopAlarm');
  }

  Future<bool> canScheduleExactAlarms() async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'canScheduleExactAlarms',
      );
      return result ?? true;
    } on PlatformException catch (e) {
      developer.log(
        'canScheduleExactAlarms error: $e',
        name: 'NotificationService',
      );
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
  DateTime? _parseTzTime(String timeStr, {int? targetWeekday}) {
    final parts = timeStr.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return nextTzOccurrence(hour, minute, targetWeekday: targetWeekday);
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
