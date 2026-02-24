// ignore_for_file: file_names
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/data/user_records_data.dart';
import 'package:cureta/features/medical_records/data/user_records_models.dart';
import 'package:cureta/features/medical_records/widgets/user_records_bottom_navigation.dart';
import 'package:cureta/features/medical_records/widgets/user_record_card.dart';
import 'package:cureta/features/medical_records/widgets/user_records_top_section.dart';
import 'package:flutter/material.dart';

class UserRecordsView extends StatefulWidget {
  const UserRecordsView({super.key});

  @override
  State<UserRecordsView> createState() => _UserRecordsViewState();
}

class _UserRecordsViewState extends State<UserRecordsView> {
  final _searchController = TextEditingController();
  String _selectedFilter = UserRecordFilterIds.all;
  int _currentNavIndex = 2;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final filters = localizedUserRecordFilters();
    final allRecords = localizedUserRecordItems();
    final visible = filteredUserRecordItems(
      records: allRecords,
      filterId: _selectedFilter,
      query: _searchController.text,
    );
    return Scaffold(
      backgroundColor: colors.medicalRecordBackground,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: colors.primary,
        child: Icon(
          Icons.document_scanner,
          size: spacing.xl + spacing.xs,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: UserRecordsBottomNavigation(
        homeLabel: AppLocalizations.recordsListNavHome,
        medsLabel: AppLocalizations.recordsListNavMeds,
        scanRxLabel: AppLocalizations.recordsListNavScanRx,
        recordsLabel: AppLocalizations.recordsListNavRecords,
        profileLabel: AppLocalizations.recordsListNavProfile,
        currentIndex: _currentNavIndex,
        onItemSelected: (index) => setState(() => _currentNavIndex = index),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserRecordsTopSection(
              searchController: _searchController,
              filters: filters,
              selectedFilterId: _selectedFilter,
              onFilterSelected: (id) => setState(() => _selectedFilter = id),
            ),
            if (visible.isEmpty)
              Padding(
                padding: EdgeInsets.all(spacing.xl),
                child: Center(
                  child: Text(
                    AppLocalizations.recordsListTitle,
                    style: context.typography.medicalRecordHelper.copyWith(
                      color: colors.medicalRecordMuted,
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: EdgeInsets.fromLTRB(
                  spacing.lg,
                  spacing.lg,
                  spacing.lg,
                  spacing.xxl,
                ),
                child: Column(
                  children: visible
                      .map(
                        (item) => Padding(
                          padding: EdgeInsets.only(bottom: spacing.lg),
                          child: UserRecordCard(
                            status: item.status,
                            title: item.title,
                            meta: item.meta,
                            metaIcon: item.metaIcon,
                            isOngoing: item.isOngoing,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
