import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:cureta/core/localization/app_localizations.dart';

class MedicineScreenAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const MedicineScreenAppBarWidget({super.key, this.onMenuTap});

  final VoidCallback? onMenuTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppBar(
      backgroundColor: colors.background,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu, color: colors.textPrimary),
        onPressed: onMenuTap,
      ),
      title: Text(
        AppLocalizations.medicinesMyMedicines,
        style: context.typography.medicalRecordScreenTitle.copyWith(
          color: colors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
    );
  }
}
