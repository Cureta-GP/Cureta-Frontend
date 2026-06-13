class MedicationTimelineModel {
  final String name;
  final String? instruction;
  final int progress;

  const MedicationTimelineModel({
    required this.name,
    this.instruction,
    required this.progress,
  });

  factory MedicationTimelineModel.fromJson(Map<String, dynamic> json) {
    return MedicationTimelineModel(
      name: json['name'] as String,
      instruction: json['instruction'] as String?,
      progress: json['progress'] as int,
    );
  }
}
