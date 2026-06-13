class AdherenceSummaryModel {
  final int activeMeds;
  final int overallPercentage;

  const AdherenceSummaryModel({
    required this.activeMeds,
    required this.overallPercentage,
  });

  factory AdherenceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AdherenceSummaryModel(
      activeMeds: json['active_meds'] as int,
      overallPercentage: json['overall_percentage'] as int,
    );
  }
}
