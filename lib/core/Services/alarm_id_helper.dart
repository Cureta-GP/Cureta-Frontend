/// Maximum number of alarm slots per medicine.
const int maxAlarmsPerMedicine = 10;

/// Generates a unique, deterministic alarm ID from [medicineId],
/// [profileId], and the alarm [index].
///
/// Uses the first 8 hex chars of medicineId XOR'd with a hash of
/// profileId to keep the value stable across Dart VM restarts
/// (unlike String.hashCode which is not guaranteed to be stable).
int alarmId(String medicineId, String profileId, int index) {
  // Stable hex-based hash from medicineId (same algorithm as before).
  final hex = medicineId.replaceAll('-', '');
  final part = hex.length >= 8 ? hex.substring(0, 8) : hex.padRight(8, '0');
  final base = int.parse(part, radix: 16) & 0x7FFFFFFF;

  // XOR with a simple stable hash of profileId to separate profiles.
  int profileHash = 0;
  for (final ch in profileId.codeUnits) {
    profileHash = (profileHash * 31 + ch) & 0x7FFFFFFF;
  }

  final combined = (base ^ profileHash) & 0x7FFFFFFF;
  return (combined % 100000) * maxAlarmsPerMedicine + index;
}
