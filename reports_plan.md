# 📊 Reports Feature — Complete Implementation Plan

> **Authority:** `STYLING_GUIDELINES.md` governs every token, pattern, and rule below.
> **Architecture:** Clean Architecture + MVVM (Cubit)
> **Status:** Data layer ✅ complete — veiw_model, widgets, veiw are **empty** and must be built.

---

## Table of Contents

1. [What Already Exists](#1-what-already-exists)
2. [Navigation Flow](#2-navigation-flow)
3. [Routes to Add](#3-routes-to-add)
4. [GetIt Registration to Add](#4-getit-registration-to-add)
5. [Task 1 — State Management](#5-task-1--state-management)
6. [Task 2 — Widgets Breakdown](#6-task-2--widgets-breakdown)
7. [Task 3 — Views](#7-task-3--views)
8. [Task 4 — Wiring](#8-task-4--wiring)
9. [Task 5 — Localization Keys](#9-task-5--localization-keys)
10. [Implementation Order](#10-implementation-order)
11. [Compliance Checklist](#11-compliance-checklist)

---

## 1. What Already Exists

### ✅ Data Layer (do NOT modify)

| File | Content |
|---|---|
| `data/models/health_report_model.dart` | Root model — `id`, `profileId`, `timePeriod`, `patientInfo`, `adherenceSummary`, `topConditions`, `medicationsTimeline`, `aiInsights`, `createdAt` |
| `data/models/adherence_summary_model.dart` | `activeMeds: int`, `overallPercentage: int` |
| `data/models/ai_insights_model.dart` | `status: String` (STABLE/ALERT), `summary: List<String>`, `correlationWarning: String` |
| `data/models/medication_timeline_model.dart` | `name: String`, `instruction: String?`, `progress: int` (0–100) |
| `data/models/patient_info_model.dart` | `name: String`, `age: int`, `bloodType: String?` |
| `data/models/top_condition_model.dart` | `name: String`, `count: int` |
| `data/services/report_service.dart` | `generateReport(profileId, timePeriod, language)` → POST `/reports/generate` |
| | `getReportsHistory(profileId)` → GET `/reports/:profileId` |
| `data/repo/report_repo.dart` | `generateReport(...)` → `HealthReportModel` |
| | `getReportsHistory(...)` → `List<HealthReportModel>` |

### ✅ GetIt (already registered in `GetItServices.dart`)

```dart
getIt.registerSingleton<ReportService>(ReportService());
getIt.registerSingleton<ReportRepo>(ReportRepo(getIt<ReportService>()));
```

### ❌ Empty — must be built

- `veiw_model/` — no cubits or states
- `widgets/` — empty
- `veiw/Report_setup.dart`, `veiw/Report_history.dart`, `veiw/Report_datails.dart` — empty
- No routes defined
- No localization keys for reports

---

## 2. Navigation Flow

```
Main Navigation (Tab / Link)
        │
        ▼
  /reports  ──────────────────────── Report_history.dart
  (History list)                       │              │
       │                               │ Tap card     │ FAB
       │                               │              ▼
       │                        /reports/details   /reports/setup
       │                        (Report_datails)   (Report_setup)
       │                                │               │
       │                                │               │ Generate OK
       │                                │               ▼
       └────────────────────────────────┘        /reports/details
                                                  (Report_datails)
```

**Navigation rules:**
- `Report_history.dart` is the **entry point** — accessed from the main navigation tab.
- The FAB on history → pushes `Report_setup.dart`.
- `Report_setup.dart` navigates to `Report_datails.dart` on success by passing the generated `HealthReportModel` as `extra`.
- Tapping a history card navigates to `Report_datails.dart` passing the selected `HealthReportModel` as `extra`.
- `Report_datails.dart` is **read-only** — it receives the model, no cubit needed.

---

## 3. Routes to Add

### 3.1 — `lib/core/config/routing/app_routes.dart`

Add under the existing constants:

```dart
// 📊 Reports
static const String reportsHistory = '/reports';
static const String reportSetup    = '/reports/setup';
static const String reportDetails  = '/reports/details';
```

### 3.2 — `lib/core/config/routing/router_generation.dart`

Add three `GoRoute`s (imports + route definitions):

```dart
// Imports to add
import 'package:cureta/features/reports/veiw/Report_history.dart';
import 'package:cureta/features/reports/veiw/Report_setup.dart';
import 'package:cureta/features/reports/veiw/Report_datails.dart';
import 'package:cureta/features/reports/data/models/health_report_model.dart';

// Routes to add inside the routes: [...] list
GoRoute(
  path: AppRoutes.reportsHistory,
  name: AppRoutes.reportsHistory,
  pageBuilder: (context, state) => PageTransitions.scale(
    child: const ReportHistoryView(),
    state: state,
  ),
),
GoRoute(
  path: AppRoutes.reportSetup,
  name: AppRoutes.reportSetup,
  pageBuilder: (context, state) => PageTransitions.slideRight(
    child: const ReportSetupView(),
    state: state,
  ),
),
GoRoute(
  path: AppRoutes.reportDetails,
  name: AppRoutes.reportDetails,
  pageBuilder: (context, state) {
    final report = state.extra as HealthReportModel;
    return PageTransitions.slideRight(
      child: ReportDetailsView(report: report),
      state: state,
    );
  },
),
```

---

## 4. GetIt Registration to Add

Open `lib/core/Services/GetItServices.dart` and add **after** the existing report repo registration:

```dart
// 📊 Report Cubits
getIt.registerFactory<ReportHistoryCubit>(
  () => ReportHistoryCubit(getIt<ReportRepo>()),
);
getIt.registerFactory<ReportSetupCubit>(
  () => ReportSetupCubit(
    getIt<ReportRepo>(),
    getIt<ProfileRepository>(),
  ),
);
```

> **Import:** Add the new cubit imports at the top of `GetItServices.dart`.

---

## 5. Task 1 — State Management

Create all files inside `lib/features/reports/veiw_model/`.

---

### 5.1 — `report_history_state.dart`

```
sealed class ReportHistoryState extends Equatable

  ReportHistoryInitial
  ReportHistoryLoading
  ReportHistoryLoaded(List<HealthReportModel> reports)
  ReportHistoryEmpty
  ReportHistoryError(String messageKey)
```

**Rules:**
- Extend `Equatable`; include all fields in `props`.
- `ReportHistoryLoaded` must have `copyWith`.

---

### 5.2 — `report_history_cubit.dart`

**Constructor:** `ReportHistoryCubit(ReportRepo repo)`

**Methods:**

| Method | Behavior |
|---|---|
| `loadHistory()` | Emits `Loading` → calls `repo.getReportsHistory(profileId)` → emits `Loaded` or `Empty` (list is empty) or `Error` |
| `refresh()` | Same as `loadHistory()` — called by pull-to-refresh |

**Private helpers:**
- `_getProfileId()` → resolves from `ProfileRepository` via `getIt`

**Error handling:** Catch all exceptions, emit `ReportHistoryError('reports.error_loading_history')`.

---

### 5.3 — `report_setup_state.dart`

```
sealed class ReportSetupState extends Equatable

  ReportSetupInitial(timePeriod: 'month', language: 'en')
  ReportSetupUpdated(timePeriod: String, language: String)
  ReportSetupGenerating(timePeriod: String, language: String)
  ReportSetupSuccess(HealthReportModel report)
  ReportSetupError(String messageKey, timePeriod: String, language: String)
```

**Rules:**
- `ReportSetupInitial` holds default values: `timePeriod = 'month'`, `language = 'en'`.
- `ReportSetupUpdated` has `copyWith`.
- `ReportSetupGenerating` carries current selections so the UI stays populated.
- `ReportSetupError` carries current selections so the user does not lose them.

---

### 5.4 — `report_setup_cubit.dart`

**Constructor:** `ReportSetupCubit(ReportRepo repo, ProfileRepository profileRepo)`

**Methods:**

| Method | Behavior |
|---|---|
| `selectTimePeriod(String period)` | Emits `ReportSetupUpdated` with new period |
| `selectLanguage(String lang)` | Emits `ReportSetupUpdated` with new language |
| `generateReport()` | Reads current period+lang from state, emits `Generating` → calls `repo.generateReport(...)` → emits `Success(report)` or `Error(key)` |

**Private helpers:**
- `_currentData()` → extracts `(timePeriod, language)` tuple from current state
- `_getProfileId()` → resolves from `ProfileRepository`

---

## 6. Task 2 — Widgets Breakdown

All files in `lib/features/reports/widgets/`. Every file **≤ 100 lines**. All values from design tokens (no hardcoded pixels/colors/sizes).

---

### 6.1 — Shared / Reused

#### `report_section_header_widget.dart`

**Props:** `String titleKey`, `IconData? icon`

**Renders:**
- Row: optional `icon` (color: `primary`, size: `spacing.xl`) + `spacing.sm` gap + text (`typography.medicalRecordScreenTitle`, color: `textPrimary`)
- `SizedBox(height: spacing.xs)` below
- `Divider(color: colors.divider, thickness: spacing.hairline)`

---

### 6.2 — Setup Screen Widgets

#### `report_time_period_chip_widget.dart`

**Props:** `String labelKey`, `bool isSelected`, `VoidCallback onTap`

**Renders:** `ChoiceChip`-style container via `InkWell` + `AnimatedContainer`:
- Selected: background `primary`, border `primary`, text color `background`
- Unselected: background `surface`, border `divider`, text color `textSecondary`
- Border radius: `radius.full`
- Text style: `typography.medicalRecordChoice`
- Duration: `durations.normal`

---

#### `report_time_period_selector_widget.dart`

**Props:** `String selectedPeriod`, `ValueChanged<String> onSelected`

**Renders:** `Wrap` with `spacing: context.spacing.md` containing 3 `ReportTimePeriodChipWidget`s:

| `period` value | `labelKey` |
|---|---|
| `'week'` | `'reports.period_week'` |
| `'month'` | `'reports.period_month'` |
| `'3months'` | `'reports.period_3months'` |

---

#### `report_language_toggle_widget.dart`

**Props:** `String selectedLanguage`, `ValueChanged<String> onSelected`

**Renders:** Row with 2 items (`'en'` / `'ar'`):
- Each item: `InkWell` + `AnimatedContainer` pill
- Selected: background `primary`, text color `background`
- Unselected: background `surface`, border `divider`, text color `textSecondary`
- Labels: `'EN'` / `'عربي'` (hardcoded display — not localized since they are language names)
- Border radius: `radius.full`

---

### 6.3 — History Screen Widgets

#### `report_history_card_widget.dart`

**Props:** `HealthReportModel report`, `VoidCallback onTap`

**Renders:** `InkWell` → `Container` card:
- Background: `colors.surface`, border radius: `radius.lg`
- Border: `Border.all(color: colors.divider, width: spacing.hairline)`
- Padding: `EdgeInsets.all(spacing.lg)`
- Row layout:
  - **Left**: Column with:
    - Period badge (see below) + `spacing.xs` + date text
  - **Right**: `Icon(Icons.chevron_right, color: colors.icon)`

**Period badge:** `Container` with `colors.secondary` background, `radius.sm`, padding `sm/xs`, text `typography.medicalRecordProgress.copyWith(color: colors.primary)`, content: `report.timePeriod?.tr() ?? ''`

**Date text:** `typography.label.copyWith(color: colors.textSecondary)`, content: formatted `report.createdAt` (e.g. `'dd MMM yyyy'` via `intl`)

---

#### `report_history_shimmer_widget.dart`

**Renders:** `Shimmer.fromColors(baseColor: colors.divider, highlightColor: colors.surface)` wrapping a `ListView` of 4 skeleton cards (height 80, full width, `radius.lg` rounded).

---

#### `report_history_empty_state_widget.dart`

**Props:** `VoidCallback onGenerate`

**Renders:** Centered `Column`:
1. `Icon(Icons.insert_chart_outlined_rounded, size: spacing.xxl * 2, color: colors.icon)`
2. `SizedBox(height: spacing.xl)`
3. Title text: `typography.title.copyWith(color: colors.textPrimary)`, key: `'reports.empty_title'`
4. `SizedBox(height: spacing.md)`
5. Subtitle text: `typography.body.copyWith(color: colors.textSecondary)`, key: `'reports.empty_subtitle'`
6. `SizedBox(height: spacing.xxl)`
7. `ElevatedButton` → `onGenerate`, label: `'reports.generate_first'`, style: primary background, `radius.full`, vertical padding `spacing.md`

---

### 6.4 — Details Screen Widgets

#### `report_patient_header_widget.dart`

**Props:** `PatientInfoModel patient`

**Renders:** `Container` (background `secondary`, border radius `radius.xl`, padding `spacing.xl`):
- `CircleAvatar(radius: spacing.xxl, backgroundColor: colors.accentCyan, child: Icon(Icons.person, color: colors.primary, size: spacing.xl))`
- `SizedBox(height: spacing.md)`
- Name: `typography.title.copyWith(color: colors.textPrimary)`
- Age: `typography.body.copyWith(color: colors.textSecondary)` → `'reports.age_label'.tr() + ': ${patient.age}'`
- Blood type badge (if not null): pill container `accentOrange` bg, `radius.full`, `typography.label.copyWith(color: colors.textPrimary)`

---

#### `report_status_badge_widget.dart`

**Props:** `String status` (`'STABLE'` or `'ALERT'`)

**Renders:** `Container` pill:
- STABLE: background `colors.statusOnline.withValues(alpha: 0.1)`, text color `statusOnline`, icon `Icons.check_circle_outline`
- ALERT: background `colors.error.withValues(alpha: 0.1)`, text color `error`, icon `Icons.warning_amber_rounded`
- Padding: `EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.xs)`
- Border radius: `radius.full`
- Text style: `typography.medicalRecordDetailLabel`

---

#### `report_adherence_card_widget.dart`

**Props:** `AdherenceSummaryModel adherence`

**Renders:** `Container` card (surface, `radius.lg`, padding `spacing.xl`):
- Row, centered:
  - **Left**: `SizedBox(width: 80, height: 80)` → `CircularProgressIndicator` (value: `adherence.overallPercentage / 100`, color `primary`, backgroundColor `divider`, strokeWidth 8) + centered `Text` overlay (`'${adherence.overallPercentage}%'`, `typography.title`)
  - `SizedBox(width: spacing.xl)`
  - **Right Column**:
    - `'reports.adherence_rate'.tr()` → `typography.medicalRecordDetailLabel.copyWith(color: textSecondary)`
    - `SizedBox(height: spacing.xs)`
    - `'${adherence.activeMeds} ${'reports.active_meds'.tr()}'` → `typography.medicalRecordScreenTitle.copyWith(color: textPrimary)`

Use `Stack` to overlay the percentage text on the `CircularProgressIndicator`.

---

#### `report_ai_insights_card_widget.dart`

**Props:** `AiInsightsModel insights`

**Renders:** `Container` card (surface, `radius.lg`, padding `spacing.xl`, border `divider`):
1. Row: `ReportStatusBadgeWidget(status: insights.status)` + `Spacer`
2. `SizedBox(height: spacing.md)`
3. Bullet list: `...insights.summary.map((bullet) => _BulletItem(text: bullet))`
4. If `insights.correlationWarning.isNotEmpty`:
   - `SizedBox(height: spacing.md)`
   - Warning box: background `accentOrange`, `radius.md`, padding `spacing.md`, Row with `Icons.info_outline` (color `textPrimary`) + text `typography.medicalRecordDetailLabel.copyWith(color: textPrimary)` wrapped

**Private `_BulletItem`** (≤15 lines): Row with `Container(width: 6, height: 6, decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle))` + `spacing.sm` + `Expanded(child: Text(text, style: typography.body))`

---

#### `report_top_conditions_widget.dart`

**Props:** `List<TopConditionModel> conditions`

**Renders:**
- If empty: `SizedBox.shrink()`
- Otherwise: `Column` of up to 5 items, each is a `ListTile`-style Row:
  - Leading: `Container` (count, text `typography.medicalRecordStep`, background `accentBlue`, border radius `radius.sm`, size `spacing.xxl × spacing.xl`)
  - Title: `Text(condition.name, style: typography.medicalRecordDetailBody.copyWith(color: textPrimary))`
  - Divider between items (`Divider(color: divider, thickness: hairline)`)

---

#### `report_medication_bar_widget.dart`

**Props:** `MedicationTimelineModel medication`

**Renders:** `Column(crossAxisAlignment: CrossAxisAlignment.start)`:
1. Row: name text (`typography.medicalRecordDetailBody`, textPrimary) + Spacer + `'${medication.progress}%'` (`typography.medicalRecordProgress`, textSecondary)
2. `SizedBox(height: spacing.xs)`
3. `ClipRRect(borderRadius: radius.full, child: LinearProgressIndicator(value: medication.progress / 100, color: primary, backgroundColor: secondary, minHeight: spacing.xs))`
4. If `medication.instruction != null`: `SizedBox(height: spacing.xs / 2)` + instruction text (`typography.label`, textHint)
5. `SizedBox(height: spacing.lg)` (gap between bars)

---

#### `report_medications_timeline_widget.dart`

**Props:** `List<MedicationTimelineModel> medications`

**Renders:** `Column(children: medications.map((m) => ReportMedicationBarWidget(medication: m)).toList())`

---

## 7. Task 3 — Views

All files in `lib/features/reports/veiw/`. Each view ≤ 100 lines (delegates to widgets).

---

### 7.1 — `Report_history.dart` → `ReportHistoryView`

**Cubit:** `ReportHistoryCubit` (factory via `getIt`)

**Widget type:** `StatelessWidget` wrapping `BlocProvider` + `_ReportHistoryBody`

**`_ReportHistoryBody` structure:**

```
Scaffold
  backgroundColor: colors.background
  AppBar
    title: 'reports.my_reports'.tr()
    style: typography.medicalRecordScreenTitle
    backgroundColor: colors.background
    elevation: 0
    leading: back button (colors.textPrimary)
    actions: [RefreshIconButton → cubit.refresh()]
  body: BlocBuilder<ReportHistoryCubit, ReportHistoryState>
    ReportHistoryInitial  → SizedBox.shrink()
    ReportHistoryLoading  → ReportHistoryShimmerWidget()
    ReportHistoryEmpty    → ReportHistoryEmptyStateWidget(onGenerate: () => context.push(AppRoutes.reportSetup))
    ReportHistoryLoaded   → RefreshIndicator(
                              onRefresh: () => cubit.refresh(),
                              child: ListView.separated(
                                padding: EdgeInsetsDirectional.symmetric(horizontal: spacing.xl, vertical: spacing.md),
                                itemCount: state.reports.length,
                                separatorBuilder: (_, _) => SizedBox(height: spacing.md),
                                itemBuilder: (_, i) => ReportHistoryCardWidget(
                                  report: state.reports[i],
                                  onTap: () => context.push(AppRoutes.reportDetails, extra: state.reports[i]),
                                ),
                              ),
                            )
    ReportHistoryError    → _buildError(context, state.messageKey)
  floatingActionButton: FloatingActionButton.extended(
    onPressed: () async {
      await context.push(AppRoutes.reportSetup);
      if (context.mounted) context.read<ReportHistoryCubit>().loadHistory();
    },
    backgroundColor: colors.primary,
    foregroundColor: colors.background,
    icon: Icon(Icons.add_chart),
    label: Text('reports.new_report'.tr(), style: typography.medicalRecordButton),
  )
```

**`_buildError`:** Column with `Icons.error_outline` (48, error color) + message + ElevatedButton "Retry" → `cubit.loadHistory()`

**Init:** `BlocProvider.create: (_) => getIt<ReportHistoryCubit>()..loadHistory()`

---

### 7.2 — `Report_setup.dart` → `ReportSetupView`

**Cubit:** `ReportSetupCubit` (factory via `getIt`)

**Widget type:** `StatelessWidget` wrapping `BlocProvider` + `BlocConsumer`

**Listener (navigate on success):**
```dart
listenWhen: (prev, curr) => curr is ReportSetupSuccess,
listener: (context, state) {
  if (state is ReportSetupSuccess) {
    context.pop();                         // close setup
    context.push(AppRoutes.reportDetails, extra: state.report);
  }
}
```

**Builder structure:**

```
Scaffold
  backgroundColor: colors.background
  AppBar
    title: 'reports.generate_report'.tr()
    style: typography.medicalRecordScreenTitle
    leading: back button
    backgroundColor: colors.background, elevation: 0
  body: SafeArea
    SingleChildScrollView
      padding: EdgeInsets.all(spacing.xl)
      Column
        SizedBox(height: spacing.md)
        ── Time Period ──
        Text('reports.select_period'.tr(), style: typography.medicalRecordDetailLabel, color: textSecondary)
        SizedBox(height: spacing.md)
        ReportTimePeriodSelectorWidget(
          selectedPeriod: _period(state),
          onSelected: (p) => cubit.selectTimePeriod(p),
        )
        SizedBox(height: spacing.xl)
        ── Language ──
        Text('reports.select_language'.tr(), style: typography.medicalRecordDetailLabel, color: textSecondary)
        SizedBox(height: spacing.md)
        ReportLanguageToggleWidget(
          selectedLanguage: _language(state),
          onSelected: (l) => cubit.selectLanguage(l),
        )
        SizedBox(height: spacing.xxl)
        ── Generate Button ──
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isGenerating ? null : () => cubit.generateReport(),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.background,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius.full)),
              padding: EdgeInsets.symmetric(vertical: spacing.md),
              disabledBackgroundColor: colors.primary,
            ),
            child: isGenerating
              ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: colors.background))
              : Text('reports.generate'.tr(), style: typography.medicalRecordButton.copyWith(color: colors.background)),
          ),
        )
        ── Error (if any) ──
        if (state is ReportSetupError)
          Padding(
            padding: EdgeInsetsDirectional.only(top: spacing.md),
            child: Text(state.messageKey.tr(), style: typography.label.copyWith(color: colors.error), textAlign: TextAlign.center),
          )
```

**Helper getters (defined in the widget class):**
```dart
String _period(ReportSetupState s) => switch (s) {
  ReportSetupUpdated(:final timePeriod) => timePeriod,
  ReportSetupGenerating(:final timePeriod) => timePeriod,
  ReportSetupError(:final timePeriod) => timePeriod,
  _ => 'month',
};
String _language(ReportSetupState s) => switch (s) {
  ReportSetupUpdated(:final language) => language,
  ReportSetupGenerating(:final language) => language,
  ReportSetupError(:final language) => language,
  _ => 'en',
};
bool get _isGenerating => state is ReportSetupGenerating;
```

---

### 7.3 — `Report_datails.dart` → `ReportDetailsView`

**No cubit needed** — receives `HealthReportModel report` via constructor.

**Widget type:** `StatelessWidget`

**Structure:**

```
Scaffold
  backgroundColor: colors.background
  AppBar
    title: 'reports.report_details'.tr()
    style: typography.medicalRecordScreenTitle
    backgroundColor: colors.background
    elevation: 0
    leading: back button
  body: SafeArea
    SingleChildScrollView
      padding: EdgeInsetsDirectional.symmetric(horizontal: spacing.xl, vertical: spacing.md)
      Column
        ── 1. Patient Header ──
        ReportPatientHeaderWidget(patient: report.patientInfo)
        SizedBox(height: spacing.xl)

        ── 2. Adherence Summary ──
        ReportSectionHeaderWidget(titleKey: 'reports.adherence_summary', icon: Icons.medication_outlined)
        SizedBox(height: spacing.md)
        ReportAdherenceCardWidget(adherence: report.adherenceSummary)
        SizedBox(height: spacing.xl)

        ── 3. AI Insights ──
        ReportSectionHeaderWidget(titleKey: 'reports.ai_insights', icon: Icons.auto_awesome_outlined)
        SizedBox(height: spacing.md)
        ReportAiInsightsCardWidget(insights: report.aiInsights)
        SizedBox(height: spacing.xl)

        ── 4. Top Conditions ──
        if (report.topConditions.isNotEmpty) ...[
          ReportSectionHeaderWidget(titleKey: 'reports.top_conditions', icon: Icons.local_hospital_outlined)
          SizedBox(height: spacing.md)
          ReportTopConditionsWidget(conditions: report.topConditions)
          SizedBox(height: spacing.xl)
        ]

        ── 5. Medications Timeline ──
        if (report.medicationsTimeline.isNotEmpty) ...[
          ReportSectionHeaderWidget(titleKey: 'reports.medications_timeline', icon: Icons.schedule_outlined)
          SizedBox(height: spacing.md)
          ReportMedicationsTimelineWidget(medications: report.medicationsTimeline)
        ]

        SizedBox(height: spacing.xxl)
```

---

## 8. Task 4 — Wiring

After all cubits and views are written:

### 8.1 Register cubits in `GetItServices.dart`

```dart
import 'package:cureta/features/reports/veiw_model/report_history_cubit.dart';
import 'package:cureta/features/reports/veiw_model/report_setup_cubit.dart';

// inside setup():
getIt.registerFactory<ReportHistoryCubit>(
  () => ReportHistoryCubit(getIt<ReportRepo>()),
);
getIt.registerFactory<ReportSetupCubit>(
  () => ReportSetupCubit(getIt<ReportRepo>(), getIt<ProfileRepository>()),
);
```

### 8.2 Add routes to `router_generation.dart`

As specified in [Section 3.2](#32--libcoreconfigroutingrouter_generationdart).

### 8.3 Add route constants to `app_routes.dart`

As specified in [Section 3.1](#31--libcoreconfigroutingapp_routesdart).

---

## 9. Task 5 — Localization Keys

Add to both `assets/translations/en.json` and `assets/translations/ar.json` under a new top-level `"reports"` key:

### English (`en.json`)

```json
"reports": {
  "my_reports":          "My Reports",
  "new_report":          "New Report",
  "generate_report":     "Generate Health Report",
  "generate":            "Generate Report",
  "generate_first":      "Generate Your First Report",
  "select_period":       "Select Time Period",
  "select_language":     "Report Language",
  "period_week":         "Last Week",
  "period_month":        "Last Month",
  "period_3months":      "Last 3 Months",
  "report_details":      "Report Details",
  "adherence_summary":   "Adherence Summary",
  "adherence_rate":      "Adherence Rate",
  "active_meds":         "Active Medicines",
  "ai_insights":         "AI Insights",
  "top_conditions":      "Top Conditions",
  "medications_timeline":"Medications Timeline",
  "age_label":           "Age",
  "status_stable":       "Stable",
  "status_alert":        "Alert",
  "empty_title":         "No Reports Yet",
  "empty_subtitle":      "Generate your first health report to track your progress.",
  "error_loading_history":"Failed to load reports. Please try again.",
  "error_generating":    "Failed to generate report. Please try again."
}
```

### Arabic (`ar.json`)

```json
"reports": {
  "my_reports":           "تقاريري",
  "new_report":           "تقرير جديد",
  "generate_report":      "إنشاء تقرير صحي",
  "generate":             "إنشاء التقرير",
  "generate_first":       "أنشئ تقريرك الأول",
  "select_period":        "اختر الفترة الزمنية",
  "select_language":      "لغة التقرير",
  "period_week":          "الأسبوع الماضي",
  "period_month":         "الشهر الماضي",
  "period_3months":       "آخر 3 أشهر",
  "report_details":       "تفاصيل التقرير",
  "adherence_summary":    "ملخص الالتزام",
  "adherence_rate":       "نسبة الالتزام",
  "active_meds":          "أدوية نشطة",
  "ai_insights":          "تحليلات الذكاء الاصطناعي",
  "top_conditions":       "أبرز الحالات",
  "medications_timeline": "جدول الأدوية",
  "age_label":            "العمر",
  "status_stable":        "مستقر",
  "status_alert":         "تحذير",
  "empty_title":          "لا توجد تقارير بعد",
  "empty_subtitle":       "أنشئ تقريرك الصحي الأول لمتابعة تقدمك.",
  "error_loading_history":"فشل تحميل التقارير. الرجاء المحاولة مرة أخرى.",
  "error_generating":     "فشل إنشاء التقرير. الرجاء المحاولة مرة أخرى."
}
```

---

## 10. Implementation Order

Implement in this exact order — each step can only start when the previous is ✅ done and compiles cleanly.

```
Step 1  app_routes.dart         ← add 3 route constants
   ↓
Step 2  report_history_state.dart
   ↓
Step 3  report_history_cubit.dart
   ↓
Step 4  report_setup_state.dart
   ↓
Step 5  report_setup_cubit.dart
   ↓
Step 6  GetItServices.dart      ← register 2 new cubits
   ↓
Step 7  Localization             ← add keys to en.json + ar.json
   ↓
Step 8  ── Widgets (parallelizable after Step 7) ──
        report_section_header_widget.dart
        report_status_badge_widget.dart
        report_time_period_chip_widget.dart
        report_time_period_selector_widget.dart
        report_language_toggle_widget.dart
        report_history_card_widget.dart
        report_history_shimmer_widget.dart
        report_history_empty_state_widget.dart
        report_patient_header_widget.dart
        report_adherence_card_widget.dart
        report_ai_insights_card_widget.dart
        report_top_conditions_widget.dart
        report_medication_bar_widget.dart
        report_medications_timeline_widget.dart
   ↓
Step 9  ── Views (after all their widgets exist) ──
        Report_datails.dart    ← no cubit, only widgets
        Report_setup.dart
        Report_history.dart
   ↓
Step 10 router_generation.dart  ← add 3 routes
   ↓
Step 11 flutter analyze         ← zero errors, zero warnings
```

---

## 11. Compliance Checklist

Before marking any file complete, verify **every** item:

- [ ] **No hardcoded colors** — all from `context.colors.*`
- [ ] **No hardcoded font sizes** — all from `context.typography.*`
- [ ] **No hardcoded spacing** — all from `context.spacing.*`
- [ ] **No hardcoded radii** — all from `context.radius.*`
- [ ] **No hardcoded durations** — all from `context.durations.*`
- [ ] **No ScreenUtil** — `.w` / `.h` / `.sp` are forbidden
- [ ] **RTL-safe** — `EdgeInsetsDirectional`, `AlignmentDirectional`, `TextAlign.start`
- [ ] **All strings localized** — `'reports.key'.tr()`, never hardcoded English
- [ ] **No `setState`** — all state via Cubit emit
- [ ] **No logic in UI** — business logic in Cubit methods only
- [ ] **GetIt DI** — cubits created via `getIt<CubitName>()`
- [ ] **File ≤ ~100 lines** — if over limit, extract a widget
- [ ] **Sealed states with Equatable** — all state props listed
- [ ] **`const` constructors** — used wherever possible
- [ ] **No cross-feature imports** — no imports from `medicines/`, `chat_bot/`, etc.
- [ ] **Widgets are pure** — no Bloc reads inside widgets, all data via constructor

---

> **Last Updated:** 2026-06-13
> **Feature:** Reports (Health Report Generation + History + Details)
> **Architecture:** Clean Architecture + Cubit MVVM
> **Screens:** `Report_history.dart` → `Report_setup.dart` → `Report_datails.dart`

---

## Amendment A — Profile Selector on Setup Screen

> **Why:** The original plan silently auto-resolved the currently selected profile.
> The user must be able to **choose any profile** (primary or family) before generating a report.
> Source: `ProfileRepository.getProfiles()` → `List<ProfileModel>`.

---

### A.1 — What `ProfileModel` provides

| Field | Type | Used for |
|---|---|---|
| `id` | `String` | Sent as `profileId` to the API |
| `fullName` | `String` | Displayed name in the selector chip |
| `relationship` | `String` | Sub-label (`'Self'`, `'Son'`, …) |
| `isPrimary` | `bool` | Badge / default selection |
| `imageUrl` | `String?` | Avatar via `CachedNetworkImage` (fallback: initials) |

---

### A.2 — Updated `report_setup_state.dart`

Add two new fields to **every state that holds form data** (`ReportSetupInitial`, `ReportSetupUpdated`, `ReportSetupGenerating`, `ReportSetupError`):

```dart
final List<ProfileModel> profiles;        // all loaded profiles
final ProfileModel?      selectedProfile; // null = nothing chosen yet
```

Full sealed class after changes:

```
sealed class ReportSetupState extends Equatable

  ReportSetupInitial(
    timePeriod:      'month',
    language:        'en',
    profiles:        [],
    selectedProfile: null,
  )

  ReportSetupUpdated(
    timePeriod:      String,
    language:        String,
    profiles:        List<ProfileModel>,
    selectedProfile: ProfileModel?,
  )                    ← has copyWith for all 4 fields

  ReportSetupGenerating(
    timePeriod:      String,
    language:        String,
    profiles:        List<ProfileModel>,
    selectedProfile: ProfileModel?,
  )

  ReportSetupSuccess(HealthReportModel report)

  ReportSetupError(
    messageKey:      String,
    timePeriod:      String,
    language:        String,
    profiles:        List<ProfileModel>,
    selectedProfile: ProfileModel?,
  )
```

**Equatable props** must include `profiles` and `selectedProfile` in all states that carry them.

---

### A.3 — Updated `report_setup_cubit.dart`

**Constructor:**
```dart
ReportSetupCubit(ReportRepo repo, ProfileRepository profileRepo)
```

**New / changed methods:**

| Method | Behavior |
|---|---|
| `init()` ← **NEW** | Calls `profileRepo.getProfiles()`. On success, emits `ReportSetupUpdated` with `profiles = result` and `selectedProfile = result.firstWhere((p) => p.isPrimary, orElse: () => result.first)` (pre-selects primary). On error, emits `ReportSetupError` with `messageKey: 'reports.error_loading_profiles'`. |
| `selectProfile(ProfileModel profile)` ← **NEW** | Emits `ReportSetupUpdated` with `selectedProfile = profile` (all other fields preserved via `copyWith`). |
| `selectTimePeriod(String period)` | Unchanged — emits `copyWith(timePeriod: period)`. |
| `selectLanguage(String lang)` | Unchanged — emits `copyWith(language: lang)`. |
| `generateReport()` | **Changed:** uses `state.selectedProfile?.id` first; falls back to `profileRepo.getResolvedSelectedProfileId()` only if `selectedProfile` is null. Preserves `profiles` + `selectedProfile` in `ReportSetupGenerating` and `ReportSetupError`. |

**`_currentData()` private helper** — now extracts a `_SetupData` record containing `timePeriod`, `language`, `profiles`, and `selectedProfile`:

```dart
// Private helper
(_SetupData) _currentData() => switch (state) {
  ReportSetupUpdated s    => (s.timePeriod, s.language, s.profiles, s.selectedProfile),
  ReportSetupGenerating s => (s.timePeriod, s.language, s.profiles, s.selectedProfile),
  ReportSetupError s      => (s.timePeriod, s.language, s.profiles, s.selectedProfile),
  _                       => ('month', 'en', <ProfileModel>[], null),
};
```

**Init in BlocProvider:** Call `getIt<ReportSetupCubit>()..init()` — not just `getIt<ReportSetupCubit>()`.

---

### A.4 — New Widget: `report_profile_selector_widget.dart`

**File:** `lib/features/reports/widgets/report_profile_selector_widget.dart`

**Props:**
```dart
const ReportProfileSelectorWidget({
  required List<ProfileModel> profiles,
  required ProfileModel?      selectedProfile,
  required ValueChanged<ProfileModel> onSelected,
});
```

**Renders:**

```
SizedBox(
  height: spacing.xxl * 3,           // ~96 px on mobile, fluid on tablet
  child: ListView.separated(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsetsDirectional.symmetric(horizontal: spacing.xl),
    separatorBuilder: (_, _) => SizedBox(width: spacing.md),
    itemCount: profiles.length,
    itemBuilder: (context, i) => _ProfileChip(
      profile:    profiles[i],
      isSelected: selectedProfile?.id == profiles[i].id,
      onTap:      () => onSelected(profiles[i]),
    ),
  ),
)
```

**Private `_ProfileChip`** (extract into same file, ≤ 50 lines):

```
InkWell(onTap: onTap, borderRadius: radius.lg)
  AnimatedContainer(
    duration: durations.normal,
    width: spacing.xxl * 3,
    padding: EdgeInsets.all(spacing.sm),
    decoration: BoxDecoration(
      color:        isSelected ? colors.secondary : colors.surface,
      borderRadius: radius.lg,
      border: Border.all(
        color: isSelected ? colors.primary : colors.divider,
        width: isSelected ? 2 : spacing.hairline,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _avatar(profile),                   // see below
        SizedBox(height: spacing.xs),
        Text(
          profile.fullName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: typography.medicalRecordProgress.copyWith(
            color: isSelected ? colors.primary : colors.textPrimary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: spacing.xs / 2),
        Text(
          profile.relationship,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: typography.label.copyWith(color: colors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  )
```

**`_avatar(ProfileModel profile)` rules:**
- If `profile.imageUrl != null && profile.imageUrl!.isNotEmpty`:
  → `CircleAvatar(radius: spacing.xl, backgroundImage: CachedNetworkImageProvider(profile.imageUrl!))`
- Otherwise:
  → `CircleAvatar(radius: spacing.xl, backgroundColor: colors.accentCyan, child: Text(profile.fullName[0].toUpperCase(), style: typography.medicalRecordScreenTitle.copyWith(color: colors.primary)))`

**Primary badge:** If `profile.isPrimary`, show a small `Icon(Icons.star_rounded, color: colors.primary, size: spacing.md)` overlaid at top-right using `Stack`.

---

### A.5 — Updated `Report_setup.dart` View

Insert the profile selector as the **first** section, above time period:

```
Column
  SizedBox(height: spacing.md)
  ── Profile ── ← NEW
  Text('reports.select_profile'.tr(),
       style: typography.medicalRecordDetailLabel.copyWith(color: textSecondary),
       padding: EdgeInsetsDirectional.only(start: spacing.xl))
  SizedBox(height: spacing.md)
  ReportProfileSelectorWidget(
    profiles:        _profiles(state),
    selectedProfile: _selectedProfile(state),
    onSelected:      (p) => cubit.selectProfile(p),
  )
  SizedBox(height: spacing.xl)
  ── Time Period ── (unchanged from original plan)
  ...
```

**New private helper getters in the builder:**

```dart
List<ProfileModel> _profiles(ReportSetupState s) => switch (s) {
  ReportSetupUpdated s    => s.profiles,
  ReportSetupGenerating s => s.profiles,
  ReportSetupError s      => s.profiles,
  _                       => const [],
};

ProfileModel? _selectedProfile(ReportSetupState s) => switch (s) {
  ReportSetupUpdated s    => s.selectedProfile,
  ReportSetupGenerating s => s.selectedProfile,
  ReportSetupError s      => s.selectedProfile,
  _                       => null,
};
```

**Loading state guard:**
While profiles are loading (`profiles.isEmpty && state is not Error`), show a horizontal shimmer row in place of `ReportProfileSelectorWidget`:

```dart
if (_profiles(state).isEmpty)
  _ProfileSelectorShimmer()       // 4 skeleton circles in a Row
else
  ReportProfileSelectorWidget(...)
```

`_ProfileSelectorShimmer` is a private widget (≤ 30 lines) using `Shimmer.fromColors`.

**Generate button guard:** Disable the generate button (show spinner) not only when `isGenerating` but also when `_profiles(state).isEmpty`:

```dart
final canGenerate = !isGenerating && _profiles(state).isNotEmpty;
onPressed: canGenerate ? () => cubit.generateReport() : null,
```

---

### A.6 — New Localization Keys (add to existing `"reports"` block)

**English (`en.json`):**

```json
"select_profile":           "Select Profile",
"error_loading_profiles":   "Failed to load profiles. Please try again."
```

**Arabic (`ar.json`):**

```json
"select_profile":           "اختر الملف الشخصي",
"error_loading_profiles":   "فشل تحميل الملفات الشخصية. الرجاء المحاولة مرة أخرى."
```

---

### A.7 — Updated Implementation Order

Insert these changes into **Step 2–8** of the original order:

```
Step 2  report_history_state.dart          (unchanged)
   ↓
Step 3  report_history_cubit.dart          (unchanged)
   ↓
Step 4  report_setup_state.dart            ← ADD profiles + selectedProfile to all form states
   ↓
Step 5  report_setup_cubit.dart            ← ADD init(), selectProfile(); UPDATE generateReport()
   ↓
Step 6  GetItServices.dart                 (unchanged)
   ↓
Step 7  Localization                       ← ADD 2 new keys
   ↓
Step 8  Widgets (add to the parallel block)
        report_profile_selector_widget.dart  ← NEW (includes _ProfileChip + _ProfileSelectorShimmer)
        ... (all original widgets unchanged)
   ↓
Step 9  Views
        Report_setup.dart                  ← ADD profile section at top; update BlocProvider to ..init()
        ... (Report_datails + Report_history unchanged)
```

---

### A.8 — Compliance Additions

In addition to the original checklist, verify for `ReportProfileSelectorWidget` and `_ProfileChip`:

- [ ] `CachedNetworkImage` used for remote avatars — **never** `Image.network`
- [ ] Initials fallback uses `fullName[0]` — guard against empty string: `profile.fullName.isNotEmpty ? profile.fullName[0].toUpperCase() : '?'`
- [ ] Horizontal `ListView` uses `scrollDirection: Axis.horizontal` with `EdgeInsetsDirectional` padding
- [ ] `AnimatedContainer` duration from `context.durations.normal` — not hardcoded
- [ ] `isPrimary` star badge is overlaid with `Stack` + `Positioned` using `DirectionalPositioned` or `top: 0, end: 0`
- [ ] Profile `id` used for selected comparison — **never** compare by object reference (`profile == selectedProfile` is wrong; use `profile.id == selectedProfile?.id`)
