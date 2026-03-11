import 'package:cureta/features/medical_records/data/models/medical_record_model.dart';
import 'package:cureta/features/medical_records/data/user_records_models.dart';

class RecordsFilter {
  static List<MedicalRecordModel> apply({
    required List<MedicalRecordModel> records,
    required String filterId,
    required String query,
  }) {
    final text = query.trim().toLowerCase();

    List<MedicalRecordModel> byFilter;
    switch (filterId) {
      case UserRecordFilterIds.ongoing:
        byFilter = records.where((r) => r.attachments.isNotEmpty).toList();
        break;
      case UserRecordFilterIds.past:
        byFilter = records.where((r) => r.attachments.isEmpty).toList();
        break;
      case UserRecordFilterIds.recent:
        byFilter = records.take(2).toList();
        break;
      default:
        byFilter = records;
    }

    if (text.isEmpty) return byFilter;
    return byFilter
        .where((r) => r.diseaseName.toLowerCase().contains(text))
        .toList();
  }
}
