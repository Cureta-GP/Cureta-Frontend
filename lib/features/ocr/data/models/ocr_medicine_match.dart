class OcrMedicineMatch {
  final String original;
  final String? corrected; // nullable
  final bool found;

  OcrMedicineMatch({
    required this.original,
    required this.corrected,
    required this.found,
  });

  factory OcrMedicineMatch.fromJson(Map<String, dynamic> json) {
    return OcrMedicineMatch(
      original: json['original'] ?? '',
      corrected: json['corrected'], // ممكن null
      found: json['found'] ?? false,
    );
  }
}
