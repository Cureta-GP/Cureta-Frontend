# 📐 Cureta — Styling & Architecture Guidelines

> **Authority Document:** This file is the single source of truth for all UI code generated in the Cureta project.
> Every screen, widget, and visual component **must** comply with these rules.

---

## Table of Contents

1. [Design System Overview](#1-design-system-overview)
2. [Responsiveness](#2-responsiveness)
3. [Theming & Colors](#3-theming--colors)
4. [Typography](#4-typography)
5. [Spacing](#5-spacing)
6. [Border Radii](#6-border-radii)
7. [Animation Durations](#7-animation-durations)
8. [Localization & RTL](#8-localization--rtl)
9. [State Management](#9-state-management)
10. [Clean Architecture](#10-clean-architecture)
11. [Dependency Injection](#11-dependency-injection)
12. [File Organization](#12-file-organization)
13. [Code Style & Constraints](#13-code-style--constraints)
14. [Quick-Reference Cheat Sheet](#14-quick-reference-cheat-sheet)
15. [Compliance Checklist](#15-compliance-checklist)

---

## 1. Design System Overview

Cureta uses a **fully custom, fluid design system** built entirely on Flutter `ThemeExtension`s — **not** on `ScreenUtil`.

| Layer              | Mechanism                                         | Source File                          |
| ------------------ | ------------------------------------------------- | ------------------------------------ |
| Colors             | `ThemeExtension<AppColors>`                        | `lib/core/theme/app_colors.dart`     |
| Typography         | `ThemeExtension<AppTypography>`                    | `lib/core/theme/app_typography.dart`  |
| Spacing            | `ThemeExtension<AppSpacing>`                       | `lib/core/theme/app_spacing.dart`     |
| Border Radii       | `ThemeExtension<AppRadius>`                        | `lib/core/theme/app_radius.dart`      |
| Animation Durations| `ThemeExtension<AppDurations>`                     | `lib/core/theme/app_durations.dart`   |
| Breakpoints        | `Breakpoints` utility class + `DeviceType` enum    | `lib/core/theme/breakpoints.dart`     |
| Context Shortcuts  | `BuildContext` extensions (`context.colors`, etc.) | `lib/core/theme/theme_extensions.dart` |
| Theme Assembly     | `AppThemeFactory.create()`                         | `lib/core/theme/app_theme_factory.dart`|

### How Fluid Responsiveness Works

`AppThemeFactory.create()` is called inside a `LayoutBuilder` in `main.dart`. It receives the actual `screenWidth` and:

1. Determines the `DeviceType` from breakpoints.
2. **Linearly interpolates** (`lerp`) all spacing, radii, and typography between tier presets (mobile ↔ tablet ↔ desktop).
3. Injects the computed `ThemeExtension`s into `ThemeData.extensions`.

**You never need to manually scale values.** All tokens accessed via `context.spacing`, `context.radius`, and `context.typography` are already fluid.

---

## 2. Responsiveness

### ❌ What NOT To Do

```dart
// FORBIDDEN: Hardcoded pixel values
SizedBox(width: 16);
Padding(padding: EdgeInsets.all(24));
BorderRadius.circular(12);
TextStyle(fontSize: 16);

// FORBIDDEN: ScreenUtil extensions (not used in this project)
SizedBox(width: 16.w);
TextStyle(fontSize: 14.sp);
```

### ✅ What To Do

All dimensions come from **theme extensions** accessed via `BuildContext`:

```dart
// Spacing
SizedBox(width: context.spacing.md);
Padding(padding: EdgeInsets.all(context.spacing.lg));
EdgeInsets.symmetric(
  horizontal: context.spacing.lg,
  vertical: context.spacing.md,
);

// Radii
BorderRadius.circular(context.radius.md);
RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(context.radius.lg),
);

// Typography — always from context.typography
Text('Hello', style: context.typography.title);

// Colors — always from context.colors
Container(color: context.colors.primary);
```

### Breakpoints Reference

| DeviceType     | Min Width  |
| -------------- | ---------- |
| `mobile`       | 0 px       |
| `tablet`       | 600 px     |
| `largeTablet`  | 900 px     |
| `desktop`      | 1200 px    |

If you need conditional layout (e.g. column vs row), use `Breakpoints.of(context)`:

```dart
final device = Breakpoints.of(context);
if (device == DeviceType.mobile) {
  // single column layout
} else {
  // multi-column layout
}
```

> **Warning:** Never use `MediaQuery.of(context).size.width` with manual breakpoint numbers inline. Always use `Breakpoints.of(context)` to determine the `DeviceType`.

---

## 3. Theming & Colors

### Access Pattern

```dart
// ✅ Via context extension (preferred)
context.colors.primary
context.colors.textPrimary
context.colors.chatBackground

// ✅ Via Theme.of(context) (acceptable)
Theme.of(context).extension<AppColors>()!.primary
Theme.of(context).colorScheme.primary  // for Material widget overrides
```

### ❌ Forbidden

```dart
// NEVER hardcode hex colors
Color(0xFF00A1A9)
Colors.teal
Colors.white  // use context.colors.background instead
```

### Available Color Tokens

| Token                   | Light Value      | Usage                          |
| ----------------------- | ---------------- | ------------------------------ |
| `primary`               | `#00A1A9`        | Brand teal, buttons, accents   |
| `primaryDark`           | `#133A3E`        | Dark brand variant             |
| `secondary`             | `#EDF7F8`        | Light tint backgrounds         |
| `background`            | `#FFFFFF`        | Scaffold background            |
| `surface`               | `#FAFAFA`        | Card / elevated surfaces       |
| `error`                 | `#B00020`        | Error states                   |
| `textPrimary`           | `#212121`        | Main body text                 |
| `textSecondary`         | `#757575`        | Secondary / muted text         |
| `textHint`              | `#BDBDBD`        | Placeholder / hint text        |
| `divider`               | `#E0E0E0`        | Divider lines                  |
| `icon`                  | `#99A1AF`        | Default icon color             |
| `accentCyan`            | `#E0F1F3`        | Accent card background         |
| `accentOrange`          | `#FFEDD5`        | Accent card background         |
| `accentBlue`            | `#E0E7FF`        | Accent card background         |
| `accentPurple`          | `#F5F3FF`        | Accent card background         |
| `chatBackground`        | `#F5F8F8`        | Chat screen background         |
| `statusOnline`          | `#10B981`        | Online indicator                |
| `chatAssistantLabel`    | `#33B3B9`        | Assistant name label            |
| `chatQuickActionBorder` | `#CCECED`        | Quick action chip border        |

All tokens have matching **dark mode** counterparts defined in `AppColors.dark` — dark mode is handled automatically.

---

## 4. Typography

### Access Pattern

```dart
// ✅ Always via context extension
Text('Title', style: context.typography.title);
Text('Body text', style: context.typography.body);

// ✅ With color override (color comes from theme too)
Text(
  'Label',
  style: context.typography.label.copyWith(
    color: context.colors.textSecondary,
  ),
);
```

### ❌ Forbidden

```dart
// NEVER hardcode font sizes
TextStyle(fontSize: 16)

// NEVER use Theme.of(context).textTheme for custom styles
// Use context.typography instead — it contains all project-specific styles
```

### Available Typography Tokens

#### Generic Tokens

| Token      | Mobile Size | Weight   | Usage                     |
| ---------- | ----------- | -------- | ------------------------- |
| `hero`     | 32 sp       | Bold     | Hero headings             |
| `title`    | 24 sp       | Bold     | Section titles            |
| `body`     | 16 sp       | Normal   | Body copy                 |
| `label`    | 14 sp       | Normal   | Labels, captions          |
| `button`   | 16 sp       | w600     | Button text               |

#### Medical Records Tokens

| Token                             | Mobile Size | Weight |
| --------------------------------- | ----------- | ------ |
| `medicalRecordQuestion`           | 32 sp       | w700   |
| `medicalRecordInput`              | 19 sp       | w400   |
| `medicalRecordButton`             | 19 sp       | w700   |
| `medicalRecordStep`               | 15 sp       | w600   |
| `medicalRecordProgress`           | 13 sp       | w500   |
| `medicalRecordHelper`             | 15 sp       | w400   |
| `medicalRecordCancel`             | 16 sp       | w500   |
| `medicalRecordScreenTitle`        | 20 sp       | w700   |
| `medicalRecordPickerLabel`        | 18 sp       | w500   |
| `medicalRecordChoice`             | 18 sp       | w600   |
| `medicalRecordSkip`               | 16 sp       | w500   |
| `medicalRecordOptional`           | 24 sp       | w400   |
| `medicalRecordUploadTitle`        | 30 sp       | w700   |
| `medicalRecordUploadDescription`  | 16 sp       | w400   |
| `medicalRecordUploadCardTitle`    | 18 sp       | w700   |
| `medicalRecordUploadCardDescription` | 14 sp    | w400   |
| `medicalRecordSecureNote`         | 12 sp       | w400   |
| `medicalRecordDetailHero`         | 40 sp       | w800   |
| `medicalRecordDetailLabel`        | 14 sp       | w500   |
| `medicalRecordDetailBody`         | 18 sp       | w400   |
| `medicalRecordDetailDeleteBtn`    | 17 sp       | w700   |

#### Home Screen Tokens

| Token                | Mobile Size | Weight |
| -------------------- | ----------- | ------ |
| `homeWelcomeBack`    | 13 sp       | w400   |
| `homeUserName`       | 20 sp       | w700   |
| `homeSectionTitle`   | 18 sp       | w700   |
| `homeSeeAll`         | 14 sp       | w600   |
| `homeQuickActionLabel` | 12 sp     | w600   |
| `homeMedName`        | 16 sp       | w700   |
| `homeMedNote`        | 14 sp       | w400   |
| `homeMedTime`        | 12 sp       | w700   |
| `homeActivityName`   | 16 sp       | w700   |
| `homeActivityDate`   | 14 sp       | w400   |

#### Chat Tokens

| Token                | Mobile Size | Weight |
| -------------------- | ----------- | ------ |
| `chatHeaderTitle`    | 16 sp       | w700   |
| `chatStatusLabel`    | 11 sp       | w500   |
| `chatSenderLabel`    | 12 sp       | w600   |
| `chatMessageBody`    | 15 sp       | w400   |
| `chatQuickActionLabel` | 14 sp     | w500   |

#### Surface Tokens

| Token          | Mobile Size | Weight |
| -------------- | ----------- | ------ |
| `surfaceTitle` | 26 sp       | w700   |

> **Tip:** When building a **new feature**, add new feature-specific typography tokens to `AppTypography` (with mobile/tablet/desktop variants) instead of hardcoding font sizes. This keeps the fluid system consistent.

---

## 5. Spacing

### Access Pattern

```dart
context.spacing.xs    // 8   (mobile)
context.spacing.sm    // 10  (mobile)
context.spacing.md    // 12  (mobile)
context.spacing.lg    // 16  (mobile)
context.spacing.xl    // 24  (mobile)
context.spacing.xxl   // 32  (mobile)
context.spacing.hairline // 1 (mobile) — for divider thickness
```

### Usage Examples

```dart
// Padding
Padding(
  padding: EdgeInsets.symmetric(
    horizontal: context.spacing.lg,
    vertical: context.spacing.md,
  ),
  child: ...
);

// SizedBox gaps
Column(
  children: [
    WidgetA(),
    SizedBox(height: context.spacing.sm),
    WidgetB(),
    SizedBox(height: context.spacing.lg),
    WidgetC(),
  ],
);
```

### Spacing Scale (all tiers)

| Token      | Mobile | Tablet | Desktop |
| ---------- | ------ | ------ | ------- |
| `hairline` | 1      | 1.2    | 1.4     |
| `xs`       | 8      | 10     | 12      |
| `sm`       | 10     | 12     | 14      |
| `md`       | 12     | 16     | 18      |
| `lg`       | 16     | 20     | 24      |
| `xl`       | 24     | 28     | 32      |
| `xxl`      | 32     | 40     | 48      |

---

## 6. Border Radii

### Access Pattern

```dart
BorderRadius.circular(context.radius.md);
```

### Radius Scale

| Token  | Mobile | Tablet | Desktop | Usage                          |
| ------ | ------ | ------ | ------- | ------------------------------ |
| `sm`   | 10     | 12     | 14      | Chips, small tags              |
| `md`   | 14     | 16     | 18      | Buttons, input fields          |
| `lg`   | 18     | 20     | 24      | Cards, modals                  |
| `xl`   | 24     | 28     | 32      | Large panels                   |
| `xxl`  | 32     | 36     | 40      | Bottom sheets                  |
| `full` | 9999   | 9999   | 9999    | Circles / pill shapes          |

---

## 7. Animation Durations

### Access Pattern

```dart
// ✅ From theme
AnimatedContainer(
  duration: context.durations.normal,
  ...
);

AnimatedOpacity(
  duration: context.durations.fast,
  ...
);
```

### Duration Scale

| Token    | Value   | Usage                                |
| -------- | ------- | ------------------------------------ |
| `fast`   | 150 ms  | Hover effects, micro-interactions    |
| `normal` | 300 ms  | Standard transitions                 |
| `slow`   | 500 ms  | Page transitions, complex animations |

---

## 8. Localization & RTL

### Rules

1. **Arabic is the primary language.** The app ships with `supportedLocales: [Locale('en'), Locale('ar')]` and uses `easy_localization`.

2. **Never hardcode UI strings.** All user-facing text must use localization keys:
   ```dart
   Text('welcome_back'.tr());  // easy_localization
   ```

3. **RTL-aware layout:** Use directional-aware widgets and properties:
   ```dart
   // ✅ Correct
   EdgeInsetsDirectional.only(start: context.spacing.lg);
   Align(alignment: AlignmentDirectional.centerStart);

   // ❌ Incorrect
   EdgeInsets.only(left: context.spacing.lg);
   Align(alignment: Alignment.centerLeft);
   ```

4. **Row alignment:** When using `Row`, prefer `MainAxisAlignment` (direction-agnostic) or use `AlignmentDirectional`:
   ```dart
   Row(
     textDirection: TextDirection.rtl,  // only if explicitly needed
     children: [...],
   );
   ```

5. **Text alignment:** For Arabic-first display:
   ```dart
   Text(
     'some_key'.tr(),
     textAlign: TextAlign.start,  // auto-adapts to locale direction
   );
   ```

> **Note:** The app uses `EasyLocalization` with `context.locale`, `context.localizationDelegates`, and `context.supportedLocales` configured in `main.dart`. The system handles directionality automatically — you do **not** need to manually wrap in `Directionality` widgets unless overriding for a specific widget subtree.

---

## 9. State Management

### Pattern: **Cubit + BlocBuilder / BlocConsumer**

```dart
// ✅ Providing cubit (via GetIt)
BlocProvider<MyCubit>(
  create: (_) => getIt<MyCubit>()..loadData(),
  child: const MyScreen(),
);

// ✅ Building UI from state
BlocBuilder<MyCubit, MyState>(
  builder: (context, state) {
    return switch (state) {
      MyInitial()  => const SizedBox.shrink(),
      MyLoading()  => const CircularProgressIndicator(),
      MyLoaded(:final data) => _buildContent(context, data),
      MyError(:final message) => _buildError(context, message),
    };
  },
);

// ✅ When side effects are needed (navigation, snackbar)
BlocConsumer<MyCubit, MyState>(
  listener: (context, state) {
    if (state is MyError) {
      ScaffoldMessenger.of(context).showSnackBar(...);
    }
  },
  builder: (context, state) { ... },
);
```

### Rules

| Rule | Description |
| ---- | ----------- |
| **No `setState`** | All state mutations go through Cubits |
| **No logic in UI** | Business logic, API calls, validation → Cubit methods |
| **Use `getIt` for DI** | Never manually instantiate Cubits in widgets |
| **Prefer `sealed class` states** | Use Dart 3 sealed classes or `Equatable` for states |
| **`BlocBuilder` for read** | When you only need to rebuild UI |
| **`BlocConsumer` for read+effect** | When you also need listeners (snackbar, navigation) |

---

## 10. Clean Architecture

### Feature Folder Structure

```
lib/features/<feature_name>/
├── data/
│   ├── models/          # DTOs, JSON-serializable data classes
│   ├── services/        # Raw API calls (DioHelper)
│   └── repo/            # Repository: orchestrates services, handles errors
├── veiw_model/          # Cubits + States
├── veiw/                # Screen-level widgets (full pages)
└── widgets/             # Small, reusable UI components for this feature
```

### Layer Responsibilities

| Layer          | File Location         | Responsibility                                    | Depends On         |
| -------------- | --------------------- | ------------------------------------------------- | ------------------ |
| **Service**    | `data/services/`      | Raw HTTP calls via `DioHelper`                     | `DioHelper`        |
| **Repository** | `data/repo/`          | Error handling, data mapping, business rules       | Service            |
| **Cubit**      | `veiw_model/`         | Orchestrate state, call repository methods          | Repository         |
| **View**       | `veiw/`               | Full screen with `BlocProvider` / `BlocBuilder`     | Cubit (via GetIt)  |
| **Widget**     | `widgets/`            | Stateless visual components, receive data via ctor  | Nothing            |

### Rules

1. **Views must not contain business logic** — only layout and Bloc binding.
2. **Widgets are pure UI** — receive everything through constructor parameters.
3. **Repositories never expose raw models** — map DTOs to domain objects.
4. **No cross-feature imports** — shared code goes in `lib/shared/widgets/`.
5. **Keep files under ~100 lines** — extract sub-widgets into `widgets/` folder.

---

## 11. Dependency Injection

### Registration Pattern (in `GetItServices.dart`)

```dart
// Services → Singleton
getIt.registerSingleton<MyService>(MyService());

// Repositories → Singleton (depends on Service)
getIt.registerSingleton<MyRepository>(
  MyRepository(getIt.get<MyService>()),
);

// Cubits → Factory (new instance per screen)
getIt.registerFactory<MyCubit>(
  () => MyCubit(getIt.get<MyRepository>()),
);
```

### Registration Order

1. **Services** (no dependencies)
2. **Repositories** (depend on services)
3. **Cubits** (depend on repositories)

---

## 12. File Organization

### Project Structure

```
lib/
├── core/
│   ├── Services/            # GetIt setup, DioHelper
│   ├── config/              # Routing (GoRouter)
│   ├── constants/           # AppIcons, AppImages, ApiEndpoints, AnimationEnum
│   ├── error_handling/      # Error models
│   ├── localization/        # Localization utilities
│   ├── theme/               # FULL DESIGN SYSTEM (colors, typography, spacing, radius, durations, breakpoints)
│   └── utils/               # Helpers
├── features/                # Feature modules (auth, chat_bot, home, medical_records, profile, etc.)
├── shared/
│   └── widgets/             # Cross-feature reusable widgets
└── main.dart                # App entry point + LayoutBuilder theme setup
```

### Asset Path Constants

```dart
// Icons
AppIcons.send        // 'assets/icons/send.png'
AppIcons.daughter    // 'assets/icons/daughter.png'

// Images
AppImages.logo       // 'assets/images/logo.png'
AppImages.google     // 'assets/images/google.png'
```

> **Caution:** Never hardcode asset paths. Always use `AppIcons` and `AppImages` constants. If adding new assets, register them in the appropriate constants class first.

---

## 13. Code Style & Constraints

### General Rules

| Rule | Detail |
| ---- | ------ |
| **Max file length** | ~100 lines per file; extract widgets/helpers |
| **Material 3** | `useMaterial3: true` — use M3 component APIs |
| **Google Fonts** | Available via `google_fonts` package for custom typefaces |
| **No ScreenUtil** | Project does **not** use `flutter_screenutil` |
| **Prefer `const`** | Use `const` constructors wherever possible |
| **Named parameters** | Prefer named parameters for widget constructors |
| **Text scale clamping** | Enforced globally: min `0.8×`, max `1.5×` |
| **Theme animation** | 300ms `easeInOut` for light↔dark transitions |

### Routing

- **GoRouter** (`go_router: ^17.0.1`) is used for all navigation.
- Routes are defined in `lib/core/config/routing/router_generation.dart`.

### Networking

- **Dio** (`dio: ^5.9.0`) via `DioHelper` singleton.
- Base URL: `https://cureta.onrender.com/api/`.
- Logging via `pretty_dio_logger`.

### Key Dependencies

| Package                  | Purpose                 |
| ------------------------ | ----------------------- |
| `flutter_bloc / bloc`    | State management        |
| `get_it`                 | Dependency injection    |
| `go_router`              | Declarative routing     |
| `dio`                    | HTTP client             |
| `easy_localization`      | i18n / l10n             |
| `google_fonts`           | Typography              |
| `flutter_chat_ui`        | Chat interface          |
| `lottie` / `rive`        | Animations              |
| `shimmer`                | Loading skeletons        |
| `cached_network_image`   | Image caching           |
| `equatable`              | Value equality for states |

---

## 14. Quick-Reference Cheat Sheet

```dart
import 'package:cureta/core/theme/theme_extensions.dart';

// ── Colors ──
context.colors.primary
context.colors.primaryDark
context.colors.secondary
context.colors.background
context.colors.surface
context.colors.error
context.colors.textPrimary
context.colors.textSecondary
context.colors.textHint
context.colors.divider
context.colors.icon
context.colors.accentCyan
context.colors.accentOrange
context.colors.accentBlue
context.colors.accentPurple
context.colors.chatBackground
context.colors.statusOnline
context.colors.chatAssistantLabel
context.colors.chatQuickActionBorder

// ── Typography ──
context.typography.hero
context.typography.title
context.typography.body
context.typography.label
context.typography.button
context.typography.surfaceTitle
// ... plus all feature-specific tokens (see Section 4)

// ── Spacing ──
context.spacing.hairline  // 1
context.spacing.xs        // 8
context.spacing.sm        // 10
context.spacing.md        // 12
context.spacing.lg        // 16
context.spacing.xl        // 24
context.spacing.xxl       // 32

// ── Radii ──
context.radius.sm    // 10
context.radius.md    // 14
context.radius.lg    // 18
context.radius.xl    // 24
context.radius.xxl   // 32
context.radius.full  // 9999 (pill)

// ── Durations ──
context.durations.fast     // 150ms
context.durations.normal   // 300ms
context.durations.slow     // 500ms

// ── Device Type ──
final device = Breakpoints.of(context);
```

---

## 15. Compliance Checklist

Before submitting any UI code, verify **every** item:

- [ ] **No hardcoded colors** — all colors from `context.colors.*`
- [ ] **No hardcoded font sizes** — all text styles from `context.typography.*`
- [ ] **No hardcoded spacing** — all padding/margins from `context.spacing.*`
- [ ] **No hardcoded radii** — all border radii from `context.radius.*`
- [ ] **No hardcoded durations** — all animation durations from `context.durations.*`
- [ ] **No ScreenUtil** — project uses theme extensions, not `.w` / `.h` / `.sp`
- [ ] **RTL-safe** — uses `EdgeInsetsDirectional`, `AlignmentDirectional`, `TextAlign.start`
- [ ] **Localized strings** — all user-facing text uses `'key'.tr()`
- [ ] **State via Cubit** — no `setState()`, all logic through Cubits
- [ ] **GetIt for DI** — cubits provided via `getIt<MyCubit>()`
- [ ] **File ≤ ~100 lines** — complex UI extracted to sub-widgets
- [ ] **Feature structure** — `data/` → `veiw_model/` → `veiw/` → `widgets/`
- [ ] **Const constructors** — used wherever possible
- [ ] **No cross-feature imports** — shared code in `lib/shared/widgets/`
- [ ] **Asset paths** — from `AppIcons` / `AppImages`, never hardcoded

---

> **Last Updated:** 2026-04-20
>
> **Project:** Cureta Frontend
>
> **Architecture:** Clean Architecture + MVVM (Cubit)
>
> **Responsive System:** Fluid ThemeExtension lerp (mobile ↔ tablet ↔ desktop)
