# ✅ Medicine & Alerts Feature — Implementation Task Breakdown

> **Phase:** 3 — Implementation
> **Depends On:** `plan.md` (approved), `medicine_spec.md`, `STYLING_GUIDELINES.md`
> **Architecture:** Clean Architecture + MVVM (Cubit) — Bottom-Up execution order
> **Rule:** Complete each task group fully before moving to the next. No skipping layers.

---

## 🔖 Legend

| Symbol | Meaning |
|--------|---------|
| `- [ ]` | Task not started |
| `- [x]` | Task complete |
| 🎨 | Requires `STYLING_GUIDELINES.md` token check before writing UI code |
| 🔒 | Blocked until the previous task group is fully checked off |
| ⚠️ | Requires design team confirmation (see `plan.md` Section 7) |

---

## Task 1 — Data Layer

> **Goal:** Build the foundation. No UI, no Cubit. Pure data plumbing.
> All files live under `lib/features/medicine/data/`.

### 1.1 — Domain Model & DTOs

- [ ] Create `lib/features/medicine/data/models/medicine_model.dart`
  - [ ] Define `MedicineModel` as an immutable plain Dart class (no JSON logic here)
  - [ ] Fields: `id`, `name`, `doseForm` (`DoseForm` enum), `doseAmount`, `doseUnit`, `frequency` (`Frequency` enum), `alarmTimes` (`List<String>`), `startDate`, `notes`, `isActive`, `syncStatus` (`SyncStatus` enum), `remoteId`, `createdAt`, `updatedAt`
  - [ ] Extend `Equatable` — add all fields to `props`
  - [ ] Add a `copyWith` method for all fields

- [ ] Create `lib/features/medicine/data/models/medicine_enums.dart`
  - [ ] Define `DoseForm` enum: `pill`, `liquid`, `injection`, `drops`, `inhaler`, `patch`
  - [ ] Define `Frequency` enum: `daily`, `weekly`, `asNeeded`
  - [ ] Define `SyncStatus` enum: `pending`, `synced`, `failed`
  - [ ] Add a `toJson()` extension / helper on each enum for sqflite & API serialization

- [ ] Create `lib/features/medicine/data/models/medicine_dto.dart`
  - [ ] Define `MedicineDto` with all JSON-serializable fields (snake_case keys matching API contract)
  - [ ] Implement `fromJson(Map<String, dynamic> json)` factory
  - [ ] Implement `toJson()` method
  - [ ] Implement `toDomain()` → converts `MedicineDto` to `MedicineModel`
  - [ ] Implement `MedicineModel.toDto()` extension or static helper (domain → DTO for API writes)

- [ ] Create `lib/features/medicine/data/models/medicine_payload.dart`
  - [ ] Define `MedicinePayload` — the outbound write object constructed by `AddMedicineCubit`
  - [ ] Fields must exactly match the API's POST body contract from `medicine_spec.md`
  - [ ] Implement `toJson()` method
  - [ ] Extend `Equatable`

---

### 1.2 — Local Service (sqflite)

- [ ] Create `lib/features/medicine/data/services/medicine_local_service.dart`
  - [ ] Define the `medicines` table name constant and column name constants
  - [ ] Implement `_createTable(Database db)` — creates the table with the schema from `plan.md` Section 5.2
    - [ ] Columns: `id`, `name`, `dose_form`, `dose_amount`, `dose_unit`, `frequency`, `alarm_times` (JSON text), `start_date`, `notes`, `is_active`, `sync_status`, `remote_id`, `created_at`, `updated_at`
  - [ ] Implement `init()` — opens the database, calls `_createTable` if not exists
  - [ ] Implement `insert(MedicineModel medicine)` → `Future<void>`
    - [ ] Serialize `alarmTimes` list to JSON string before insert
    - [ ] Use `ConflictAlgorithm.replace`
  - [ ] Implement `getAll()` → `Future<List<MedicineModel>>`
    - [ ] Deserialize `alarm_times` JSON string back to `List<String>`
    - [ ] Map each row map to `MedicineModel`
  - [ ] Implement `getById(String id)` → `Future<MedicineModel?>`
  - [ ] Implement `getPending()` → `Future<List<MedicineModel>>` (where `sync_status = 'pending'`)
  - [ ] Implement `updateSyncStatus(String id, SyncStatus status, {String? remoteId})` → `Future<void>`
  - [ ] Implement `update(MedicineModel medicine)` → `Future<void>` (full record update)
  - [ ] Implement `delete(String id)` → `Future<void>`
  - [ ] Implement `close()` — closes the database connection

---

### 1.3 — Remote Service (API via DioHelper)

- [ ] Create `lib/features/medicine/data/services/medicine_service.dart`
  - [ ] Inject `DioHelper` via constructor
  - [ ] Define all API endpoint path constants using `ApiEndpoints.*` (register new endpoints in `lib/core/constants/` if not present)
  - [ ] Implement `createMedicine(MedicinePayload payload)` → `Future<MedicineDto>`
    - [ ] POST to `/api/medicines`
    - [ ] Parse response body into `MedicineDto` using `fromJson`
    - [ ] Let `DioException` propagate — do NOT catch here (repository owns error handling)
  - [ ] Implement `getMedicines()` → `Future<List<MedicineDto>>`
    - [ ] GET `/api/medicines`
    - [ ] Parse response list
  - [ ] Implement `getMedicineById(String remoteId)` → `Future<MedicineDto>`
  - [ ] Implement `updateMedicine(String remoteId, MedicinePayload payload)` → `Future<MedicineDto>`
    - [ ] PUT `/api/medicines/:id`
  - [ ] Implement `deleteMedicine(String remoteId)` → `Future<void>`
    - [ ] DELETE `/api/medicines/:id`

---

### 1.4 — Repository (Orchestration Layer)

- [ ] Create `lib/features/medicine/data/repo/medicine_repository.dart`
  - [ ] Inject `MedicineLocalService localService` and `MedicineService remoteService` via constructor
  - [ ] Implement `addMedicine(MedicinePayload payload)` — **Double-Write flow** (see `plan.md` Section 5.3)
    - [ ] Step A: Generate a client-side UUID for `id`
    - [ ] Step B: Write to local sqflite first with `sync_status = 'pending'` — `await localService.insert(...)`
    - [ ] Step C: Attempt remote write in a `try/catch`
      - [ ] On success: call `localService.updateSyncStatus(id, SyncStatus.synced, remoteId: dto.id)`; return merged `MedicineModel`
      - [ ] On `DioException` / any exception: log error; return local `MedicineModel` with `syncStatus = pending` (no rethrow — offline is valid)
  - [ ] Implement `getUserMedicines()` — **Local-first read** (see `plan.md` Section 5.4)
    - [ ] Step A: `final local = await localService.getAll()` — return this immediately
    - [ ] Step B: Trigger async remote refresh — `unawaited(_refreshFromRemote())`
    - [ ] Implement private `_refreshFromRemote()`: fetch remote list, upsert into local, update sync statuses
  - [ ] Implement `syncPendingMedicines()` — **Background sync** (see `plan.md` Section 5.5)
    - [ ] Fetch all pending records via `localService.getPending()`
    - [ ] For each: attempt `remoteService.createMedicine(...)` in a loop with individual try/catch
    - [ ] On success: `updateSyncStatus(synced)` + store `remoteId`
    - [ ] On failure: increment a `retry_count` field (add to schema if not present); mark `failed` after 3 retries
  - [ ] Implement `deleteMedicine(String localId)` — **Delete strategy** (see `plan.md` Section 5.6)
    - [ ] Fetch record to get `remoteId`
    - [ ] Delete locally first
    - [ ] If `remoteId` is not null: attempt remote delete in a fire-and-forget `try/catch`
  - [ ] Implement `updateMedicine(MedicineModel medicine)` — for edits from the medicines list
  - [ ] Implement `toggleMedicineActive(String localId)` — flips `isActive`, syncs remotely

---

## Task 2 — State Management (Cubits)

> **Goal:** Define all states and cubit logic. No widgets, no UI.
> 🔒 Blocked until all Task 1 files are complete and compile cleanly.
> All files live under `lib/features/medicine/veiw_model/`.

### 2.1 — `AddMedicineCubit` States

- [ ] Create `lib/features/medicine/veiw_model/add_medicine_state.dart`
  - [ ] Use `sealed class AddMedicineState extends Equatable`
  - [ ] Define `AddMedicineInitial` — clean form, no data
  - [ ] Define `AddMedicineStepUpdated` — holds all current form field values (the "live" state)
    - [ ] Fields mirror `MedicinePayload`: `medicineName`, `doseForm`, `doseAmount`, `doseUnit`, `frequency`, `alarmTimes`, `startDate`, `notes`
    - [ ] Add `validationErrors: Map<String, String>` — keyed by field name, value is localization error key
  - [ ] Define `AddMedicineValidated` — step passed validation; view uses this to trigger navigation
    - [ ] Carries `int stepNumber` so the view knows which step was validated
  - [ ] Define `AddMedicineScanRequested` — cubit signals view to open camera
  - [ ] Define `AddMedicineLoading` — final submission in progress
  - [ ] Define `AddMedicineSuccess` — carries the created `MedicineModel`
  - [ ] Define `AddMedicineFailure` — carries `String errorMessage` (localization key)

---

### 2.2 — `AddMedicineCubit` Logic

- [ ] Create `lib/features/medicine/veiw_model/add_medicine_cubit.dart`
  - [ ] Inject `MedicineRepository` via constructor
  - [ ] Initialize state as `AddMedicineInitial()`
  - [ ] Implement private `_currentData()` helper — returns the current `AddMedicineStepUpdated` fields (or defaults if state is `Initial`)
  - [ ] **Field update methods** (each emits `AddMedicineStepUpdated` with updated field):
    - [ ] `updateMedicineName(String value)`
    - [ ] `updateDoseForm(DoseForm form)`
    - [ ] `updateDoseAmount(double amount)`
    - [ ] `updateDoseUnit(String unit)`
    - [ ] `updateFrequency(Frequency frequency)`
    - [ ] `addAlarmTime(TimeOfDay time)` — appends to `alarmTimes` list
    - [ ] `removeAlarmTime(int index)` — removes by index from `alarmTimes` list
    - [ ] `updateStartDate(DateTime date)`
    - [ ] `updateNotes(String notes)`
  - [ ] **Validation methods:**
    - [ ] `validateStep1()` — checks `medicineName` is not empty/whitespace; emits `AddMedicineValidated(stepNumber: 1)` on pass, `AddMedicineStepUpdated(validationErrors: {'medicineName': 'error_medicine_name_required'})` on fail
    - [ ] `validateStep2()` — checks `doseForm` is selected and `frequency` is selected
    - [ ] `validateStep3()` — always passes (notes + times are optional); emits `AddMedicineValidated(stepNumber: 3)`
  - [ ] **Skip methods:**
    - [ ] `skipStep2()` — clears optional dose/frequency fields, emits `AddMedicineValidated(stepNumber: 2)`
    - [ ] `skipStep3()` — clears `notes` and `alarmTimes`, emits `AddMedicineValidated(stepNumber: 3)`
  - [ ] **Camera trigger:**
    - [ ] `requestScan()` — emits `AddMedicineScanRequested`
    - [ ] After scan, view calls `updateMedicineName(result)` — no special cubit method needed
  - [ ] **Submission:**
    - [ ] `submitMedicine()` — emits `AddMedicineLoading`, calls `_buildPayload()`, calls `repository.addMedicine(payload)`, emits `AddMedicineSuccess(medicine)` or `AddMedicineFailure(message)`
    - [ ] Private `_buildPayload()` — assembles `MedicinePayload` from current state fields
  - [ ] **Reset:**
    - [ ] `resetForm()` — emits `AddMedicineInitial()`

---

### 2.3 — `UserMedicinesCubit` States

- [ ] Create `lib/features/medicine/veiw_model/user_medicines_state.dart`
  - [ ] Use `sealed class UserMedicinesState extends Equatable`
  - [ ] Define `UserMedicinesInitial`
  - [ ] Define `UserMedicinesLoading`
  - [ ] Define `UserMedicinesLoaded`
    - [ ] Fields: `allMedicines: List<MedicineModel>`, `filteredMedicines: List<MedicineModel>`, `hasPendingSync: bool`
  - [ ] Define `UserMedicinesError` — carries `String messageKey`
  - [ ] Define `UserMedicinesSyncBanner` — carries `int failedCount` (for the non-blocking sync failure banner)

---

### 2.4 — `UserMedicinesCubit` Logic

- [ ] Create `lib/features/medicine/veiw_model/user_medicines_cubit.dart`
  - [ ] Inject `MedicineRepository` via constructor
  - [ ] Implement `init()` — calls `loadMedicines()` then `syncPendingMedicines()` in sequence
  - [ ] Implement `loadMedicines()`
    - [ ] Emit `UserMedicinesLoading`
    - [ ] Await `repository.getUserMedicines()`
    - [ ] Emit `UserMedicinesLoaded(allMedicines: list, filteredMedicines: list, hasPendingSync: list.any((m) => m.syncStatus == SyncStatus.pending))`
    - [ ] On error: emit `UserMedicinesError`
  - [ ] Implement `syncPendingMedicines()`
    - [ ] Call `repository.syncPendingMedicines()`
    - [ ] If any records remain with `SyncStatus.failed` after sync: emit `UserMedicinesSyncBanner(failedCount: N)`
  - [ ] Implement `deleteMedicine(String localId)`
    - [ ] Optimistically remove from current loaded state
    - [ ] Call `repository.deleteMedicine(localId)` in background
    - [ ] On error: reload list and emit an error snackbar state
  - [ ] Implement `toggleMedicine(String localId)`
    - [ ] Optimistically flip `isActive` in current state
    - [ ] Call `repository.toggleMedicineActive(localId)` in background
  - [ ] Implement `filterByStatus(bool? isActive)` — null means show all; filters `filteredMedicines` in-memory without new DB call; emits updated `UserMedicinesLoaded`
  - [ ] Implement `searchByName(String query)` — filters `filteredMedicines` by name (case-insensitive `contains`); emits updated `UserMedicinesLoaded`

---

## Task 3 — Feature Widgets

> **Goal:** Build all stateless sub-widgets. Each widget is pure UI — receives data via constructor, emits events via callbacks.
> 🔒 Blocked until Task 2 states are defined (widgets need to know the model shape).
> 🎨 Before writing any widget: open `STYLING_GUIDELINES.md` and verify every token used (colors, spacing, radius, typography). Run the compliance checklist in Section 15 before marking any widget task complete.
> All files live under `lib/features/medicine/widgets/`.

---

### 3.1 — `StepProgressBarWidget`

- [ ] Create `lib/features/medicine/widgets/step_progress_bar_widget.dart`
  - [ ] Constructor params: `required int currentStep`, `required int totalSteps`
  - [ ] Render `totalSteps` equally-spaced segments in a `Row` using `Expanded` children
  - [ ] Segment color logic:
    - [ ] Completed (`index < currentStep - 1`): ⚠️ pending design token (see `plan.md` Section 7 — `progressCompleted`)
    - [ ] Active (`index == currentStep - 1`): `context.colors.primary`
    - [ ] Future (`index > currentStep - 1`): ⚠️ pending design token (`progressInactive`)
  - [ ] Segment height: `context.spacing.xs / 1` (8px → 6-8px; confirm with design)
  - [ ] Segment border radius: `context.radius.full`
  - [ ] Gap between segments: `context.spacing.xs`
  - [ ] Animate segment color changes using `AnimatedContainer` with `context.durations.normal`
  - [ ] ⚠️ **Block:** Do not hard-code the unresolved cyan colors. Use `context.colors.primary` as a placeholder until design tokens are confirmed.

---

### 3.2 — `DoseFormSelectorWidget`

- [ ] Create `lib/features/medicine/widgets/dose_form_selector_widget.dart`
  - [ ] Constructor params: `required DoseForm? selectedForm`, `required ValueChanged<DoseForm> onSelected`
  - [ ] Render a `Wrap` of selectable chips, one per `DoseForm` enum value
  - [ ] Each chip: icon + localized label (e.g., `'dose_form_pill'.tr()`)
  - [ ] Selected chip: background `context.colors.primary`, label/icon color `context.colors.background`
  - [ ] Unselected chip: background `context.colors.surface`, border `context.colors.divider`, label/icon `context.colors.textSecondary`
  - [ ] Chip border radius: `context.radius.lg`
  - [ ] Chip padding: `EdgeInsetsDirectional.symmetric(horizontal: context.spacing.lg, vertical: context.spacing.sm)`
  - [ ] Label style: `context.typography.medicalRecordChoice`
  - [ ] All icon references use `Icon(Icons.*)` — no Material Icons font text
  - [ ] 🎨 Verify all tokens against `STYLING_GUIDELINES.md` Section 3 & 5

---

### 3.3 — `FrequencySelectorWidget`

- [ ] Create `lib/features/medicine/widgets/frequency_selector_widget.dart`
  - [ ] Constructor params: `required Frequency? selectedFrequency`, `required ValueChanged<Frequency> onSelected`
  - [ ] Render three tappable option cards (Daily / Weekly / As Needed) in a `Column`
  - [ ] Each card: leading icon, localized title, optional subtitle description
  - [ ] Selected card: left border accent `context.colors.primary`, background `context.colors.secondary`
  - [ ] Unselected card: background `context.colors.surface`, border `context.colors.divider`
  - [ ] Card border radius: `context.radius.lg`
  - [ ] Card padding: `EdgeInsets.all(context.spacing.lg)`
  - [ ] Title style: `context.typography.medicalRecordChoice`
  - [ ] Gap between cards: `context.spacing.md`
  - [ ] 🎨 Verify all tokens against `STYLING_GUIDELINES.md` Section 3 & 5

---

### 3.4 — `TimePickerRowWidget`

- [ ] Create `lib/features/medicine/widgets/time_picker_row_widget.dart`
  - [ ] Constructor params: `required String time` (display string e.g., "08:00 AM"), `required VoidCallback onTap`, `required VoidCallback onRemove`, `required bool canRemove`
  - [ ] Render a `Row`: clock icon + time label + (if `canRemove`) remove icon button
  - [ ] Container background: `context.colors.surface`
  - [ ] Container border: `context.colors.divider`
  - [ ] Container border radius: `context.radius.lg`
  - [ ] Container padding: `EdgeInsetsDirectional.symmetric(horizontal: context.spacing.lg, vertical: context.spacing.md)`
  - [ ] Time label style: `context.typography.medicalRecordPickerLabel`
  - [ ] Clock icon color: `context.colors.primary`
  - [ ] Remove icon color: `context.colors.error`
  - [ ] Entire row is `GestureDetector(onTap: onTap)` — tapping opens the system `showTimePicker`
  - [ ] 🎨 Verify all tokens against `STYLING_GUIDELINES.md` Section 3 & 5

---

### 3.5 — `MedicineSummaryCardWidget`

- [ ] Create `lib/features/medicine/widgets/medicine_summary_card_widget.dart`
  - [ ] Constructor params: `required MedicineModel medicine`, `required VoidCallback onEditTap`
  - [ ] Card background: `context.colors.surface`
  - [ ] Card border radius: `context.radius.xl`
  - [ ] Card border: `context.colors.chatQuickActionBorder` (matching Step 4 "Edit Details" border)
  - [ ] Display rows: Name, Dose Form, Dose Amount + Unit, Frequency, Alarm Times, Notes
  - [ ] Label style: `context.typography.medicalRecordDetailLabel`
  - [ ] Value style: `context.typography.medicalRecordDetailBody`
  - [ ] "Edit Details" button at bottom: outlined style using `context.colors.chatQuickActionBorder` as border, `context.colors.primary` as label color, `context.typography.medicalRecordDetailLabel`
  - [ ] `onEditTap` callback navigates back to the relevant step (handled by the view)
  - [ ] 🎨 Verify all tokens against `STYLING_GUIDELINES.md` Section 3 & 5

---

### 3.6 — `MedicineCardWidget`

- [ ] Create `lib/features/medicine/widgets/medicine_card_widget.dart`
  - [ ] Constructor params: `required MedicineModel medicine`, `required VoidCallback onTap`, `required ValueChanged<bool> onToggle`, `required VoidCallback onDelete`
  - [ ] Card background: `context.colors.surface`
  - [ ] Card border radius: `context.radius.lg`
  - [ ] Card padding: `EdgeInsets.all(context.spacing.lg)`
  - [ ] Medicine name style: `context.typography.medicalRecordChoice`
  - [ ] Dose + frequency info row: `context.typography.medicalRecordDetailLabel` with `context.colors.textSecondary`
  - [ ] Alarm time chip(s): pill-shaped, background `context.colors.secondary`, text `context.colors.primary`, style `context.typography.medicalRecordProgress`
  - [ ] Active/Paused toggle: `Switch` (Material 3 style); active color `context.colors.primary`
  - [ ] Pending sync indicator: small dot `context.colors.accentOrange` visible when `medicine.syncStatus == SyncStatus.pending`
  - [ ] Swipe-to-delete: wrap in `Dismissible` with background `context.colors.error`
  - [ ] `onTap` navigates to medicine detail (future screen — route placeholder sufficient now)
  - [ ] 🎨 Verify all tokens against `STYLING_GUIDELINES.md` Section 3 & 5

---

### 3.7 — `MedicineEmptyStateWidget`

- [ ] Create `lib/features/medicine/widgets/medicine_empty_state_widget.dart`
  - [ ] Constructor params: `required VoidCallback onAddTap`
  - [ ] Centered column: illustration (use `AppImages.*` constant — register asset first if needed) + title + subtitle + CTA button
  - [ ] Title style: `context.typography.title` with `context.colors.textPrimary`
  - [ ] Subtitle style: `context.typography.label` with `context.colors.textSecondary`
  - [ ] CTA button: full-width, background `context.colors.primary`, label `'add_your_first_medicine'.tr()`, style `context.typography.medicalRecordButton`
  - [ ] CTA border radius: `context.radius.xxl`
  - [ ] All strings use `.tr()` — no hardcoded text
  - [ ] 🎨 Verify all tokens against `STYLING_GUIDELINES.md` Section 3 & 5

---

### 3.8 — `MedicineBottomNavBarWidget`

- [ ] Create `lib/features/medicine/widgets/medicine_bottom_nav_bar_widget.dart`
  - [ ] Extract from `Users_medicines.dart` — the bottom nav bar is currently rendered inline
  - [ ] Constructor params: `required int currentIndex`, `required ValueChanged<int> onTap`
  - [ ] Background: `context.colors.background`
  - [ ] Top border: `context.colors.divider` with `context.spacing.hairline` thickness
  - [ ] Active item icon + label: `context.colors.primary`
  - [ ] Inactive item icon + label: `context.colors.icon`
  - [ ] Label style: `context.typography.medicalRecordProgress`
  - [ ] Home indicator bar: `context.colors.divider`, `context.radius.full`, height `context.spacing.xs / 2`
  - [ ] Replace `Text('icon_name', fontFamily: 'Material Icons')` with proper `Icon(Icons.*)` for: home, medication, qr_code_scanner, description, person
  - [ ] 🎨 Verify all tokens against `STYLING_GUIDELINES.md` Section 3 & 5

---

## Task 4 — View Refactoring

> **Goal:** Wire all layers together into full screen widgets. Replace all hardcoded values with tokens and shared widgets.
> 🔒 Blocked until Tasks 1, 2, and 3 are fully complete.
> 🎨 Before touching any view file: re-read `STYLING_GUIDELINES.md` Section 2 (Responsiveness) and Section 8 (RTL). Run the full compliance checklist (Section 15) on each view before marking complete.
> All files live under `lib/features/medicine/veiw/`.

### Pre-Refactor Checklist (apply to EVERY view file before starting it)

- [ ] Confirm no `width: 375`, `width: 375.20`, or `height: 812` remain
- [ ] Confirm no `BoxConstraints(minHeight: 812)` remain
- [ ] Confirm no `Text('icon_name', fontFamily: 'Material Icons')` remain
- [ ] Confirm all `EdgeInsets.*` are replaced with `EdgeInsetsDirectional.*`
- [ ] Confirm all `Alignment.*` left/right variants are replaced with `AlignmentDirectional`
- [ ] Confirm all `TextStyle(fontSize: ...)` are replaced with `context.typography.*`
- [ ] Confirm all `Color(0xFF...)` and `Colors.*` are replaced with `context.colors.*`
- [ ] Confirm all `BorderRadius.circular(hardcoded)` are replaced with `context.radius.*`
- [ ] Confirm all `EdgeInsets.all(hardcoded)` are replaced with `context.spacing.*`
- [ ] Confirm all `padding: const EdgeInsets.only(...)` use `context.spacing.*` tokens
- [ ] Confirm all user-facing strings use `'key'.tr()`
- [ ] Confirm file is ≤ ~100 lines — extract sub-widgets to `widgets/` folder if exceeded

---

### 4.1 — `UserMedicinesVeiw`

- [ ] Create `lib/features/medicine/veiw/user_medicines_veiw.dart`
  - [ ] Wrap in `BlocProvider<UserMedicinesCubit>(create: (_) => getIt<UserMedicinesCubit>()..init())`
  - [ ] Use `BlocConsumer`:
    - [ ] `listener`: show `SnackBar` on `UserMedicinesSyncBanner` (pending sync failure count)
    - [ ] `builder`: switch on state — `Loading` → `Shimmer` skeleton; `Loaded` → list; `Error` → error widget
  - [ ] Scaffold background: `context.colors.chatBackground`
  - [ ] App bar: replace inline `Container` header with a proper app bar row — menu icon (left), `'my_medicines'.tr()` title (center, `context.typography.medicalRecordScreenTitle`), search icon (right)
    - [ ] All icons use `Icon(Icons.menu)`, `Icon(Icons.search)` — not Material Icons font text
    - [ ] Icon color: `context.colors.textPrimary`
  - [ ] Body: `ListView.separated` of `MedicineCardWidget` items from `state.filteredMedicines`
    - [ ] Separator height: `context.spacing.md`
    - [ ] Horizontal padding: `context.spacing.xl`
    - [ ] Bottom padding: `context.spacing.xxl * 4` (space above bottom nav)
  - [ ] When `state.filteredMedicines.isEmpty`: render `MedicineEmptyStateWidget`
  - [ ] FAB: `FloatingActionButton.extended` — icon `Icons.add`, label `'add_medicine'.tr()`, background `context.colors.primary`, label style `context.typography.medicalRecordButton`
  - [ ] FAB `onPressed`: `context.push('/medicines/add/1')`
  - [ ] Bottom nav: `MedicineBottomNavBarWidget`
  - [ ] Apply pre-refactor checklist above before marking complete

---

### 4.2 — `AddMedicineFirstStepVeiw` (Step 1 — Medicine Name)

- [ ] Create `lib/features/medicine/veiw/add_medicine_first_step_veiw.dart`
  - [ ] Wrap body in `ProgressStepLayout(currentStep: 1, totalSteps: 5, showSkip: false, onClose: () { cubit.resetForm(); context.go('/medicines'); })`
  - [ ] Use `BlocConsumer<AddMedicineCubit, AddMedicineState>`:
    - [ ] `listener`: on `AddMedicineValidated(stepNumber: 1)` → `context.push('/medicines/add/2')`; on `AddMedicineScanRequested` → open camera scanner
    - [ ] `builder`: rebuild field and error text from `AddMedicineStepUpdated` state
  - [ ] Question heading: `Text('step1_question'.tr(), style: context.typography.medicalRecordQuestion)`
  - [ ] Sub-heading: `Text('step1_subtitle'.tr(), style: context.typography.medicalRecordPickerLabel.copyWith(color: context.colors.textSecondary))`
  - [ ] Medicine name field: `CustomTextField(controller: _controller, hint: 'medicine_name_hint'.tr(), suffixIcon: Icons.photo_camera, onSuffixTap: () => cubit.requestScan(), onChanged: cubit.updateMedicineName)`
  - [ ] Validation error: `AnimatedSwitcher` — show `Text(state.validationErrors['medicineName']?.tr() ?? '', style: context.typography.label.copyWith(color: context.colors.error))` when error is present
  - [ ] Info hint row: `Icon(Icons.info_outline, color: context.colors.textHint)` + `Text('step1_info_hint'.tr(), style: context.typography.medicalRecordHelper)`
  - [ ] `TextEditingController` `initState`: pre-fill from cubit state if `AddMedicineStepUpdated` (user navigating back)
  - [ ] Dispose controller and focus node in `dispose()`
  - [ ] Next button: `AddRecordNextButton(label: 'next'.tr(), onPressed: () => cubit.validateStep1())`
  - [ ] Apply pre-refactor checklist before marking complete

---

### 4.3 — `AddMedicineSecondStepVeiw` (Step 2 — Dose Form & Frequency)

- [ ] Create `lib/features/medicine/veiw/add_medicine_second_step_veiw.dart`
  - [ ] Wrap in `ProgressStepLayout(currentStep: 2, totalSteps: 5, showSkip: true, onSkip: () => cubit.skipStep2())`
  - [ ] `BlocConsumer` listener: on `AddMedicineValidated(stepNumber: 2)` → `context.push('/medicines/add/3')`
  - [ ] Question heading: `Text('step2_question'.tr(), style: context.typography.medicalRecordQuestion)`
  - [ ] Dose form section label: `Text('dose_form_label'.tr(), style: context.typography.medicalRecordDetailLabel.copyWith(color: context.colors.textSecondary))`
  - [ ] `DoseFormSelectorWidget(selectedForm: state.doseForm, onSelected: cubit.updateDoseForm)`
  - [ ] `SizedBox(height: context.spacing.xl)`
  - [ ] Frequency section label: `Text('frequency_label'.tr(), ...)`
  - [ ] `FrequencySelectorWidget(selectedFrequency: state.frequency, onSelected: cubit.updateFrequency)`
  - [ ] Validation error rendering for `doseForm` and `frequency` fields
  - [ ] Next button: `AddRecordNextButton(label: 'next'.tr(), onPressed: () => cubit.validateStep2())`
  - [ ] "Skip for now" text button below Next: `TextButton(onPressed: () => cubit.skipStep2(), child: Text('skip_for_now'.tr(), style: context.typography.medicalRecordSkip.copyWith(color: context.colors.textSecondary)))`
  - [ ] Scaffold background: `context.colors.chatBackground`
  - [ ] Apply pre-refactor checklist before marking complete

---

### 4.4 — `AddMedicineThirdStepVeiw` (Step 3 — Schedule & Notes)

- [ ] Create `lib/features/medicine/veiw/add_medicine_third_step_veiw.dart`
  - [ ] Wrap in `ProgressStepLayout(currentStep: 3, totalSteps: 5, showSkip: true, onSkip: () => cubit.skipStep3())`
  - [ ] `BlocConsumer` listener: on `AddMedicineValidated(stepNumber: 3)` → `context.push('/medicines/add/4')`
  - [ ] Question heading: `Text('step3_question'.tr(), style: context.typography.medicalRecordQuestion)`
  - [ ] Alarm times section:
    - [ ] `ListView` (shrinkWrap, non-scrollable) of `TimePickerRowWidget` for each `state.alarmTimes` entry
    - [ ] Each row `onTap`: `showTimePicker(context: context, ...)` → on confirm: `cubit.addAlarmTime(picked)`
    - [ ] Each row `onRemove`: `cubit.removeAlarmTime(index)`
    - [ ] "Add time" row: `TextButton.icon(icon: Icon(Icons.add_alarm), label: Text('add_alarm_time'.tr(), ...))` — visible always; calls `showTimePicker` then `cubit.addAlarmTime`
  - [ ] `SizedBox(height: context.spacing.xl)`
  - [ ] Notes section:
    - [ ] Section label: `Text('notes_label'.tr(), style: context.typography.medicalRecordDetailLabel)`
    - [ ] `CustomTextField(controller: _notesController, hint: 'notes_hint'.tr(), maxLines: 4, suffixIcon: Icons.edit_note, onChanged: cubit.updateNotes)`
  - [ ] Scaffold background: `context.colors.background`
  - [ ] Next button: `AddRecordNextButton(label: 'next_step'.tr(), onPressed: () => cubit.validateStep3())`
  - [ ] Apply pre-refactor checklist before marking complete

---

### 4.5 — `AddMedicineFourthStepVeiw` (Step 4 — Review & Confirm)

- [ ] Create `lib/features/medicine/veiw/add_medicine_fourth_step_veiw.dart`
  - [ ] Wrap in `ProgressStepLayout(currentStep: 4, totalSteps: 5, showSkip: false)`
  - [ ] `BlocConsumer` listener:
    - [ ] On `AddMedicineLoading`: show full-screen loading overlay
    - [ ] On `AddMedicineSuccess`: `context.go('/medicines/add/5')` (pass medicine id if needed)
    - [ ] On `AddMedicineFailure`: `ScaffoldMessenger.of(context).showSnackBar(...)` with `state.errorMessage.tr()`
  - [ ] Question heading: `Text('step4_question'.tr(), style: context.typography.medicalRecordQuestion)` (e.g., "Here's your reminder summary")
  - [ ] `MedicineSummaryCardWidget(medicine: stateAsMedicineModel, onEditTap: () => context.go('/medicines/add/N'))` — build a temporary `MedicineModel` from cubit's `AddMedicineStepUpdated` fields for display
  - [ ] Helper text below card: `Text('step4_helper'.tr(), style: context.typography.medicalRecordSecureNote.copyWith(color: context.colors.textSecondary), textAlign: TextAlign.center)` (e.g., "You can change this later in settings")
  - [ ] Scaffold background: `context.colors.background`
  - [ ] Submit button: `AddRecordNextButton(label: 'save_reminder'.tr(), onPressed: () => cubit.submitMedicine())`
  - [ ] Apply pre-refactor checklist before marking complete

---

### 4.6 — `AddMedicineFifthStepVeiw` (Step 5 — Success Confirmation)

- [ ] Create `lib/features/medicine/veiw/add_medicine_fifth_step_veiw.dart`
  - [ ] No `ProgressStepLayout` — this is the terminal screen; use plain `Scaffold`
  - [ ] Scaffold background: `context.colors.background`
  - [ ] Centered column layout: success illustration (Lottie or static asset via `AppImages.*`) + title + subtitle + CTA
  - [ ] Title: `Text('success_title'.tr(), style: context.typography.title, textAlign: TextAlign.center)`
  - [ ] Subtitle: `Text('success_subtitle'.tr(), style: context.typography.body.copyWith(color: context.colors.textSecondary), textAlign: TextAlign.center)`
  - [ ] CTA button: `AddRecordNextButton(label: 'go_to_my_medicines'.tr(), onPressed: () { cubit.resetForm(); context.go('/medicines'); })`
  - [ ] On `initState`: trigger `context.read<UserMedicinesCubit>().loadMedicines()` to refresh the list in background so it's fresh when the user returns
  - [ ] Apply pre-refactor checklist before marking complete

---

## Task 5 — Routing & Dependency Injection

> **Goal:** Wire everything into the app's global DI container and router.
> 🔒 Blocked until Tasks 1–4 are fully complete and all views compile cleanly.

### 5.1 — GetIt Registration

- [ ] Open `lib/core/Services/GetItServices.dart`
- [ ] Register services (in order — no dependencies first):
  - [ ] `getIt.registerSingleton<MedicineLocalService>(MedicineLocalService())`
    - [ ] Call `await getIt<MedicineLocalService>().init()` during app startup (in `main.dart` before `runApp`)
  - [ ] `getIt.registerSingleton<MedicineService>(MedicineService(getIt<DioHelper>()))`
- [ ] Register repository:
  - [ ] `getIt.registerSingleton<MedicineRepository>(MedicineRepository(localService: getIt<MedicineLocalService>(), remoteService: getIt<MedicineService>()))`
- [ ] Register cubits (factory — new instance per navigation):
  - [ ] `getIt.registerFactory<AddMedicineCubit>(() => AddMedicineCubit(getIt<MedicineRepository>()))`
  - [ ] `getIt.registerFactory<UserMedicinesCubit>(() => UserMedicinesCubit(getIt<MedicineRepository>()))`
- [ ] Verify registration order matches `plan.md` Section 6 exactly

---

### 5.2 — GoRouter Routes

- [ ] Open `lib/core/config/routing/router_generation.dart`
- [ ] Add the `/medicines` route branch:
  - [ ] `/medicines` → `UserMedicinesVeiw` (wrapped in `BlocProvider<UserMedicinesCubit>`)
  - [ ] `/medicines/add` → `ShellRoute` or parent route that provides `BlocProvider<AddMedicineCubit>(create: (_) => getIt<AddMedicineCubit>())`
    - [ ] `/medicines/add/1` → `AddMedicineFirstStepVeiw`
    - [ ] `/medicines/add/2` → `AddMedicineSecondStepVeiw`
    - [ ] `/medicines/add/3` → `AddMedicineThirdStepVeiw`
    - [ ] `/medicines/add/4` → `AddMedicineFourthStepVeiw`
    - [ ] `/medicines/add/5` → `AddMedicineFifthStepVeiw`
  - [ ] Verify the `AddMedicineCubit` `BlocProvider` is scoped to the `/medicines/add` shell so state persists across step navigation
- [ ] Register any named route constants in the routing constants file (if project uses them)

---

### 5.3 — Localization Keys

- [ ] Add all new localization keys to both `en.json` and `ar.json` translation files
  - [ ] Step labels: `step_x_of_y`, `step1_question`, `step1_subtitle`, `step1_info_hint`, `medicine_name_hint`
  - [ ] Step 2: `step2_question`, `dose_form_label`, `frequency_label`, `dose_form_pill`, `dose_form_liquid`, `dose_form_injection`, `dose_form_drops`, `dose_form_inhaler`, `dose_form_patch`, `frequency_daily`, `frequency_weekly`, `frequency_as_needed`
  - [ ] Step 3: `step3_question`, `notes_label`, `notes_hint`, `add_alarm_time`
  - [ ] Step 4: `step4_question`, `step4_helper`, `save_reminder`
  - [ ] Step 5: `success_title`, `success_subtitle`, `go_to_my_medicines`
  - [ ] Common: `next`, `next_step`, `skip`, `skip_for_now`, `add_medicine`, `my_medicines`
  - [ ] Errors: `error_medicine_name_required`, `error_dose_form_required`, `error_frequency_required`
  - [ ] Sync: `sync_failed_banner` (e.g., "N medicines couldn't sync. Tap to retry.")
  - [ ] List: `add_your_first_medicine`, `empty_medicines_title`, `empty_medicines_subtitle`
  - [ ] Verify all Arabic translations are provided and RTL-safe

---

### 5.4 — Final Integration Checklist

- [ ] Run `flutter analyze` — zero errors, zero warnings
- [ ] Run `flutter test` — all existing tests pass (no regressions)
- [ ] Manually test the full 5-step flow on an **LTR (English)** locale:
  - [ ] Step 1 → 5 forward navigation
  - [ ] Back navigation (Step 3 → 2 → 1) preserves entered data
  - [ ] Skip on Step 2 and Step 3 works correctly
  - [ ] Close on Step 1 resets form and returns to medicines list
  - [ ] Offline mode: disable network, complete all steps, verify success screen appears and local record is created
  - [ ] Reconnect: verify pending record syncs and `sync_status` updates to `synced`
- [ ] Manually test the full flow on an **RTL (Arabic)** locale:
  - [ ] Verify all padding/margin directions are mirrored correctly
  - [ ] Verify all text aligns to the start (right in Arabic)
  - [ ] Verify icons on the correct side
- [ ] Test on tablet breakpoint — verify `ProgressStepLayout` and card layouts adapt correctly
- [ ] Verify dark mode — all `context.colors.*` tokens render their dark variants

---

## Implementation Order Summary

```
Task 1.1 Models & DTOs
    ↓
Task 1.2 MedicineLocalService (sqflite)
    ↓
Task 1.3 MedicineService (API)
    ↓
Task 1.4 MedicineRepository (orchestration)
    ↓
Task 2.1 AddMedicineState
    ↓
Task 2.2 AddMedicineCubit
    ↓
Task 2.3 UserMedicinesState
    ↓
Task 2.4 UserMedicinesCubit
    ↓
Task 3.1 StepProgressBarWidget
Task 3.2 DoseFormSelectorWidget     ← These 6 are parallelizable
Task 3.3 FrequencySelectorWidget
Task 3.4 TimePickerRowWidget
Task 3.5 MedicineSummaryCardWidget
Task 3.6 MedicineCardWidget
Task 3.7 MedicineEmptyStateWidget
Task 3.8 MedicineBottomNavBarWidget
    ↓
Task 4.1 UserMedicinesVeiw
Task 4.2 AddMedicineFirstStepVeiw   ← Steps are sequential (each depends on prev cubit state)
Task 4.3 AddMedicineSecondStepVeiw
Task 4.4 AddMedicineThirdStepVeiw
Task 4.5 AddMedicineFourthStepVeiw
Task 4.6 AddMedicineFifthStepVeiw
    ↓
Task 5.1 GetIt Registration
Task 5.2 GoRouter Routes
Task 5.3 Localization Keys
Task 5.4 Final Integration Checklist
```

---

> **Status:** Ready for implementation signal.
> **Next:** Awaiting confirmation to begin **Task 1**.
>
> **Project:** Cureta — Medicine & Alerts Feature
> **Last Updated:** 2026-04-25
