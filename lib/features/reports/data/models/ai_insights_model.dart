class AiInsightsModel {
  final String status;             // 'STABLE' or 'ALERT'
  final List<String> summary;     // 3 bullet points
  final String correlationWarning;

  const AiInsightsModel({
    required this.status,
    required this.summary,
    required this.correlationWarning,
  });

  factory AiInsightsModel.fromJson(Map<String, dynamic> json) {
    return AiInsightsModel(
      status: json['status'] as String,
      summary: List<String>.from(json['summary'] as List),
      correlationWarning: json['correlation_warning'] as String? ?? '',
    );
  }
}
