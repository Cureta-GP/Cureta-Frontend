import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/data/models/medical_record_model.dart';
import 'package:cureta/features/medical_records/widgets/user_record_card.dart';
import 'package:flutter/material.dart';

class UserRecordsList extends StatelessWidget {
  const UserRecordsList({super.key, required this.records});

  final List<MedicalRecordModel> records;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return ListView.builder(
      addAutomaticKeepAlives: false, // لا تحتفظ تلقائيًا بالحالة
      addRepaintBoundaries: false,   // قلل إنشاء الطبقات الزائدة
      cacheExtent: 250,              // مسافة التحميل المسبق
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.lg,
        spacing.lg,
        spacing.xxl * 2,
      ),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return Padding(
          padding: EdgeInsets.only(bottom: spacing.lg),
          child: UserRecordCard(record: record),
        );
      },
    );
  }
}
