import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class UnifiedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UnifiedAppBar({
    super.key,
    required this.title,
    this.onMenuPressed,
    this.onBackPressed,
    this.actions,
    this.centerTitle = true,
  });

  final String title;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool centerTitle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final titleStyle = context.typography.medicalRecordScreenTitle.copyWith(
      color: colors.textPrimary,
    );

    return AppBar(
      backgroundColor: colors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      leading: onBackPressed != null
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: colors.textPrimary),
              onPressed: onBackPressed,
            )
          : onMenuPressed != null
          ? IconButton(
              icon: Icon(Icons.menu, color: colors.textPrimary),
              onPressed: onMenuPressed,
            )
          : null,
      title: Text(title, style: titleStyle),
      actions: actions,
    );
  }
}
