class OcrCreatedMedicine {
  final String id;
  final String name;
  final DateTime createdAt;

  OcrCreatedMedicine({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory OcrCreatedMedicine.fromJson(Map<String, dynamic> json) {
    return OcrCreatedMedicine(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}
