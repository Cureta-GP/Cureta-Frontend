import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/profile/model/profile_model.dart';
import 'package:cureta/features/profile/view/select_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AllProfiesView extends StatefulWidget {
  const AllProfiesView({super.key});

  @override
  State<AllProfiesView> createState() => _AllProfiesViewState();
}

class _AllProfiesViewState extends State<AllProfiesView> {
  /// ==================== Profile Data ====================
  late List<ProfileModel> _profiles;
  late String _selectedProfileId;

  @override
  void initState() {
    super.initState();
    _initializeProfiles();
  }

  /// Initialize profiles data
  void _initializeProfiles() {
    _profiles = [
      ProfileModel(
        id: '1',
        name: 'John Doe',
        relationship: 'Primary Account (You)',
        avatarUrl: '',
      ),
      ProfileModel(
        id: '2',
        name: 'Jane Doe',
        relationship: 'Spouse',
        avatarUrl: '',
      ),
      ProfileModel(
        id: '3',
        name: 'Billy Doe',
        relationship: 'Son',
        avatarUrl: '',
      ),
      ProfileModel(
        id: '4',
        name: 'Emma Doe',
        relationship: 'Daughter',
        avatarUrl: '',
      ),
    ];
    _selectedProfileId = _profiles.first.id;
  }

  /// Get currently selected profile
  ProfileModel get _currentProfile =>
      _profiles.firstWhere((p) => p.id == _selectedProfileId);

  /// Handle profile selection from dialog
  void _onProfileSelected(ProfileModel profile) {
    setState(() {
      _selectedProfileId = profile.id;
    });
    // Close dialog after selection
    Navigator.of(context).pop();
  }

  /// Show profile selection dialog
  Future<void> _showProfileSelectionDialog() async {
    final selected = await SelectProfileScreen.showAsDialog(
      context,
      profiles: _profiles,
      selectedProfileId: _selectedProfileId,
      onAddProfilePressed: _onAddProfilePressed,
    );

    if (selected != null) {
      _onProfileSelected(selected);
    }
  }

  /// Handle add profile button tap
  void _onAddProfilePressed() {
    Navigator.of(context).pop(); // Close dialog first
    GoRouter.of(context).go(AppRoutes.addProfile);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final colors = context.colors;
    final typography = context.typography;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text(
          'Family Profiles',
          style: typography.title.copyWith(color: colors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ==================== Header ====================
              Text(
                'Current Profile',
                style: typography.label.copyWith(
                  color: colors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: spacing.md),

              /// ==================== Selected Profile Card ====================
              _buildSelectedProfileCard(context),
              SizedBox(height: spacing.xl),

              /// ==================== Switch Profile Button ====================
              _buildSwitchProfileButton(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Build selected profile card
  Widget _buildSelectedProfileCard(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final radius = context.radius;

    return GestureDetector(
      onTap: _showProfileSelectionDialog,
      child: Container(
        padding: EdgeInsets.all(spacing.lg),
        decoration: BoxDecoration(
          color: colors.accentCyan,
          borderRadius: BorderRadius.circular(radius.md),
          border: Border.all(color: colors.primary, width: 2),
        ),
        child: Row(
          children: [
            /// Avatar
            Container(
              width: spacing.xxl + spacing.lg,
              height: spacing.xxl + spacing.lg,
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _getInitials(_currentProfile.name),
                  style: typography.title.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: spacing.lg),

            /// Profile info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentProfile.name,
                    style: typography.title.copyWith(color: colors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    _currentProfile.relationship,
                    style: typography.body.copyWith(
                      color: colors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            /// Change indicator
            Icon(
              Icons.arrow_forward_ios,
              color: colors.primary,
              size: spacing.lg,
            ),
          ],
        ),
      ),
    );
  }

  /// Build switch profile button
  Widget _buildSwitchProfileButton(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;

    return SizedBox(
      width: double.infinity,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: spacing.xxl + spacing.lg),
        child: ElevatedButton.icon(
          onPressed: _showProfileSelectionDialog,
          icon: const Icon(Icons.swap_horiz),
          label: Text('Switch Profile'),
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.md),
            ),
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: spacing.md),
          ),
        ),
      ),
    );
  }

  /// Get initials from name for avatar
  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.isEmpty) return '?';
    final initials = parts.take(2).map((e) => e.isNotEmpty ? e[0] : '').join();
    return initials.toUpperCase();
  }
}
