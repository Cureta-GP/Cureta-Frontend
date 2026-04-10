# Refactor [Chat_screen.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/chat_bot/veiw/Chat_screen.dart) — Extract Theme Tokens & Decompose Into Widgets

## Problem

[Chat_screen.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/chat_bot/veiw/Chat_screen.dart) is an **832-line monolithic build method** containing:

- **~25 hardcoded colors** (e.g. [Color(0xFF00A0A8)](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_colors.dart#3-140), [Color(0xFFF5F8F8)](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_colors.dart#3-140), …)
- **~12 inline `TextStyle` blocks** with explicit `fontSize`, `fontWeight`, and `fontFamily`
- **Fixed pixel widths/heights** everywhere (e.g. `width: 375`, `width: 360`, `height: 71.20`)
- **No widget decomposition** — everything is a nested tree of `Container → Row/Column → Container …`
- **Icons rendered as `Text` with `fontFamily: 'Material Icons'`** instead of the `Icon` widget

This violates the project's theme system ([AppColors](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_colors.dart#3-140), [AppTypography](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_typography.dart#3-546), [AppSpacing](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_spacing.dart#3-88), [AppRadius](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_radius.dart#3-78)) and the [rules.md.txt](file:///d:/Flutter_Projects/Cureta-Frontend/rules.md.txt) guidelines (small private widgets, composition over inheritance, `const` constructors, no hardcoded styles).

---

## Hardcoded Value Audit

### Colors

| Hardcoded Value | Occurrences | Existing Token | Action |
|---|---|---|---|
| [Color(0xFFF5F8F8)](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_colors.dart#3-140) | 1 (screen bg) | `colors.background` (white/dark) — **close but not exact** | Add `chatBackground` to [AppColors](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_colors.dart#3-140) **or** use `colors.surface` |
| `Colors.white` | 4 (header bg, assistant bubble bg) | `colors.background` (light = white) | Use `colors.background` |
| [Color(0xFFF1F5F9)](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_colors.dart#3-140) | 2 (header border, input border) | `colors.divider` (`0xFFE0E0E0`) — **different shade** | Add `chatBorderLight` to [AppColors](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_colors.dart#3-140) **or** reuse `colors.divider` |
| [Color(0xFFE5F5F6)](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_colors.dart#3-140) | 4 (bot avatar bg, quick-action bg) | `colors.accentCyan` (`0xFFE0F1F3`) — **very close** | **Reuse `colors.accentCyan`** |
| [Color(0xFF00A0A8)](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_colors.dart#3-140) | 5 (bot icon, user bubble bg, quick-action text, send btn) | `colors.primary` (`0xFF00A1A9`) — **1 hex step off** | **Reuse `colors.primary`** |
| [Color(0xFF0F172A)](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_colors.dart#3-140) | 1 (header title) | `colors.textPrimary` (`0xFF212121`) — **similar dark** | Add `chatHeaderTitle` **or** reuse `colors.textPrimary` |
| [Color(0xFF10B981)](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_colors.dart#3-140) | 1 (online dot) | No match | Add `statusOnline` to [AppColors](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_colors.dart#3-140) |
| [Color(0xFF64748B)](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_colors.dart#3-140) | 2 (online text, close icon) | `colors.textSecondary` (`0xFF757575`) — **close** | **Reuse `colors.textSecondary`** |
| [Color(0xFF33B3B9)](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_colors.dart#3-140) | 2 (assistant label) | Close to `primary` | Add `chatAssistantLabel` **or** derive from `primary` |
| [Color(0xFF1E293B)](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_colors.dart#3-140) | 2 (assistant body text) | `colors.textPrimary` — close | **Reuse `colors.textPrimary`** |
| [Color(0xFF94A3B8)](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_colors.dart#3-140) | 3 (user label, attach icon, mic icon) | `colors.textHint` (`0xFFBDBDBD`) — **different shade** | `colors.icon` (`0xFF99A1AF`) — **closest match, use it** |
| [Color(0xFFE2E8F0)](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_colors.dart#3-140) | 1 (user avatar bg) | `colors.divider` — close | Reuse `colors.divider` or add dedicated token |
| [Color(0xFFCCECED)](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_colors.dart#3-140) | 3 (quick-action border) | No exact match | Add `chatQuickActionBorder` **or** derive |
| [Color(0xFF878B94)](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_colors.dart#3-140) | 1 (input placeholder) | `colors.textHint` — close | **Reuse `colors.textHint`** |

### Text Styles

| Usage | Current Inline Style | Matching [AppTypography](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_typography.dart#3-546) Token | Action |
|---|---|---|---|
| Header title "Cureta Assistant" | `fontSize: 16, w700` | `body` (16, normal) — weight differs | Add `chatHeaderTitle` to [AppTypography](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_typography.dart#3-546) |
| Online status | `fontSize: 11, w500` | None exact | Add `chatStatusLabel` |
| Assistant label "Assistant" | `fontSize: 12, w600` | `label` is 14 — close but smaller | Add `chatSenderLabel` |
| Message body text | `fontSize: 15, w400` | `body` (16, normal) — close | Add `chatMessageBody` |
| User label "You" | `fontSize: 12, w600` | Same as assistant label above | Reuse `chatSenderLabel` |
| Quick-action chip text | `fontSize: 14, w500` | `label` (14, normal) — weight differs | Add `chatQuickActionLabel` |
| Input placeholder | `fontSize: 15, w400` | Same as message body | Reuse `chatMessageBody` |

### Spacing & Radius

| Usage | Hardcoded Value | Matching Token | Action |
|---|---|---|---|
| Header padding | `h:16, v:12` | `spacing.lg` (16), `spacing.md` (12) | Use tokens |
| Message area padding | `h:16, v:24` | `spacing.lg` (16), `spacing.xl` (24) | Use tokens |
| Avatar gap | `12` | `spacing.md` (12) | Use `spacing.md` |
| Label-to-bubble gap | `6` | None exact (xs=8, closest) | Use a fraction or add `spacing.xxs` |
| Message vertical gap | `24` | `spacing.xl` (24) | Use `spacing.xl` |
| Quick-action gap | `8` | `spacing.xs` (8) | Use `spacing.xs` |
| Bubble corner radius | `24` | `radius.xl` (24) | Use `radius.xl` |
| Full circle (avatar) | `9999` | `radius.full` (9999) | Use `radius.full` |
| Input field radius | `16` | `radius.md` is 14 — close | Use `radius.lg` (18) **or** add token |
| Send btn radius | `24` | `radius.xl` (24) | Use `radius.xl` |

---

## Proposed Changes

### Component 1: Theme Tokens

#### [MODIFY] [app_colors.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_colors.dart)

Add chat-specific colors:

```dart
final Color chatBackground;      // 0xFFF5F8F8 light / dark variant
final Color statusOnline;         // 0xFF10B981
final Color chatAssistantLabel;   // 0xFF33B3B9
final Color chatQuickActionBorder;// 0xFFCCECED
```

> These 4 colors have no close match in the existing palette. All other hardcoded colors can map to existing tokens (`primary`, `background`, `textPrimary`, `textSecondary`, `textHint`, `icon`, `accentCyan`, `divider`).

#### [MODIFY] [app_typography.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/theme/app_typography.dart)

Add chat-specific text styles (with mobile / tablet / desktop scales):

```dart
final TextStyle chatHeaderTitle;      // 16/w700 → 18/w700 → 20/w700
final TextStyle chatStatusLabel;      // 11/w500 → 13/w500 → 15/w500
final TextStyle chatSenderLabel;      // 12/w600 → 14/w600 → 16/w600
final TextStyle chatMessageBody;      // 15/w400 → 17/w400 → 19/w400
final TextStyle chatQuickActionLabel; // 14/w500 → 16/w500 → 18/w500
```

---

### Component 2: Widget Decomposition

All new widget files go in [widgets/](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/chat_bot/widgets/).

#### [NEW] [chat_header.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/chat_bot/widgets/chat_header.dart)

Extracts lines **23–195** (header bar with bot avatar, title, online status, close button).

- Uses `context.colors`, `context.typography`, `context.spacing`, `context.radius`
- Replaces `Text('smart_toy', fontFamily: 'Material Icons')` with `Icon(Icons.smart_toy)`
- Replaces `Text('close', fontFamily: 'Material Icons')` with `IconButton(icon: Icon(Icons.close))`
- Removes all hardcoded widths/heights, uses intrinsic sizing

#### [NEW] [chat_bot_avatar.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/chat_bot/widgets/chat_bot_avatar.dart)

Reusable circular bot avatar (appears 3 times in the screen). Params: `double size`.

- Uses `colors.accentCyan` bg, `colors.primary` icon color, `radius.full`

#### [NEW] [chat_bubble.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/chat_bot/widgets/chat_bubble.dart)

Generic chat bubble supporting **assistant** and **user** variants. Params: `String senderLabel`, `String message`, `bool isUser`.

- Assistant: white bg, rounded top-left/top-right/bottom-right
- User: primary bg, rounded top-left/top-right/bottom-left, white text
- Uses `typography.chatSenderLabel`, `typography.chatMessageBody`, `radius.xl`

#### [NEW] [chat_message_list.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/chat_bot/widgets/chat_message_list.dart)

Extracts lines **196–509** (scrollable conversation area). Composes `ChatBotAvatar` + `ChatBubble` for each message.

- Uses `spacing.xl` for vertical gap, `spacing.md` for avatar gap
- Replaces fixed `width: 360`, `height: 576` with `Expanded` + `ListView`

#### [NEW] [quick_action_chips.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/chat_bot/widgets/quick_action_chips.dart)

Extracts the 3 quick-action pill buttons (lines **544–665**). Params: `List<String> labels`, `ValueChanged<String> onTap`.

- Uses `colors.accentCyan`, `colors.primary`, `typography.chatQuickActionLabel`
- Uses `Wrap` instead of fixed-width `Row` for responsiveness

#### [NEW] [chat_input_bar.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/chat_bot/widgets/chat_input_bar.dart)

Extracts lines **510–825** (bottom input area with attach, text field, mic, send button).

- Replaces `Text('attach_file', fontFamily: 'Material Icons')` → `Icon(Icons.attach_file)`
- Replaces `Text('mic', fontFamily: 'Material Icons')` → `Icon(Icons.mic)`
- Replaces `Text('send', fontFamily: 'Material Icons')` → `Icon(Icons.send)`
- Uses a real `TextField` with `InputDecoration` instead of static placeholder text
- Uses `colors`, `spacing`, `radius` tokens throughout

#### [MODIFY] [Chat_screen.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/chat_bot/veiw/Chat_screen.dart)

Refactored to ~40–50 lines:

```dart
Scaffold(
  body: Column(
    children: [
      const ChatHeader(),
      Expanded(child: ChatMessageList(messages: ...)),
      ChatInputBar(
        quickActions: ['Check symptoms', ...],
        onSend: ...,
      ),
    ],
  ),
)
```

- Removes the `AppBar` (the header widget replaces it)
- Removes `ConstrainedBox` with fixed `minHeight: 812` / `width: 375`
- Uses `context.colors.chatBackground` for scaffold bg

---

## Key Design Decisions

> [!IMPORTANT]
> **Hardcoded colors that are ≤2 hex digits away from existing tokens** (e.g. `0xFF00A0A8` vs `colors.primary` `0xFF00A1A9`) will be mapped to the existing token. If you need the exact Figma values preserved, please flag this.

> [!IMPORTANT]
> **Fixed widths/heights will be removed** in favor of `Expanded`, `Flexible`, and intrinsic sizing. The layout will become responsive. The current design is a static 375×812 mockup translation.

> [!WARNING]
> **`Text` widgets using `fontFamily: 'Material Icons'` will become `Icon` widgets.** This is a semantic fix — the current approach is fragile and won't work correctly on all platforms.

---

## Verification Plan

### Automated Tests

There are no existing widget tests for the chat screen. The [test/widget_test.dart](file:///d:/Flutter_Projects/Cureta-Frontend/test/widget_test.dart) file only contains a default counter app test.

- Run `flutter analyze` to ensure no lint errors in new/modified files:
  ```shell
  flutter analyze lib/features/chat_bot/ lib/core/theme/app_colors.dart lib/core/theme/app_typography.dart
  ```

### Manual Verification

> Since this is a UI-only refactoring, visual verification is the primary testing method.

1. **Hot-reload the app** and navigate to the Chat screen
2. Verify the screen looks **visually identical** to the current version (colors, spacing, text sizes)
3. Toggle **dark mode** and verify the chat screen responds to theme changes (it currently doesn't since all colors are hardcoded)
4. **Resize the window** (if running on web/desktop) and verify responsive behavior
5. Tap the quick-action chips and verify they are tappable (currently they are static containers)
6. Verify the input field is functional (currently a static placeholder)

> [!TIP]
> I recommend you visually compare before & after since there are no widget tests. Would you like me to write widget tests for the new components as part of the refactoring?
