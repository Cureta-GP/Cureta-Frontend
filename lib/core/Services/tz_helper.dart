/// Initialisation is a no-op — we rely on Android AlarmManager's
/// native UTC handling rather than the timezone package, which
/// requires explicit local-location setup that varies per device.
///
/// The manual-clock-change problem is fully handled on the Android
/// side via BootReceiver (ACTION_TIME_CHANGED / ACTION_TIMEZONE_CHANGED).
Future<void> initializeTimezone() async {
  // intentionally empty — kept so main.dart call site compiles.
}

/// Returns the next wall-clock occurrence of [hour]:[minute]
/// using the device's local time. If the time has already
/// passed today, returns tomorrow at the same time.
DateTime nextTzOccurrence(int hour, int minute, {int? targetWeekday}) {
  final now = DateTime.now();
  var scheduled = DateTime(now.year, now.month, now.day, hour, minute);

  if (targetWeekday != null) {
    while (scheduled.weekday != targetWeekday || !scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  if (!scheduled.isAfter(now)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }
  return scheduled;
}
