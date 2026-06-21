// qr_share_filters.dart
class QrShareFilters {
  final List<String>? types;
  final String? category;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? includeHistory;

  QrShareFilters({
    this.types,
    this.category,
    this.startDate,
    this.endDate,
    this.includeHistory,
  });

  Map<String, dynamic> toJson() {
    return {
      if (types != null) 'types': types,
      if (category != null) 'category': category,
      if (startDate != null) 'start_date': startDate!.toUtc().toIso8601String(),
      if (endDate != null) 'end_date': endDate!.toUtc().toIso8601String(),
      if (includeHistory != null) 'include_history': includeHistory,
    };
  }
}
