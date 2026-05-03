enum DoseForm {
  pill,
  liquid,
  injection,
  drops,
  inhaler,
  patch;

  String toJson() => name;

  static DoseForm fromJson(String json) {
    return DoseForm.values.firstWhere(
      (e) => e.name == json,
      orElse: () => DoseForm.pill,
    );
  }
}

enum Frequency {
  daily,
  weekly,
  asNeeded;

  String toJson() => name;

  static Frequency fromJson(String json) {
    return Frequency.values.firstWhere(
      (e) => e.name == json,
      orElse: () => Frequency.daily,
    );
  }
}

enum SyncStatus {
  pending,
  synced,
  failed;

  String toJson() => name;

  static SyncStatus fromJson(String json) {
    return SyncStatus.values.firstWhere(
      (e) => e.name == json,
      orElse: () => SyncStatus.pending,
    );
  }
}

enum DoseStatus {
  taken,
  skipped,
  missed,
  pending;

  String toJson() => name;

  static DoseStatus fromJson(String json) {
    return DoseStatus.values.firstWhere(
      (e) => e.name == json,
      orElse: () => DoseStatus.pending,
    );
  }
}
