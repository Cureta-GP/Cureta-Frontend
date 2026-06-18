import 'package:cureta/features/home/data/models/schedule_entry.dart';
import 'package:cureta/features/medicines/data/models/dose_log_model.dart';
import 'package:cureta/features/medicines/data/models/medicine_enums.dart'
    show Frequency;
import 'package:cureta/features/medicines/data/models/medicine_model.dart';
import 'package:cureta/features/medicines/data/repo/medicine_repository.dart';

class ScheduleBuilder {
  const ScheduleBuilder._();

  static Future<List<ScheduleEntry>> buildForDate({
    required MedicineRepository repository,
    required List<MedicineModel> medicines,
    required DateTime date,
    DateTime? referenceNow,
  }) async {
    final now = referenceNow ?? DateTime.now();
    final activeMedicines = medicines
        .where((m) => m.isActive && !m.isPaused && m.alarmTimes.isNotEmpty)
        .toList();

    final entries = <ScheduleEntry>[];

    for (final medicine in activeMedicines) {
      if (!_isScheduledOnDate(medicine, date)) continue;

      final logs = await repository.getMedicineLogs(medicine.id);

      for (final alarm in medicine.alarmTimes) {
        final scheduled = _dateAt(alarm, date);
        if (scheduled == null) continue;

        final status = _resolveStatus(
          scheduled: scheduled,
          logs: logs,
          referenceNow: now,
          selectedDate: date,
        );

        entries.add(
          ScheduleEntry(
            medicineId: medicine.id,
            name: medicine.name,
            scheduledAt: scheduled,
            status: status,
          ),
        );
      }
    }

    entries.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return entries;
  }

  static bool _isScheduledOnDate(MedicineModel medicine, DateTime date) {
    if (!_isOnOrAfterStartDate(medicine, date)) return false;

    return switch (medicine.frequency) {
      Frequency.daily => true,
      Frequency.weekly =>
        _dayOnly(date).weekday == _dayOnly(medicine.startDate.toLocal()).weekday,
      Frequency.asNeeded => false,
    };
  }

  static bool _isOnOrAfterStartDate(MedicineModel medicine, DateTime date) {
    final selectedDay = _dayOnly(date);
    final startDay = _dayOnly(medicine.startDate.toLocal());
    return !selectedDay.isBefore(startDay);
  }

  static DateTime _dayOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static DoseStatus _resolveStatus({
    required DateTime scheduled,
    required List<DoseLogModel> logs,
    required DateTime referenceNow,
    required DateTime selectedDate,
  }) {
    final matchingLogs = logs.where((log) {
      final localScheduled = log.scheduledAt.toLocal();
      final localTaken = log.takenAt?.toLocal();
      final byScheduled = _isLikelySameDoseSlot(localScheduled, scheduled);
      final byTaken = localTaken != null
          ? _isLikelySameDoseSlot(localTaken, scheduled)
          : false;
      return byScheduled || byTaken;
    });

    if (matchingLogs.any((l) => l.status.name == 'taken')) {
      return DoseStatus.taken;
    }

    if (matchingLogs.any((l) => l.status.name == 'missed')) {
      return DoseStatus.missed;
    }

    if (matchingLogs.any((l) => l.status.name == 'pending')) {
      return DoseStatus.pending;
    }

    final selectedDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final today = DateTime(
      referenceNow.year,
      referenceNow.month,
      referenceNow.day,
    );

    if (selectedDay.isAfter(today)) return DoseStatus.pending;
    if (selectedDay.isBefore(today)) return DoseStatus.missed;

    return scheduled.isBefore(referenceNow)
        ? DoseStatus.missed
        : DoseStatus.pending;
  }

  static bool _isLikelySameDoseSlot(DateTime a, DateTime b) {
    final sameLocalDay =
        a.year == b.year && a.month == b.month && a.day == b.day;
    if (!sameLocalDay) return false;
    final diff = a.difference(b).inMinutes.abs();
    return diff <= 90;
  }

  static DateTime? _dateAt(String hhmm, DateTime date) {
    final parts = hhmm.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null || h < 0 || h > 23 || m < 0 || m > 59) {
      return null;
    }
    return DateTime(date.year, date.month, date.day, h, m);
  }
}
