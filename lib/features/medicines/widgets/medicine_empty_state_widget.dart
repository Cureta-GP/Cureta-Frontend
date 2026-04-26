import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';

class MedicineEmptyStateWidget extends StatelessWidget {
  const MedicineEmptyStateWidget({super.key, required this.onAddTap});

  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.spacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: context.colors.secondary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.medication_outlined,
                size: 60,
                color: context.colors.primary,
              ),
            ),
            SizedBox(height: context.spacing.xl),
            Text(
              'medicines.empty_medicines_title'.tr(),
              style: context.typography.title.copyWith(
                color: context.colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.spacing.md),
            Text(
              'medicines.empty_medicines_subtitle'.tr(),
              style: context.typography.label.copyWith(
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.spacing.xxl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAddTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: context.colors.background,
                  padding: EdgeInsets.symmetric(vertical: context.spacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.radius.xxl),
                  ),
                ),
                child: Text(
                  'medicines.add_your_first_medicine'.tr(),
                  style: context.typography.medicalRecordButton,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
