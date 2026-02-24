import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/medical_records/data/user_records_models.dart';
import 'package:flutter/material.dart';

List<UserRecordFilter> localizedUserRecordFilters() {
  return [
    UserRecordFilter(
      id: UserRecordFilterIds.all,
      label: AppLocalizations.recordsListFilterAll,
    ),
    UserRecordFilter(
      id: UserRecordFilterIds.ongoing,
      label: AppLocalizations.recordsListFilterOngoing,
    ),
    UserRecordFilter(
      id: UserRecordFilterIds.past,
      label: AppLocalizations.recordsListFilterPast,
    ),
    UserRecordFilter(
      id: UserRecordFilterIds.recent,
      label: AppLocalizations.recordsListFilterRecent,
    ),
  ];
}

List<UserRecordItem> localizedUserRecordItems() {
  return [
    UserRecordItem(
      title: AppLocalizations.recordsListType2Diabetes,
      status: AppLocalizations.recordsListStatusOngoing,
      meta: AppLocalizations.recordsListType2DiabetesMeta,
      isOngoing: true,
      metaIcon: Icons.calendar_today,
    ),
    UserRecordItem(
      title: AppLocalizations.recordsListAcuteBronchitis,
      status: AppLocalizations.recordsListStatusPast,
      meta: AppLocalizations.recordsListAcuteBronchitisMeta,
      isOngoing: false,
      metaIcon: Icons.calendar_today,
    ),
    UserRecordItem(
      title: AppLocalizations.recordsListHypertension,
      status: AppLocalizations.recordsListStatusOngoing,
      meta: AppLocalizations.recordsListHypertensionMeta,
      isOngoing: true,
      metaIcon: Icons.event_note,
    ),
    UserRecordItem(
      title: AppLocalizations.recordsListSeasonalAllergies,
      status: AppLocalizations.recordsListStatusPast,
      meta: AppLocalizations.recordsListSeasonalAllergiesMeta,
      isOngoing: false,
      metaIcon: Icons.calendar_today,
    ),
  ];
}

List<UserRecordItem> filteredUserRecordItems({
  required List<UserRecordItem> records,
  required String filterId,
  required String query,
}) {
  final text = query.trim().toLowerCase();
  final byFilter = switch (filterId) {
    UserRecordFilterIds.ongoing =>
      records.where((item) => item.isOngoing).toList(),
    UserRecordFilterIds.past =>
      records.where((item) => !item.isOngoing).toList(),
    UserRecordFilterIds.recent =>
      records.reversed.take(2).toList().reversed.toList(),
    _ => records,
  };

  if (text.isEmpty) return byFilter;
  return byFilter
      .where((item) => item.title.toLowerCase().contains(text))
      .toList();
}
