import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/profile/data/models/profile_model.dart';
import 'package:cureta/features/profile/widgets/add_profile_button.dart';
import 'package:cureta/features/profile/widgets/profile_card.dart';
import 'package:flutter/material.dart';
/// Select Profile screen/dialog for choosing between family members
/// Can be displayed as a bottom sheet or dialog
class SelectProfileScreen extends StatefulWidget {
  /// List of available profiles
  final List<ProfileModel> profiles;

  /// ID of currently selected profile
  final String selectedProfileId;

  /// Callback when a profile is selected
  final ValueChanged<ProfileModel> onProfileSelected;

  /// Callback when add profile button is tapped
  final VoidCallback onAddProfilePressed;

  /// Whether to show this as a dialog (true) or bottom sheet (false)
  final bool isDialog;

  const SelectProfileScreen({
    super.key,
    required this.profiles,
    required this.selectedProfileId,
    required this.onProfileSelected,
    required this.onAddProfilePressed,
    this.isDialog = false,
  });

  /// Show as bottom sheet
  static Future<ProfileModel?> showAsBottomSheet(
    BuildContext context, {
    required List<ProfileModel> profiles,
    required String selectedProfileId,
    required VoidCallback onAddProfilePressed,
  }) {
    return showModalBottomSheet<ProfileModel>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.radius.lg),
        ),
      ),
      builder: (context) => SelectProfileScreen(
        profiles: profiles,
        selectedProfileId: selectedProfileId,
        onProfileSelected: (profile) {
          Navigator.of(context).pop(profile);
        },
        onAddProfilePressed: onAddProfilePressed,
        isDialog: false,
      ),
    );
  }

  /// Show as dialog
  static Future<ProfileModel?> showAsDialog(
    BuildContext context, {
    required List<ProfileModel> profiles,
    required String selectedProfileId,
    required VoidCallback onAddProfilePressed,
  }) {
    return showDialog<ProfileModel>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.radius.lg),
        ),
        child: SelectProfileScreen(
          profiles: profiles,
          selectedProfileId: selectedProfileId,
          onProfileSelected: (profile) {
            Navigator.of(context).pop(profile);
          },
          onAddProfilePressed: onAddProfilePressed,
          isDialog: true,
        ),
      ),
    );
  }

  @override
  State<SelectProfileScreen> createState() => _SelectProfileScreenState();
}

class _SelectProfileScreenState extends State<SelectProfileScreen> {
  late String _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedProfileId;
  }

  void _handleProfileSelected(ProfileModel profile) {
    setState(() {
      _selectedId = profile.id;
    });
    widget.onProfileSelected(profile);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    final content = SafeArea(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),
            SizedBox(height: spacing.xl),

            // Profiles list
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(widget.profiles.length, (index) {
                    final profile = widget.profiles[index];
                    return Column(
                      children: [
                        ProfileCard(
                          name: profile.fullName,
                          relationship: AppLocalizations.getLocalizedRelationship(profile.relationship),
                          avatarUrl: profile.imageUrl,
                          isSelected: _selectedId == profile.id,
                          onTap: () => _handleProfileSelected(profile),
                        ),
                        if (index < widget.profiles.length - 1)
                          SizedBox(height: spacing.md),
                      ],
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: spacing.xl),

            // Add profile button
            AddProfileButton(
              onPressed: widget.onAddProfilePressed,
              backgroundColor: context.colors.primary,
              foregroundColor: Colors.white,
              borderRadius: context.radius.md,
              minHeight: context.spacing.xxl + context.spacing.lg,
              paddingVertical: context.spacing.md,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: context.spacing.sm),
                  Text(
                    AppLocalizations.selectProfileAddProfile,
                    style: context.typography.button.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // Wrap in dialog background if needed
    if (widget.isDialog) {
      return content;
    }

    return content;
  }

  Widget _buildHeader(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.selectProfileTitle,
          style: typography.title.copyWith(color: colors.textPrimary),
        ),
        SizedBox(height: spacing.sm),
        Text(
          AppLocalizations.selectProfileSubtitle,
          style: typography.body.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }

  // Removed _buildAddProfileButton, now using AddProfileButton widget
}
