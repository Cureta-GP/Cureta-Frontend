import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/data/user_records_models.dart';
import 'package:cureta/features/medical_records/widgets/user_record_card.dart';
import 'package:flutter/material.dart';

class UserRecordsList extends StatelessWidget {
  const UserRecordsList({super.key, required this.items});

  final List<UserRecordItem> items;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.lg,
        spacing.lg,
        spacing.xxl * 2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: EdgeInsets.only(bottom: spacing.lg),
          child: UserRecordCard(
            status: item.status,
            title: item.title,
            meta: item.meta,
            metaIcon: item.metaIcon,
            isOngoing: item.isOngoing,
          ),
        );
      },
    );
  }
}
