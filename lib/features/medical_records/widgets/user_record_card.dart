import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/widgets/user_record_action_button.dart';
import 'package:cureta/features/medical_records/widgets/user_record_status_pill.dart';
import 'package:flutter/material.dart';
import 'package:cureta/features/medical_records/widgets/record_details_documents_section.dart';
import 'package:go_router/go_router.dart';

class UserRecordCard extends StatelessWidget {
  const UserRecordCard({
    super.key,
    required this.status,
    required this.title,
    required this.meta,
    required this.metaIcon,
    required this.isOngoing,
    this.onTap,
  });

  final String status;
  final String title;
  final String meta;
  final IconData metaIcon;
  final bool isOngoing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;
    final bg = isOngoing ? colors.medicalRecordCard : colors.surface;

    return GestureDetector(
      onTap: () => GoRouter.of(context).pushNamed(
        AppRoutes.recordDetails,
        extra: {
          'conditionName': title,
          'isOngoing': isOngoing,
          'diagnosedDate': meta,
          'notes':
              "This is a note for hypertension and it is long to test the overflow",
          'files': <RecordFile>[
            RecordFile(
              name: "Blood_Test_Oct24.pdf",
              meta: "PDF • 2.4 MB",
              icon: Icons.picture_as_pdf,
              iconBgColor: colors.medicalRecordDetailPdfBg,
              iconColor: colors.medicalRecordDetailPdfIcon,
              fileType: "pdf",
            ),
            RecordFile(
              name: "Prescription_Slip.jpg",
              meta: "Image • 1.1 MB",
              icon: Icons.image,
              iconBgColor: colors.medicalRecordUploadScanBg,
              iconColor: colors.medicalRecordUploadScanIcon,
              fileType: "image",
            ),
          ],
        },
      ),
      child: Container(
        padding: EdgeInsets.all(spacing.lg),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(radius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserRecordStatusPill(label: status, isOngoing: isOngoing),
                      SizedBox(height: spacing.md),
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: typography.medicalRecordCardTitle.copyWith(
                          color: colors.medicalRecordStrongText,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isOngoing) ...[
                  SizedBox(width: spacing.md),
                  UserRecordActionButton(isOngoing: isOngoing, onTap: onTap),
                ],
              ],
            ),
            SizedBox(height: spacing.md),
            Row(
              children: [
                Icon(metaIcon, size: 16, color: colors.medicalRecordMuted),
                SizedBox(width: spacing.xs),
                Expanded(
                  child: Text(
                    meta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: typography.medicalRecordUploadCardDescription
                        .copyWith(color: colors.medicalRecordMuted),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
