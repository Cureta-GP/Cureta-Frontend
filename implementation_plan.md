# Flutter Reports Feature — Data Layer Plan

Plan for creating Models, Service, and Repository for the health reports feature following [Cureta Clean Architecture](file:///C:/Users/compumarts/.gemini/antigravity-ide/knowledge/cureta-styling-guidelines/artifacts/STYLING_GUIDELINES.md#L463-L495).

---

## API Response Reference

### `POST /api/reports/generate` Response
```json
{
  "status": "success",
  "data": {
    "patient_info": {
      "name": "Abdallah Ali",
      "age": 24,
      "blood_type": "O+"
    },
    "adherence_summary": {
      "active_meds": 3,
      "overall_percentage": 85
    },
    "top_conditions": [
      { "name": "Headache", "count": 5 },
      { "name": "Fatigue", "count": 3 }
    ],
    "medications_timeline": [
      { "name": "Vitamin D", "instruction": "1000 IU", "progress": 90 },
      { "name": "Aspirin", "instruction": "100mg", "progress": 60 }
    ],
    "ai_insights": {
      "status": "STABLE",
      "summary": ["Bullet 1", "Bullet 2", "Bullet 3"],
      "correlation_warning": "Some correlation text..."
    }
  }
}
```

### `GET /api/reports/:profile_id` Response
Same structure as above but wrapped in an **array**, with extra `id`, `profile_id`, `time_period`, and `created_at` fields per item.

---

## Proposed File Structure

```
lib/features/reports/
├── data/
│   ├── models/
│   │   ├── health_report_model.dart        # Main report model
│   │   ├── patient_info_model.dart         # patient_info sub-model
│   │   ├── adherence_summary_model.dart    # adherence_summary sub-model
│   │   ├── top_condition_model.dart        # top_conditions item model
│   │   ├── medication_timeline_model.dart  # medications_timeline item model
│   │   └── ai_insights_model.dart          # ai_insights sub-model
│   ├── services/
│   │   └── report_service.dart             # Raw API calls
│   └── repo/
│       └── report_repo.dart                # Repository layer
├── veiw_model/                             # (Cubit + States — not in scope here)
├── veiw/                                   # (Screens — not in scope here)
└── widgets/                                # (UI components — not in scope here)
```

---

## Proposed Changes

### Models

#### [NEW] `patient_info_model.dart`
```dart
class PatientInfoModel {
  final String name;
  final int age;
  final String? bloodType;

  const PatientInfoModel({
    required this.name,
    required this.age,
    this.bloodType,
  });

  factory PatientInfoModel.fromJson(Map<String, dynamic> json) {
    return PatientInfoModel(
      name: json['name'] as String,
      age: json['age'] as int,
      bloodType: json['blood_type'] as String?,
    );
  }
}
```

---

#### [NEW] `adherence_summary_model.dart`
```dart
class AdherenceSummaryModel {
  final int activeMeds;
  final int overallPercentage;

  const AdherenceSummaryModel({
    required this.activeMeds,
    required this.overallPercentage,
  });

  factory AdherenceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AdherenceSummaryModel(
      activeMeds: json['active_meds'] as int,
      overallPercentage: json['overall_percentage'] as int,
    );
  }
}
```

---

#### [NEW] `top_condition_model.dart`
```dart
class TopConditionModel {
  final String name;
  final int count;

  const TopConditionModel({
    required this.name,
    required this.count,
  });

  factory TopConditionModel.fromJson(Map<String, dynamic> json) {
    return TopConditionModel(
      name: json['name'] as String,
      count: json['count'] as int,
    );
  }
}
```

---

#### [NEW] `medication_timeline_model.dart`
```dart
class MedicationTimelineModel {
  final String name;
  final String? instruction;
  final int progress;

  const MedicationTimelineModel({
    required this.name,
    this.instruction,
    required this.progress,
  });

  factory MedicationTimelineModel.fromJson(Map<String, dynamic> json) {
    return MedicationTimelineModel(
      name: json['name'] as String,
      instruction: json['instruction'] as String?,
      progress: json['progress'] as int,
    );
  }
}
```

---

#### [NEW] `ai_insights_model.dart`
```dart
class AiInsightsModel {
  final String status;             // 'STABLE' or 'ALERT'
  final List<String> summary;     // 3 bullet points
  final String correlationWarning;

  const AiInsightsModel({
    required this.status,
    required this.summary,
    required this.correlationWarning,
  });

  factory AiInsightsModel.fromJson(Map<String, dynamic> json) {
    return AiInsightsModel(
      status: json['status'] as String,
      summary: List<String>.from(json['summary'] as List),
      correlationWarning: json['correlation_warning'] as String? ?? '',
    );
  }
}
```

---

#### [NEW] `health_report_model.dart`
The main model — used for **both** generate response and history items.

```dart
class HealthReportModel {
  final String? id;                // null on generate, present on history
  final String? profileId;         // null on generate, present on history
  final String? timePeriod;        // null on generate, present on history
  final PatientInfoModel patientInfo;
  final AdherenceSummaryModel adherenceSummary;
  final List<TopConditionModel> topConditions;
  final List<MedicationTimelineModel> medicationsTimeline;
  final AiInsightsModel aiInsights;
  final DateTime? createdAt;       // null on generate, present on history

  const HealthReportModel({
    this.id,
    this.profileId,
    this.timePeriod,
    required this.patientInfo,
    required this.adherenceSummary,
    required this.topConditions,
    required this.medicationsTimeline,
    required this.aiInsights,
    this.createdAt,
  });

  factory HealthReportModel.fromJson(Map<String, dynamic> json) {
    return HealthReportModel(
      id: json['id'] as String?,
      profileId: json['profile_id'] as String?,
      timePeriod: json['time_period'] as String?,
      patientInfo: PatientInfoModel.fromJson(
        json['patient_info'] as Map<String, dynamic>,
      ),
      adherenceSummary: AdherenceSummaryModel.fromJson(
        json['adherence_summary'] as Map<String, dynamic>,
      ),
      topConditions: (json['top_conditions'] as List)
          .map((e) => TopConditionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      medicationsTimeline: (json['medications_timeline'] as List)
          .map((e) =>
              MedicationTimelineModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      aiInsights: AiInsightsModel.fromJson(
        json['ai_insights'] as Map<String, dynamic>,
      ),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }
}
```

---

### Service

#### [NEW] `report_service.dart`
Raw API calls via `DioHelper`.

```dart
class ReportService {
  /// POST /api/reports/generate
  Future<Response> generateReport({
    required String profileId,
    required String timePeriod,
    String language = 'en',
  }) async {
    return await DioHelper.postData(
      path: 'reports/generate',
      data: {
        'profile_id': profileId,
        'time_period': timePeriod,
        'language': language,
      },
    );
  }

  /// GET /api/reports/:profileId
  Future<Response> getReportsHistory({
    required String profileId,
  }) async {
    return await DioHelper.getData(
      path: 'reports/$profileId',
    );
  }
}
```

---

### Repository

#### [NEW] `report_repo.dart`
Handles error mapping and JSON → Model conversion.

```dart
class ReportRepo {
  final ReportService _service;

  ReportRepo(this._service);

  /// Generate a new health report
  Future<HealthReportModel> generateReport({
    required String profileId,
    required String timePeriod,
    String language = 'en',
  }) async {
    try {
      final response = await _service.generateReport(
        profileId: profileId,
        timePeriod: timePeriod,
        language: language,
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return HealthReportModel.fromJson(data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Fetch all past reports for a profile
  Future<List<HealthReportModel>> getReportsHistory({
    required String profileId,
  }) async {
    try {
      final response = await _service.getReportsHistory(
        profileId: profileId,
      );
      final list = response.data['data'] as List;
      return list
          .map((e) =>
              HealthReportModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic e) {
    // Follow existing project error handling pattern
    // (e.g., ServerException, map DioException → user-friendly message)
    return e is Exception ? e : Exception(e.toString());
  }
}
```

---

### Dependency Injection

#### [MODIFY] `GetItServices.dart`
Add the following registrations in the existing registration order (Services → Repos → Cubits):

```dart
// ── Reports ──
getIt.registerSingleton<ReportService>(ReportService());
getIt.registerSingleton<ReportRepo>(ReportRepo(getIt<ReportService>()));
// Cubit registration will be added when building the veiw_model layer
```

---

## Open Questions

> [!IMPORTANT]
> 1. **أسماء الملفات والمجلدات:** لاحظت أن المشروع يستخدم `veiw_model` و `veiw` (وليس `view_model` / `view`). هل تريدني أتبع نفس الأسلوب؟
> 2. **Error Handling:** هل المشروع يستخدم كلاس خطأ معين (مثل `ServerException` أو `ApiException`)؟ لو ممكن تقولي اسمه عشان أستخدمه في الـ `_handleError` في الريبو.
> 3. **أسماء الـ methods في `DioHelper`:** هل أسماء الميثودز هي `postData` و `getData` ولا أسماء مختلفة؟ عشان أعدل الـ Service لو فيه اختلاف.

## Allowed `time_period` Values (for enum/constants)

| Value             | Description   |
|-------------------|---------------|
| `last_7_days`     | آخر 7 أيام   |
| `last_month`      | آخر شهر      |
| `last_3_months`   | آخر 3 أشهر   |
| `all_time`        | طوال الوقت    |

## Allowed `language` Values

| Value | Description       |
|-------|-------------------|
| `ar`  | عربي (عامية مصرية)|
| `en`  | English (default) |
