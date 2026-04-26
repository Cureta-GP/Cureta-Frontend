Based on the comprehensive project analysis, here are the two deliverables:

---

## 1. Architectural Acknowledgment & Refactor Plan

### Rule Confirmation

| Constraint | Acknowledgment |
|---|---|
| **Clean Architecture** | Three-layer separation: `data/` (models, services, repo) → `veiw_model/` (Cubit + states) → `veiw/` (screens + widgets). Data flows Service → Repository → Cubit → View. |
| **Cubit Pattern** | All state via `flutter_bloc` Cubits extending `Cubit<State>` with `Equatable` states. No `setState()`. Cubits registered as factories in `GetIt`. Provided via `BlocProvider`, consumed via `BlocBuilder`/`BlocConsumer`. |
| **Fluid UI Tokens** | Zero hardcoded values. All colors via `context.colors.*`, spacing via `context.spacing.*`, typography via `context.typography.*`, radii via `context.radius.*`, durations via `context.durations.*`. No ScreenUtil. |
| **Folder Naming** | Follow existing convention: `data/` (models, services, repo), `veiw_model/`, `veiw/`, `widgets/`. Note: project uses `veiw`/`veiw_model` (misspelled) consistently in auth, chat_bot, medical_records, and medicins_alert — maintain this convention for consistency. |
| **DI Registration** | Services as singletons → Repositories as singletons → Cubits as factories in `GetItServices.dart`. |
| **No Cross-Feature Imports** | Shared code goes to `lib/shared/widgets/`. Feature-specific extracted components go to `lib/features/medicins_alert/widgets/`. |
| **RTL / Arabic First** | `EdgeInsetsDirectional`, `AlignmentDirectional`, `TextAlign.start`. All strings via `easy_localization` keys. |
| **File Length** | ≤ ~100 lines per file. Extract sub-widgets into `widgets/` directory. |
| **Hybrid Sync** | `sqflite` for offline-first local storage + `DioHelper` for remote API. Sync status tracking on every record. |

### UI Refactor Strategy — Hardcoded Value Replacement

All 5 view files are raw Figma-to-code exports. Every hardcoded value must be replaced with design tokens:

| Hardcoded Pattern | Occurrences (approx) | Replacement Token |
|---|---|---|
| `Color(0xFF00A0A8)` / `Color(0xFF00A1A9)` | ~30+ | `context.colors.primary` |
| `Color(0xFF0F172A)` / `Color(0xFF0D1B1B)` / `Color(0xFF0C1C1D)` | ~20+ | `context.colors.textPrimary` |
| `Color(0xFF64748B)` / `Color(0xFF4F6364)` / `Color(0xFF459CA1)` | ~15+ | `context.colors.textSecondary` |
| `Color(0xFF878B94)` / `Color(0xFF94A3B8)` | ~10+ | `context.colors.textHint` |
| `Color(0xFFF8FCFC)` / `Color(0xFFF6F8F8)` / `Color(0xFFF5F8F8)` | ~8+ | `context.colors.surface` / `context.colors.chatBackground` |
| `Color(0xFFE2E8F0)` / `Color(0xFFE0E0E0)` / `Color(0xFFE5E7EB)` | ~5+ | `context.colors.divider` |
| `Color(0xFFEDF7F8)` / `Color(0xFFE5F5F6)` / `Color(0xFFE0F1F3)` / `Color(0xFFEFF6FF)` / `Color(0xFFE7FCFD)` | ~8+ | `context.colors.secondary` / `context.colors.accentCyan` / `context.colors.accentBlue` |
| `Color(0xFFFFEDD5)` | ~2 | `context.colors.accentOrange` |
| `Color(0xFFDBEAFE)` | ~1 | `context.colors.accentBlue` |
| `Colors.white` | ~10+ | `context.colors.background` |
| Hardcoded `fontSize: 28/32/36` | ~8 | `context.typography.*` (heading styles) |
| Hardcoded `fontSize: 18/20` | ~10 | `context.typography.*` (title styles) |
| Hardcoded `fontSize: 14/16` | ~15 | `context.typography.*` (body styles) |
| Hardcoded `fontSize: 12` | ~8 | `context.typography.*` (caption styles) |
| `fontFamily: 'Lexend'` | ~all | Removed — handled by `AppTypography` |
| `fontFamily: 'Material Icons'` | ~all | Replaced with `Icon()` widget + `context.colors.*` |
| Hardcoded padding `24, 16, 8, 32` | ~40+ | `context.spacing.xl`, `context.spacing.lg`, `context.spacing.xs`, `context.spacing.xxl` |
| `borderRadius: 9999` / `32` / `24` / `16` | ~20+ | `context.radius.full`, `context.radius.xl`, `context.radius.lg` |
| Hardcoded `width: 375` / `360` | ~5 | Remove fixed widths — use `double.infinity` or `MediaQuery` |
| Text widgets showing icon names (`'close'`, `'arrow_back'`, `'schedule'`) | ~15+ | Replace with `Icon(Icons.close)` etc. |
| `Positioned` with negative/overflow coords | ~4 | Remove — restructure layout properly |
| `Stack` with overflow | ~3 | Replace with proper `Column`/`Row` layouts |

**Structural Refactors (beyond token replacement):**

| File | Issue | Fix |
|---|---|---|
| `add_medicine_first_step.dart` | Only file with `StatelessWidget` wrapper, but inner tree is monolithic | Extract header, progress bar, input field, CTA button into separate widget files |
| `add_medicine_second_step.dart` | Raw `Container()` export, no widget class | Wrap in `StatelessWidget`, extract time picker, frequency selector, CTA |
| `add_medicine_third_step.dart` | Raw `Container()` export, `Positioned` elements with off-screen coordinates | Wrap in `StatelessWidget`, extract meal timing cards, notes field |
| `add_medicine_forth_step.dart` | Raw `Container()` export, truncated file | Wrap in `StatelessWidget`, extract review card, edit/save actions |
| `Users_medicines.dart` | Raw `ConstrainedBox` export, duplicate medicine cards inline | Wrap in `StatelessWidget`, extract `MedicineCard` widget, use `ListView.builder` |
| All files | Icon names as `Text('close', fontFamily: 'Material Icons')` | Replace with `Icon(Icons.close)` |

---

## 2. `medicine_spec.md` — Technical Specification

```markdown
# Medicine & Alerts — Technical Specification

## 1. User Stories

### Medicine Management
| ID | User Story | Acceptance Criteria |
|----|-----------|---------------------|
| US-MED-001 | As a patient, I need to search for my medicine by name so I can add it quickly. | Search field with autocomplete; camera scan fallback; result populates Step 1 form. |
| US-MED-002 | As a patient, I need to specify the dosage and form (capsule, tablet, etc.) so the reminder is accurate. | Dosage field accepts number + unit; form selector from predefined list. |
| US-MED-003 | As a patient, I need to set a specific time for each dose so I receive the alarm at the right moment. | Hour/minute scroll picker; AM/PM toggle; supports multiple times per day. |
| US-MED-004 | As a patient, I need to select a frequency (daily, twice daily, as needed) so the schedule matches my prescription. | Frequency selector with visual cards; selection highlights with primary color. |
| US-MED-005 | As a patient, I need to indicate meal timing (before/after food) so I take medicine correctly. | Before Meal / After Meal toggle cards; optional field. |
| US-MED-006 | As a patient, I need to add notes (e.g., "take with full glass of water") for personal reminders. | Free-text field; optional; max 500 chars. |
| US-MED-007 | As a patient, I need to review all details before saving so I can catch mistakes. | Review card shows medicine name, dosage, schedule, meal timing; "Edit Details" returns to relevant step. |
| US-MED-008 | As a patient, I need to edit an existing medicine's schedule so I can adjust to prescription changes. | Edit flow re-opens the 5-step wizard pre-filled with current values. |
| US-MED-009 | As a patient, I need to delete a medicine and its associated alarms. | Swipe-to-delete or delete action; confirmation dialog; cancels scheduled alarms. |

### Alarms & Scheduling
| ID | User Story | Acceptance Criteria |
|----|-----------|---------------------|
| US-ALM-001 | As a patient, I need to receive alarms even without an internet connection. | Alarms scheduled via local OS alarm manager; fire offline; use sqflite as source of truth. |
| US-ALM-002 | As a patient, I need the alarm to show the medicine name, dosage, and meal instruction. | Notification payload includes name, dose, meal timing; taps open the medicine detail. |
| US-ALM-003 | As a patient, I need to mark a dose as "taken" or "skipped" directly from the alarm notification. | Action buttons on notification; updates local DB immediately; syncs when online. |
| US-ALM-004 | As a patient, I need to see a list of all my medicines with next-dose times on the main screen. | `Users_medicines.dart` shows cards sorted by next alarm; active toggle per medicine. |

### Synchronization
| ID | User Story | Acceptance Criteria |
|----|-----------|---------------------|
| US-SYN-001 | As a patient, I need my medicines synced to the cloud so I can access them on another device. | Auto-sync when connectivity restored; `sync_status` field tracks pending uploads. |
| US-SYN-002 | As a patient, I need conflicts between local and remote data resolved without data loss. | Last-write-wins with timestamp; user notified of conflicts. |
| US-SYN-003 | As a patient, I need offline changes preserved even if the app is killed. | All mutations written to sqflite first; sync queue persists across app restarts. |

---

## 2. Data Mapping & Schema Design

### 2.1 SQLite Schema (Offline-First)

```sql
CREATE TABLE medicines (
  id                  TEXT PRIMARY KEY,       -- UUID generated locally
  profile_id          TEXT NOT NULL,           -- Links to active profile
  name                TEXT NOT NULL,           -- e.g., "Amoxicillin"
  dosage_amount       REAL NOT NULL,           -- e.g., 500
  dosage_unit         TEXT NOT NULL,           -- e.g., "mg"
  form                TEXT NOT NULL,           -- e.g., "Capsule", "Tablet", "Softgel"
  quantity_per_dose   INTEGER NOT NULL DEFAULT 1,  -- e.g., 1 capsule
  meal_instruction    TEXT,                    -- "before_meal", "after_meal", NULL
  notes               TEXT,                    -- Free-text notes
  is_active           INTEGER NOT NULL DEFAULT 1,  -- Soft toggle (0 = paused)
  frequency_type      TEXT NOT NULL,           -- "once_daily", "twice_daily", "as_needed", "custom"
  times               TEXT NOT NULL,           -- JSON array: ["08:00", "20:00"]
  created_at          INTEGER NOT NULL,        -- Epoch ms
  updated_at          INTEGER NOT NULL,        -- Epoch ms
  sync_status         TEXT NOT NULL DEFAULT 'pending_create',  -- pending_create, pending_update, pending_delete, synced
  server_id           TEXT,                    -- Populated after first sync
  last_synced_at      INTEGER                  -- Epoch ms, NULL if never synced
);

CREATE TABLE dose_logs (
  id                  TEXT PRIMARY KEY,       -- UUID
  medicine_id         TEXT NOT NULL,           -- FK → medicines.id
  scheduled_time      INTEGER NOT NULL,        -- Epoch ms of the scheduled dose
  taken_at            INTEGER,                 -- Epoch ms when actually taken, NULL if skipped/missed
  status              TEXT NOT NULL DEFAULT 'pending',  -- pending, taken, skipped, missed
  sync_status         TEXT NOT NULL DEFAULT 'pending_create',
  server_id           TEXT,
  created_at          INTEGER NOT NULL,
  updated_at          INTEGER NOT NULL
);

CREATE TABLE alarm_queue (
  id                  TEXT PRIMARY KEY,       -- UUID
  medicine_id         TEXT NOT NULL,           -- FK → medicines.id
  alarm_time          INTEGER NOT NULL,        -- Epoch ms for next alarm fire
  is_recurring        INTEGER NOT NULL DEFAULT 1,
  recurring_rule      TEXT,                    -- JSON: {"frequency": "daily", "interval": 1}
  scheduled_alarm_id  INTEGER,                 -- Platform alarm manager ID for cancellation
  created_at          INTEGER NOT NULL
);

CREATE INDEX idx_medicines_profile ON medicines(profile_id);
CREATE INDEX idx_medicines_sync ON medicines(sync_status);
CREATE INDEX idx_dose_logs_medicine ON dose_logs(medicine_id);
CREATE INDEX idx_dose_logs_status ON dose_logs(status);
CREATE INDEX idx_alarm_queue_time ON alarm_queue(alarm_time);
```

### 2.2 API Integration Mapping

**Base:** `https://cureta.onrender.com/api/`

#### Medicine CRUD

| Operation | Endpoint | Method | Request Body | Response |
|-----------|----------|--------|-------------|----------|
| Create | `medicines` | POST | `{ profile_id, name, dosage: { amount, unit, form, quantity_per_dose }, schedule: { frequency_type, times: ["08:00","20:00"], meal_instruction }, notes }` | `{ id, ...medicine, created_at, updated_at }` |
| List | `medicines/profile/{profile_id}` | GET | — | `[{ id, name, dosage, schedule, notes, is_active, ... }]` |
| Update | `medicines/{id}` | PUT | Same as create (partial) | `{ id, ...medicine, updated_at }` |
| Delete | `medicines/{id}` | DELETE | — | `{ success: true }` |

#### Dose Tracking

| Operation | Endpoint | Method | Request Body | Response |
|-----------|----------|--------|-------------|----------|
| Log Dose | `medicines/{id}/doses` | POST | `{ scheduled_time, taken_at, status }` | `{ id, ...dose }` |
| Get Doses | `medicines/{id}/doses?date=YYYY-MM-DD` | GET | — | `[{ id, scheduled_time, taken_at, status }]` |
| Update Dose | `doses/{id}` | PATCH | `{ taken_at, status }` | `{ id, ...dose }` |

#### Sync Endpoint (Batch)

| Operation | Endpoint | Method | Request Body | Response |
|-----------|----------|--------|-------------|----------|
| Batch Sync | `medicines/sync` | POST | `{ medicines: [{ local_id, action: "create"|"update"|"delete", data: {...}, updated_at }], doses: [...] }` | `{ medicines: [{ local_id, server_id, updated_at }], conflicts: [...] }` |

### 2.3 Local ↔ Remote Field Mapping

| Local (sqflite) | Remote (API) | Transform |
|-----------------|-------------|-----------|
| `id` (UUID) | `id` (server UUID) | `server_id` stores remote ID; local `id` used until first sync |
| `dosage_amount` + `dosage_unit` + `form` + `quantity_per_dose` | `dosage: { amount, unit, form, quantity_per_dose }` | Compose/decompose nested object |
| `frequency_type` + `times` (JSON) | `schedule: { frequency_type, times, meal_instruction }` | `times` is JSON string locally → List<String> on API |
| `meal_instruction` | `schedule.meal_instruction` | Moved into `schedule` nesting |
| `sync_status` | N/A | Local-only field; drives sync queue |
| `server_id` | `id` | After sync, `server_id` populated; `id` remains local PK |
| `is_active` | `is_active` | Direct 1:1 |
| `alarm_time` | N/A | Local-only; computed from `times` + current date |

---

## 3. State Management Strategy

### 3.1 Cubit Inventory

| Cubit | File | Responsibility |
|-------|------|---------------|
| `MedicinesListCubit` | `veiw_model/medicines_list_cubit.dart` | Fetch, filter, toggle active status of user's medicines |
| `AddMedicineCubit` | `veiw_model/add_medicine_cubit.dart` | Manage 5-step wizard form state; validate each step; create medicine |
| `MedicineDetailCubit` | `veiw_model/medicine_detail_cubit.dart` | Load single medicine; handle edit/delete |
| `DoseLogCubit` | `veiw_model/dose_log_cubit.dart` | Log taken/skipped/missed doses; fetch today's dose history |
| `MedicineSyncCubit` | `veiw_model/medicine_sync_cubit.dart` | Orchestrate sync queue; handle conflicts; retry failed syncs |

### 3.2 State Definitions

#### MedicinesListCubit
```dart
// States: MedicinesListInitial, MedicinesListLoading, MedicinesListLoaded, MedicinesListError
abstract class MedicinesListState extends Equatable {}

class MedicinesListInitial extends MedicinesListState {}
class MedicinesListLoading extends MedicinesListState {}
class MedicinesListLoaded extends MedicinesListState {
  final List<Medicine> medicines;      // sorted by next alarm
  final bool hasPendingSync;            // show sync indicator
}
class MedicinesListError extends MedicinesListState {
  final String message;
  final bool isOfflineError;            // differentiate offline vs server errors
}
```

#### AddMedicineCubit
```dart
// States: AddMedicineInitial, AddMedicineStepValidating, AddMedicineStepValid,
//         AddMedicineCreating, AddMedicineCreated, AddMedicineError
abstract class AddMedicineState extends Equatable {
  final String name;
  final double dosageAmount;
  final String dosageUnit;
  final String form;
  final int quantityPerDose;
  final String frequencyType;
  final List<String> times;
  final String? mealInstruction;
  final String? notes;
  final int currentStep;   // 1-5
}

class AddMedicineInitial extends AddMedicineState { currentStep = 1 }
class AddMedicineCreating extends AddMedicineState { currentStep = 5 }
class AddMedicineCreated extends AddMedicineState { /* includes created medicine */ }
class AddMedicineError extends AddMedicineState { final String message; }
```

#### MedicineSyncCubit
```dart
// States: SyncIdle, SyncInProgress, SyncCompleted, SyncFailed, SyncConflictDetected
abstract class MedicineSyncState extends Equatable {}

class SyncIdle extends MedicineSyncState {
  final int pendingCount;   // items in sync queue
}
class SyncInProgress extends MedicineSyncState {
  final int totalItems;
  final int syncedItems;
}
class SyncCompleted extends MedicineSyncState {}
class SyncFailed extends MedicineSyncState {
  final String message;
  final bool retryable;
}
class SyncConflictDetected extends MedicineSyncState {
  final List<SyncConflict> conflicts;
}
```

### 3.3 Cubit → View Communication

| Cubit | View(s) | Provider Type |
|-------|---------|--------------|
| `MedicinesListCubit` | `UsersMedicinesView` | `BlocProvider` at screen level |
| `AddMedicineCubit` | All 5 step views | `BlocProvider` wrapping the step flow (shared across steps via `router` shell route) |
| `MedicineDetailCubit` | `MedicineDetailView` | `BlocProvider` at screen level |
| `DoseLogCubit` | `UsersMedicinesView`, notification actions | `BlocProvider` at screen level, also accessed globally for notification callbacks |
| `MedicineSyncCubit` | `UsersMedicinesView` (sync indicator) | `BlocProvider` at app-level or feature-level |

---

## 4. Shared Widget Audit

Widgets from `lib/shared/widgets/` that **must be reused** in the Medicine & Alerts feature:

| Shared Widget | Reuse Location | Replacement For |
|--------------|----------------|-----------------|
| `ProgressStepLayout` | All 5 step views | Replaces the entire custom scaffold+header+progress+CTA layout in each step |
| `AddRecordStepProgress` / `StepProgressIndicator` | All step views (Step X of 5 + progress bar) | Replaces hardcoded step labels and progress bars |
| `AddRecordNextButton` | All step views (Next/Save button) | Replaces hardcoded "Next" / "Save reminder" `Container` buttons |
| `CustomScreenHeader` | `UsersMedicinesView` (menu + "My Medicines" + search) | Replaces hardcoded header row |
| `CustomTopBar` | Step views with back button + skip | Replaces hardcoded back/skip header rows |
| `CustomTextField` | Step 1 (medicine name input), Step 3 (notes) | Replaces hardcoded input containers |
| `CustomButton` | Step 4 ("Save reminder"), delete confirmation | Alternative to `AddRecordNextButton` for non-step actions |
| `LoadingOverlay` | All views during async operations | Shows during create/sync/delete |
| `SuccessOverlay` | Step 5 (confirmation after save) | Shows after successful medicine creation |
| `DateSelectionCard` | Potential reuse for schedule date selection | If schedule includes specific start/end dates |

### New Feature-Specific Widgets (to create in `lib/features/medicins_alert/widgets/`)

| Widget | Purpose |
|--------|---------|
| `MedicineCard` | Single medicine row in list (icon, name, dosage, next dose, active toggle) |
| `TimePickerWheel` | Hour/minute/AM-PM scroll picker for Step 2 |
| `FrequencySelector` | Frequency option cards (Once a day, Twice a day, As needed) |
| `MealTimingCard` | Before/After meal selection card |
| `MedicineReviewCard` | Summary card for Step 4 review |
| `MedicineIconBadge` | Colored circular icon container (matches `accentCyan`, `accentOrange`, `accentBlue` patterns) |
| `SyncStatusIndicator` | Small badge showing pending sync count |

---

## 5. Sync Logic Workflow

### 5.1 Write Path (Local → Remote)

```
User Action (create/update/delete)
       │
       ▼
┌─────────────────────────────┐
│  Cubit emits optimistic     │
│  state (UI updates instantly)│
└─────────────┬───────────────┘
              │
              ▼
┌─────────────────────────────┐
│  Write to SQLite with       │
│  sync_status =              │
│  'pending_create' /         │
│  'pending_update' /         │
│  'pending_delete'           │
└─────────────┬───────────────┘
              │
              ▼
┌─────────────────────────────┐
│  Schedule/cancel local      │
│  alarms via OS alarm        │
│  manager (android_alarm_    │
│  manager / flutter_local_   │
│  notifications)             │
└─────────────┬───────────────┘
              │
              ▼
┌─────────────────────────────┐
│  Check connectivity:        │
│  ┌─ Online → enqueue to     │
│  │  sync queue, fire        │
│  │  MedicineSyncCubit.sync()│
│  └─ Offline → queue waits   │
│     for connectivity change │
└─────────────────────────────┘
              │ (when online)
              ▼
┌─────────────────────────────┐
│  MedicineSyncCubit.sync():  │
│  1. Query SQLite WHERE      │
│     sync_status != 'synced' │
│  2. POST /medicines/sync    │
│     with batch payload      │
│  3. Process response:       │
│     - Map server_id to      │
│       local records         │
│     - Detect conflicts      │
│     - Update sync_status    │
│       to 'synced'           │
│     - Update last_synced_at │
│  4. Emit SyncCompleted or   │
│     SyncConflictDetected    │
└─────────────────────────────┘
```

### 5.2 Read Path (Remote → Local)

```
App Launch / Pull-to-Refresh
       │
       ▼
┌─────────────────────────────┐
│  GET /medicines/profile/    │
│  {profile_id}               │
└─────────────┬───────────────┘
              │
              ▼
┌─────────────────────────────┐
│  Merge Strategy:            │
│  For each remote medicine:  │
│  ┌─ No local match → INSERT │
│  │  with sync_status=       │
│  │  'synced'                │
│  ├─ Local match, local is   │
│  │  'synced' → UPDATE local │
│  │  with remote data        │
│  ├─ Local match, local has  │
│  │  pending* → CONFLICT:    │
│  │  compare updated_at,     │
│  │  last-write-wins;        │
│  │  notify user if remote   │
│  │  is newer                │
│  └─ Local match, local is   │
│     'pending_delete' →      │
│     push deletion to server │
└─────────────┬───────────────┘
              │
              ▼
┌─────────────────────────────┐
│  Rebuild alarm schedule     │
│  from merged data           │
└─────────────┬───────────────┘
              │
              ▼
┌─────────────────────────────┐
│  MedicinesListCubit emits   │
│  MedicinesListLoaded with   │
│  updated data               │
└─────────────────────────────┘
```

### 5.3 Connectivity Monitoring

- Use `connectivity_plus` package (to be added to `pubspec.yaml`)
- `MedicineSyncCubit` listens to `Connectivity().onConnectivityChanged`
- On transition offline→online: auto-trigger sync for all `pending_*` records
- On transition online→offline: emit `SyncIdle` with `pendingCount > 0`

### 5.4 Sync Status Lifecycle

```
[pending_create] ──sync success──▶ [synced]
[pending_update] ──sync success──▶ [synced]
[pending_delete] ──sync success──▶ [record removed from DB]
[pending_*] ──sync failure──▶ [pending_*] (retry on next connectivity change)
[pending_*] ──conflict──▶ [pending_*] + SyncConflictDetected state
```

---

## 6. Dependency Additions (pubspec.yaml)

```yaml
dependencies:
  sqflite: ^2.3.0              # Local SQLite database
  path: ^1.9.0                 # Path utilities for sqflite
  connectivity_plus: ^6.0.3    # Network connectivity monitoring
  flutter_local_notifications: ^17.2.0  # Local alarm/notification scheduling
  android_alarm_manager_plus: ^4.0.0    # Exact alarm scheduling (Android)
  timezone: ^0.9.4             # Timezone-aware alarm scheduling
```

---

## 7. Directory Structure (Target)

```
lib/features/medicins_alert/
├── data/
│   ├── models/
│   │   ├── medicine_model.dart          # Local domain model
│   │   ├── medicine_dto.dart            # API request/response mapping
│   │   ├── dose_log_model.dart          # Dose tracking model
│   │   ├── dose_log_dto.dart            # API mapping
│   │   └── sync_conflict_model.dart     # Conflict representation
│   ├── services/
│   │   ├── medicine_service.dart        # DioHelper calls to API
│   │   └── medicine_local_service.dart  # sqflite CRUD operations
│   └── repo/
│       └── medicine_repository.dart     # Hybrid: local-first + sync orchestration
├── veiw_model/
│   ├── medicines_list_cubit.dart
│   ├── medicines_list_state.dart
│   ├── add_medicine_cubit.dart
│   ├── add_medicine_state.dart
│   ├── medicine_detail_cubit.dart
│   ├── medicine_detail_state.dart
│   ├── dose_log_cubit.dart
│   ├── dose_log_state.dart
│   ├── medicine_sync_cubit.dart
│   └── medicine_sync_state.dart
├── veiw/
│   ├── users_medicines_view.dart        # Main medicine list
│   ├── add_medicine_first_step.dart     # Medicine name + scan
│   ├── add_medicine_second_step.dart    # Time + frequency
│   ├── add_medicine_third_step.dart     # Meal timing + notes
│   ├── add_medicine_forth_step.dart     # Review
│   ├── add_medicine_fifth_step.dart     # Success confirmation
│   └── medicine_detail_view.dart        # View/edit existing medicine
└── widgets/
    ├── medicine_card.dart
    ├── time_picker_wheel.dart
    ├── frequency_selector.dart
    ├── meal_timing_card.dart
    ├── medicine_review_card.dart
    ├── medicine_icon_badge.dart
    └── sync_status_indicator.dart
```
```