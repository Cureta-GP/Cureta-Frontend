# GET Medical Records — Detailed Implementation Plan

## Goal
Integrate `GET /api/medical-records` into the existing UI. Replace all dummy/hardcoded data with real API data. Show shimmer cards while loading. View attachments inline (no download).

---

## API Reference

```
GET /api/medical-records?profile_id=<uuid>&type=<string>&start_date=<date>&end_date=<date>&search=<string>
```

**Response 200:**
```json
{
  "status": "SUCCESS",
  "data": [{
    "id": "uuid",
    "profile_id": "uuid",
    "disease_name": "string",
    "notes": "string",
    "record_date": "2026-03-11",
    "created_at": "2026-03-11T11:46:43.519Z",
    "attachments": [{
      "id": "uuid",
      "record_id": "uuid",
      "file_url": "string",
      "attachment_type": "X-ray",
      "file_name": "string"
    }]
  }]
}
```

**Where does `profileId` come from?**
From [ProfilesListCubit](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/profile/view_model/profile_list_cubit.dart#5-30) → `ProfilesSuccess.selectedProfileId`. This cubit is already provided above the navigation tree. We access it via `context.read<ProfilesListCubit>()`.

---

## Changes (ordered by dependency)

### 1. Add `shimmer` package

#### [MODIFY] [pubspec.yaml](file:///d:/Flutter_Projects/Cureta-Frontend/pubspec.yaml)

```diff
  shared_preferences: ^2.3.3
+ shimmer: ^3.0.0
```

Then run:
```bash
flutter pub get
```

---

### 2. Add `getRecords()` to Service

#### [MODIFY] [medical_record_service.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/services/medical_record_service.dart)

Add this method **after** the existing [createRecord()](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/repo/medical_record_repository.dart#10-39):

```dart
Future<Response> getRecords({
  required String profileId,
  String? type,
  String? startDate,
  String? endDate,
  String? search,
}) async {
  final query = <String, dynamic>{
    'profile_id': profileId,
    if (type != null) 'type': type,
    if (startDate != null) 'start_date': startDate,
    if (endDate != null) 'end_date': endDate,
    if (search != null && search.isNotEmpty) 'search': search,
  };
  return await DioHelper.getData(url: 'medical-records', query: query);
}
```

---

### 3. Add `getRecords()` + Session Cache to Repository

#### [MODIFY] [medical_record_repository.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/repo/medical_record_repository.dart)

**Full file after changes:**

```dart
import 'package:cureta/core/error_handling/error_handler.dart';
import 'package:cureta/core/error_handling/app_exceptions.dart';
import '../models/medical_record_model.dart';
import '../services/medical_record_service.dart';

class MedicalRecordRepository {
  final MedicalRecordService _service;

  // ── Session Cache ──
  List<MedicalRecordModel>? _cachedRecords;

  MedicalRecordRepository(this._service);

  // ── CREATE (existing) ──
  Future<MedicalRecordModel> createRecord({
    required String profileId,
    required String diseaseName,
    String? notes,
    required String recordDate,
    required List<String> attachmentTypes,
    required List<String> filePaths,
  }) async {
    try {
      final response = await _service.createRecord(
        profileId: profileId,
        diseaseName: diseaseName,
        notes: notes,
        recordDate: recordDate,
        attachmentTypes: attachmentTypes,
        filePaths: filePaths,
      );
      final data = response.data['data'];
      if (data == null || data is! Map<String, dynamic>) {
        throw AppException.server(msg: 'No record data returned from server');
      }

      final newRecord = MedicalRecordModel.fromJson(data);

      // Prepend to session cache so list screen sees it immediately
      _cachedRecords?.insert(0, newRecord);

      return newRecord;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // ── GET RECORDS (new) ──
  Future<List<MedicalRecordModel>> getRecords({
    required String profileId,
    String? type,
    String? search,
    bool forceRefresh = false,
  }) async {
    try {
      // Return session cache instantly if no refresh forced and no filters
      final hasFilters = type != null || (search != null && search.isNotEmpty);
      if (!forceRefresh && !hasFilters && _cachedRecords != null) {
        return _cachedRecords!;
      }

      final response = await _service.getRecords(
        profileId: profileId,
        type: type,
        search: search,
      );

      final data = response.data['data'] as List<dynamic>?;
      if (data == null) return [];

      final records = data
          .map((e) => MedicalRecordModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // Only cache the unfiltered full list
      if (!hasFilters) {
        _cachedRecords = records;
      }

      return records;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
```

**Key design decisions:**
- `_cachedRecords` is in-memory only — lives as long as the app session.
- When [createRecord](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/repo/medical_record_repository.dart#10-39) succeeds, we prepend to cache so the list screen shows the new record immediately without refetching.
- When `forceRefresh: true` (pull-to-refresh), we bypass cache & fetch from API.
- When filters (`type`, `search`) are active, we always fetch from API (since cache = unfiltered).

---

### 4. Create Cubit + State

#### [NEW] [medical_records_state.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/veiw_model/medical_records_state.dart)

```dart
import 'package:cureta/core/error_handling/app_exceptions.dart';
import '../data/models/medical_record_model.dart';

sealed class MedicalRecordsState {
  const MedicalRecordsState();
}

final class MedicalRecordsInitial extends MedicalRecordsState {
  const MedicalRecordsInitial();
}

final class MedicalRecordsLoading extends MedicalRecordsState {
  final bool isRefresh; // true = pull-to-refresh (don't show full shimmer)
  const MedicalRecordsLoading({this.isRefresh = false});
}

final class MedicalRecordsSuccess extends MedicalRecordsState {
  final List<MedicalRecordModel> records;
  const MedicalRecordsSuccess(this.records);
}

final class MedicalRecordsFailure extends MedicalRecordsState {
  final AppException error;
  const MedicalRecordsFailure(this.error);
}
```

#### [NEW] [medical_records_cubit.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/veiw_model/medical_records_cubit.dart)

```dart
import 'package:bloc/bloc.dart';
import 'package:cureta/core/error_handling/app_exceptions.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import '../data/repo/medical_record_repository.dart';
import 'medical_records_state.dart';

class MedicalRecordsCubit extends Cubit<MedicalRecordsState> {
  MedicalRecordsCubit()
      : _repository = getIt.get<MedicalRecordRepository>(),
        super(const MedicalRecordsInitial());

  final MedicalRecordRepository _repository;

  /// Fetch records for the given profile.
  /// [forceRefresh] = true bypasses session cache (used by pull-to-refresh).
  Future<void> fetchRecords({
    required String profileId,
    String? type,
    String? search,
    bool forceRefresh = false,
  }) async {
    emit(MedicalRecordsLoading(isRefresh: forceRefresh));

    try {
      final records = await _repository.getRecords(
        profileId: profileId,
        type: type,
        search: search,
        forceRefresh: forceRefresh,
      );
      emit(MedicalRecordsSuccess(records));
    } on AppException catch (e) {
      emit(MedicalRecordsFailure(e));
    } catch (_) {
      emit(MedicalRecordsFailure(
        AppException.server(msg: 'Failed to load records'),
      ));
    }
  }
}
```

---

### 5. Create Shimmer Card Widget

#### [NEW] [shimmer_record_card.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/widgets/shimmer_record_card.dart)

A skeleton that mimics the shape of [UserRecordCard](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/widgets/user_record_card.dart#9-122) (status pill + title + meta row):

```dart
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerRecordCard extends StatelessWidget {
  const ShimmerRecordCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;

    return Shimmer.fromColors(
      baseColor: colors.surface,
      highlightColor: colors.divider,
      child: Container(
        padding: EdgeInsets.all(spacing.lg),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(radius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status pill placeholder
            Container(
              width: 72,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(radius.full),
              ),
            ),
            SizedBox(height: spacing.md),
            // Title placeholder
            Container(
              width: double.infinity,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(radius.sm),
              ),
            ),
            SizedBox(height: spacing.md),
            // Meta row placeholder
            Container(
              width: 140,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(radius.sm),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows a list of shimmer cards (default 4).
class ShimmerRecordsList extends StatelessWidget {
  const ShimmerRecordsList({super.key, this.count = 4});
  final int count;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Padding(
      padding: EdgeInsets.fromLTRB(spacing.lg, spacing.lg, spacing.lg, 0),
      child: Column(
        children: List.generate(
          count,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: spacing.lg),
            child: const ShimmerRecordCard(),
          ),
        ),
      ),
    );
  }
}
```

---

### 6. Update [UserRecordCard](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/widgets/user_record_card.dart#9-122) — Accept [MedicalRecordModel](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/models/medical_record_model.dart#3-46)

#### [MODIFY] [user_record_card.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/widgets/user_record_card.dart)

**What changes:**
- Accept `MedicalRecordModel record` instead of individual string fields.
- Remove the hardcoded dummy [RecordFile](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/widgets/record_details_documents_section.dart#7-24) list and notes from [onTap](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/veiw/add_record_forth_step.dart#33-42) navigation.
- Pass the real [MedicalRecordModel](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/models/medical_record_model.dart#3-46) to the details screen via `state.extra`.
- Format the `record_date` and derive status/meta from the model.

```dart
import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/data/models/medical_record_model.dart';
import 'package:cureta/features/medical_records/widgets/user_record_action_button.dart';
import 'package:cureta/features/medical_records/widgets/user_record_status_pill.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class UserRecordCard extends StatelessWidget {
  const UserRecordCard({
    super.key,
    required this.record,
    this.onTap,
  });

  final MedicalRecordModel record;
  final VoidCallback? onTap;

  String _formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    final dateStr = _formatDate(record.recordDate);
    final attachmentCount = record.attachments.length;
    final meta = '$dateStr · $attachmentCount files';

    return GestureDetector(
      onTap: () => GoRouter.of(context).pushNamed(
        AppRoutes.recordDetails,
        extra: record, // Pass the full MedicalRecordModel
      ),
      child: Container(
        padding: EdgeInsets.all(spacing.lg),
        decoration: BoxDecoration(
          color: colors.surface,
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
                      UserRecordStatusPill(
                        label: '${record.attachments.length} attachments',
                        isOngoing: true,
                      ),
                      SizedBox(height: spacing.md),
                      Text(
                        record.diseaseName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: typography.surfaceTitle.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.md),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: colors.textSecondary),
                SizedBox(width: spacing.xs),
                Expanded(
                  child: Text(
                    meta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: typography.medicalRecordUploadCardDescription
                        .copyWith(color: colors.textSecondary),
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
```

---

### 7. Update [UserRecordsList](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/widgets/user_records_list.dart#6-39) — Use [MedicalRecordModel](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/models/medical_record_model.dart#3-46)

#### [MODIFY] [user_records_list.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/widgets/user_records_list.dart)

```dart
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

    return Column(
      children: records
          .map(
            (record) => Padding(
              padding: EdgeInsets.only(bottom: spacing.lg),
              child: UserRecordCard(record: record),
            ),
          )
          .toList(),
    );
  }
}
```

---

### 8. Rewrite `User's_Records.dart` — Wire to Cubit

#### [MODIFY] [User's_Records.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/veiw/User's_Records.dart)

**Full replacement:**

```dart
// ignore_for_file: file_names
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/data/user_records_data.dart';
import 'package:cureta/features/medical_records/data/user_records_models.dart';
import 'package:cureta/features/medical_records/veiw_model/medical_records_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/medical_records_state.dart';
import 'package:cureta/features/medical_records/widgets/shimmer_record_card.dart';
import 'package:cureta/features/medical_records/widgets/user_records_list.dart';
import 'package:cureta/features/medical_records/widgets/user_records_top_section.dart';
import 'package:cureta/features/profile/view_model/profile_list_cubit.dart';
import 'package:cureta/features/profile/view_model/profile_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserRecordsView extends StatefulWidget {
  const UserRecordsView({super.key});

  @override
  State<UserRecordsView> createState() => _UserRecordsViewState();
}

class _UserRecordsViewState extends State<UserRecordsView> {
  final _searchController = TextEditingController();
  String _selectedFilter = UserRecordFilterIds.all;

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  void _fetchRecords({bool forceRefresh = false}) {
    final profileState = context.read<ProfilesListCubit>().state;
    if (profileState is ProfilesSuccess && profileState.selectedProfileId != null) {
      context.read<MedicalRecordsCubit>().fetchRecords(
            profileId: profileState.selectedProfileId!,
            search: _searchController.text.isNotEmpty
                ? _searchController.text
                : null,
            forceRefresh: forceRefresh,
          );
    }
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

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _fetchRecords(forceRefresh: true),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserRecordsTopSection(
                searchController: _searchController,
                filters: filters,
                selectedFilterId: _selectedFilter,
                onFilterSelected: (id) {
                  setState(() => _selectedFilter = id);
                  _fetchRecords();
                },
              ),

              // ── Records list driven by Cubit ──
              BlocBuilder<MedicalRecordsCubit, MedicalRecordsState>(
                builder: (context, state) {
                  // Loading (first load — show shimmer)
                  if (state is MedicalRecordsLoading && !state.isRefresh) {
                    return const ShimmerRecordsList();
                  }

                  // Error
                  if (state is MedicalRecordsFailure) {
                    return Padding(
                      padding: EdgeInsets.all(spacing.xl),
                      child: Center(
                        child: Text(
                          state.error.msg,
                          style: context.typography.medicalRecordHelper
                              .copyWith(color: colors.error),
                        ),
                      ),
                    );
                  }

                  // Success
                  if (state is MedicalRecordsSuccess) {
                    if (state.records.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.all(spacing.xl),
                        child: Center(
                          child: Text(
                            AppLocalizations.recordsListTitle,
                            style: context.typography.medicalRecordHelper
                                .copyWith(color: colors.textSecondary),
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        spacing.lg, spacing.lg, spacing.lg, spacing.xxl,
                      ),
                      child: UserRecordsList(records: state.records),
                    );
                  }

                  // Initial (before first fetch)
                  return const ShimmerRecordsList();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

> [!IMPORTANT]
> `MedicalRecordsCubit` must be provided **above** this screen. Best place: wherever `UserRecordsView` is created in the navigation tree. Example:
> ```dart
> BlocProvider(
>   create: (_) => MedicalRecordsCubit(),
>   child: const UserRecordsView(),
> )
> ```
> We need to find where `UserRecordsView` is instantiated in the router or navigation and wrap it there.

---

### 9. Update Router — Record Details accepts [MedicalRecordModel](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/models/medical_record_model.dart#3-46)

#### [MODIFY] [router_generation.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/config/routing/router_generation.dart) (lines 206-226)

**Before:**
```dart
GoRoute(
  path: AppRoutes.recordDetails,
  name: AppRoutes.recordDetails,
  pageBuilder: (context, state) {
    final data = state.extra as Map<String, dynamic>? ?? {};
    final rawFiles = data['files'];
    final files = rawFiles is List
        ? rawFiles.whereType<RecordFile>().toList()
        : <RecordFile>[];
    return PageTransitions.scale(
      child: RecordDetailsView(
        conditionName: data['conditionName'] ?? '',
        isOngoing: data['isOngoing'] ?? false,
        diagnosedDate: data['diagnosedDate'] ?? '',
        notes: data['notes'] ?? '',
        files: files,
      ),
      state: state,
    );
  },
),
```

**After:**
```dart
GoRoute(
  path: AppRoutes.recordDetails,
  name: AppRoutes.recordDetails,
  pageBuilder: (context, state) {
    final record = state.extra as MedicalRecordModel;
    return PageTransitions.scale(
      child: RecordDetailsView(record: record),
      state: state,
    );
  },
),
```

Add import at the top of [router_generation.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/config/routing/router_generation.dart):
```dart
import 'package:cureta/features/medical_records/data/models/medical_record_model.dart';
```

---

### 10. Update [RecordDetailsView](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/veiw/record_details_screen.dart#14-104) — Accept [MedicalRecordModel](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/models/medical_record_model.dart#3-46)

#### [MODIFY] [record_details_screen.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/veiw/record_details_screen.dart)

```dart
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/data/models/medical_record_model.dart';
import 'package:cureta/features/medical_records/widgets/record_details_bottom_actions.dart';
import 'package:cureta/features/medical_records/widgets/record_details_diagnosed_date.dart';
import 'package:cureta/features/medical_records/widgets/record_details_documents_section.dart';
import 'package:cureta/features/medical_records/widgets/record_details_header.dart';
import 'package:cureta/features/medical_records/widgets/record_details_notes_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordDetailsView extends StatelessWidget {
  const RecordDetailsView({
    super.key,
    required this.record,
    this.onEdit,
    this.onDelete,
  });

  final MedicalRecordModel record;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  String _formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (_) {
      return rawDate;
    }
  }

  /// Maps an AttachmentModel to a RecordFile for display.
  List<RecordFile> _mapAttachments(BuildContext context) {
    final colors = context.colors;
    return record.attachments.map((att) {
      final isImage = att.fileName.endsWith('.jpg') ||
          att.fileName.endsWith('.jpeg') ||
          att.fileName.endsWith('.png');
      final isPdf = att.fileName.endsWith('.pdf');

      return RecordFile(
        name: att.fileName,
        meta: '${att.attachmentType}${isPdf ? " • PDF" : isImage ? " • Image" : ""}',
        icon: isPdf ? Icons.picture_as_pdf : Icons.image,
        iconBgColor: isPdf
            ? colors.error.withOpacity(0.1)
            : colors.accentBlue,
        iconColor: isPdf ? colors.error : const Color(0xFF3B82F6),
        fileType: isPdf ? 'pdf' : 'image',
        fileUrl: att.fileUrl,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final files = _mapAttachments(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.recordDetailsTitle,
          style: typography.medicalRecordUploadCardTitle.copyWith(
            color: colors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: spacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: spacing.xs),
              RecordDetailsHeader(
                conditionName: record.diseaseName,
                isOngoing: true,
              ),
              SizedBox(height: spacing.xxl),
              RecordDetailsDiagnosedDate(
                date: _formatDate(record.recordDate),
              ),
              SizedBox(height: spacing.xxl),
              if (record.notes != null && record.notes!.isNotEmpty) ...[
                RecordDetailsNotesCard(notes: record.notes!),
                SizedBox(height: spacing.xxl),
              ],
              if (files.isNotEmpty) ...[
                RecordDetailsDocumentsSection(
                  files: files,
                  onFileTap: (index) {
                    final file = files[index];
                    if (file.fileType == 'image') {
                      // Open fullscreen image viewer
                      _openImageViewer(context, file.fileUrl!);
                    } else {
                      // Open PDF/other in external viewer
                      _openExternalFile(file.fileUrl!);
                    }
                  },
                ),
              ],
              RecordDetailsBottomActions(onEdit: onEdit, onDelete: onDelete),
              SizedBox(height: spacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  void _openImageViewer(BuildContext context, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _FullScreenImageViewer(imageUrl: url),
      ),
    );
  }

  void _openExternalFile(String url) {
    // Uses url_launcher to open in browser
    // (already available since open_filex is in pubspec)
    // Or use launchUrl(Uri.parse(url));
  }
}

/// Simple fullscreen image viewer using CachedNetworkImage.
class _FullScreenImageViewer extends StatelessWidget {
  const _FullScreenImageViewer({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            },
            errorBuilder: (_, __, ___) => const Icon(
              Icons.broken_image,
              color: Colors.white54,
              size: 64,
            ),
          ),
        ),
      ),
    );
  }
}
```

---

### 11. Update [RecordFile](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/widgets/record_details_documents_section.dart#7-24) — Add `fileUrl`

#### [MODIFY] [record_details_documents_section.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/widgets/record_details_documents_section.dart) (lines 7-23)

Add `fileUrl` field to [RecordFile](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/widgets/record_details_documents_section.dart#7-24):

```diff
 class RecordFile {
   const RecordFile({
     required this.name,
     required this.meta,
     required this.icon,
     required this.iconBgColor,
     required this.iconColor,
     required this.fileType,
+    this.fileUrl,
   });

   final String name;
   final String meta;
   final IconData icon;
   final Color iconBgColor;
   final Color iconColor;
   final String fileType;
+  final String? fileUrl;
 }
```

---

### 12. Cleanup — Remove [UserRecordItem](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/user_records_models.dart#10-25)

#### [MODIFY] [user_records_models.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/user_records_models.dart)

Remove [UserRecordItem](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/user_records_models.dart#10-25) class (replaced by [MedicalRecordModel](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/models/medical_record_model.dart#3-46)). Keep [UserRecordFilter](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/user_records_models.dart#3-9) and [UserRecordFilterIds](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/user_records_models.dart#26-32):

```dart
class UserRecordFilter {
  const UserRecordFilter({required this.id, required this.label});
  final String id;
  final String label;
}

class UserRecordFilterIds {
  static const all = 'all';
  static const ongoing = 'ongoing';
  static const past = 'past';
  static const recent = 'recent';
}
```

#### [MODIFY] [user_records_data.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/user_records_data.dart)

Remove [localizedUserRecordItems()](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/user_records_data.dart#26-58) and [filteredUserRecordItems()](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/user_records_data.dart#59-80). Keep only [localizedUserRecordFilters()](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/user_records_data.dart#5-25):

```dart
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/medical_records/data/user_records_models.dart';

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
```

---

## Summary of All Files

| # | Action | File | What |
|---|--------|------|------|
| 1 | MODIFY | [pubspec.yaml](file:///d:/Flutter_Projects/Cureta-Frontend/pubspec.yaml) | Add `shimmer: ^3.0.0` |
| 2 | MODIFY | [medical_record_service.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/services/medical_record_service.dart) | Add `getRecords()` |
| 3 | MODIFY | [medical_record_repository.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/repo/medical_record_repository.dart) | Add `getRecords()` + `_cachedRecords` + prepend on create |
| 4 | NEW | [medical_records_state.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/veiw_model/medical_records_state.dart) | Sealed state classes |
| 5 | NEW | [medical_records_cubit.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/veiw_model/medical_records_cubit.dart) | Cubit with `fetchRecords()` |
| 6 | NEW | `shimmer_record_card.dart` | Shimmer loading cards |
| 7 | MODIFY | [user_record_card.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/widgets/user_record_card.dart) | Accept [MedicalRecordModel](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/models/medical_record_model.dart#3-46), remove dummy data |
| 8 | MODIFY | [user_records_list.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/widgets/user_records_list.dart) | Use `List<MedicalRecordModel>` |
| 9 | MODIFY | `User's_Records.dart` | Wire to `MedicalRecordsCubit` + shimmer + pull-to-refresh |
| 10 | MODIFY | [router_generation.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/config/routing/router_generation.dart) | Pass [MedicalRecordModel](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/models/medical_record_model.dart#3-46) to details |
| 11 | MODIFY | [record_details_screen.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/veiw/record_details_screen.dart) | Accept [MedicalRecordModel](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/models/medical_record_model.dart#3-46), map attachments, add image viewer |
| 12 | MODIFY | [record_details_documents_section.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/widgets/record_details_documents_section.dart) | Add `fileUrl` to [RecordFile](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/widgets/record_details_documents_section.dart#7-24) |
| 13 | MODIFY | [user_records_models.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/user_records_models.dart) | Remove [UserRecordItem](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/user_records_models.dart#10-25) |
| 14 | MODIFY | [user_records_data.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/medical_records/data/user_records_data.dart) | Remove dummy data functions |

---

## Verification Plan

1. Open Records List → shimmer cards appear during loading
2. After loading → real records from API are displayed
3. Pull down → shimmer briefly, data reloads from server
4. Navigate away and back → loads instantly (session cache, no shimmer)
5. Tap a record → details screen shows real data + attachments
6. Tap an image attachment → opens fullscreen viewer (no download prompt)
7. Create a new record → go back to list → new record appears at top without refetching
