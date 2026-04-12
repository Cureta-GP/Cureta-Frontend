# Chat Bot API Integration — MVVM with Cubit, Repository, Service & GetIt

## Goal

Wire the 3 chat API endpoints into the existing `chat_bot` feature using the **exact same MVVM pattern** already established in the codebase (Service → Repository → Cubit → View), with GetIt DI registration.

All new files must stay **under 100 lines**.

---

## API Endpoints Summary

| Method | Path | Purpose |
|--------|------|---------|
| `GET` | `/api/chats/profile/{profile_id}` | List chat sessions for a profile |
| `GET` | `/api/chats/session/{session_id}/messages` | Get messages for a chat session |
| `POST` | `/api/chat` | Send a message (creates session if `session_id` omitted) |

---

## Existing Patterns Followed

Based on [AuthService](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/authentcation/data/services/auth_service.dart), [AuthRepository](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/authentcation/data/repo/auth_repository.dart), [AuthCubit](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/authentcation/veiw_model/auth_view_model.dart), and [AuthState](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/authentcation/veiw_model/auth_state.dart):

- **Service**: Thin `DioHelper` wrapper, returns raw `Response`
- **Repository**: Constructor-injected service, parses JSON → models, wraps errors with `ErrorHandler.handle(e)`
- **Cubit**: Constructor-injected repository, `sealed` state classes with `Equatable`, catches `AppException`
- **GetIt**: Services as singletons → Repos as singletons (injected with service) → Cubits as factories (injected with repo)
- **Profile ID**: Resolved via `ProfileRepository.getResolvedSelectedProfileId()`

---

## Proposed Changes

### Component 1: Data Models (`data/models/`)

#### [NEW] chat_session_model.dart
`lib/features/chat_bot/data/models/chat_session_model.dart`

```dart
class ChatSessionModel {
  final String id;
  final String title;
  final DateTime createdAt;
  // factory fromJson(Map<String, dynamic>)
  // Map<String, dynamic> toJson()
}
```

#### [NEW] chat_message_model.dart
`lib/features/chat_bot/data/models/chat_message_model.dart`

```dart
class ChatMessageModel {
  final String id;
  final String role;   // "user" | "assistant"
  final String content;
  final DateTime createdAt;
  // factory fromJson(Map<String, dynamic>)
}
```

#### [NEW] send_message_request.dart
`lib/features/chat_bot/data/models/send_message_request.dart`

```dart
class SendMessageRequest {
  final String message;
  final String profileId;
  final String? sessionId;  // null → creates new session
  final String appLanguage;
  // Map<String, dynamic> toJson()
}
```

#### [NEW] send_message_response.dart
`lib/features/chat_bot/data/models/send_message_response.dart`

```dart
class SendMessageResponse {
  final String sessionId;
  final String answer;
  // factory fromJson(Map<String, dynamic>)
}
```

---

### Component 2: Service Layer (`data/services/`)

#### [NEW] chat_service.dart
`lib/features/chat_bot/data/services/chat_service.dart`

Three methods wrapping `DioHelper`:

| Method | DioHelper Call | Endpoint |
|--------|---------------|----------|
| `getSessions(profileId)` | `DioHelper.getData` | `chats/profile/$profileId` |
| `getMessages(sessionId)` | `DioHelper.getData` | `chats/session/$sessionId/messages` |
| `sendMessage(data)` | `DioHelper.postData` | `chat` |

---

### Component 3: Repository Layer (`data/repo/`)

#### [NEW] chat_repository.dart
`lib/features/chat_bot/data/repo/chat_repository.dart`

Constructor-injected with `ChatService`. Three methods:

| Method | Returns | Error handling |
|--------|---------|----------------|
| `fetchSessions(profileId)` | `List<ChatSessionModel>` | `ErrorHandler.handle(e)` |
| `fetchMessages(sessionId)` | `List<ChatMessageModel>` | `ErrorHandler.handle(e)` |
| `sendMessage(request)` | `SendMessageResponse` | `ErrorHandler.handle(e)` |

Each method follows the same pattern as `AuthRepository.login()`:
try → call service → check `status == "success"` → parse `data` → return model, catch → throw `ErrorHandler.handle(e)`.

---

### Component 4: ViewModel / Cubit Layer (`veiw_model/`)

> [!IMPORTANT]
> Two separate cubits to keep files under 100 lines and responsibilities clean.

#### [NEW] chat_sessions_state.dart
`lib/features/chat_bot/veiw_model/chat_sessions_state.dart`

```dart
sealed class ChatSessionsState extends Equatable { }
class ChatSessionsInitial    // no data
class ChatSessionsLoading    // loading spinner
class ChatSessionsSuccess    // List<ChatSessionModel>
class ChatSessionsError      // String message, AppException?
```

#### [NEW] chat_sessions_cubit.dart
`lib/features/chat_bot/veiw_model/chat_sessions_cubit.dart`

- `fetchSessions(profileId)` — loads session list
- Injected with `ChatRepository`

---

#### [NEW] chat_state.dart
`lib/features/chat_bot/veiw_model/chat_state.dart`

```dart
sealed class ChatState extends Equatable { }
class ChatInitial           // empty conversation
class ChatLoading           // waiting for assistant response
class ChatMessagesLoaded    // List<ChatMessageModel>, String? sessionId
class ChatError             // String message, AppException?
```

#### [NEW] chat_cubit.dart
`lib/features/chat_bot/veiw_model/chat_cubit.dart`

- `loadMessages(sessionId)` — fetches history for an existing session
- `sendMessage(text, profileId, appLanguage)` — sends user message, appends both user + assistant messages to state, tracks `sessionId`
- `startNewChat()` — resets to `ChatInitial`
- Injected with `ChatRepository`

---

### Component 5: DI Registration

#### [MODIFY] [GetItServices.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/core/Services/GetItServices.dart)

Add at the end of `setup()`:

```dart
// 🤖 Chat Bot
getIt.registerSingleton<ChatService>(ChatService());
getIt.registerSingleton<ChatRepository>(
  ChatRepository(getIt.get<ChatService>()),
);
getIt.registerFactory<ChatCubit>(
  () => ChatCubit(getIt.get<ChatRepository>()),
);
getIt.registerFactory<ChatSessionsCubit>(
  () => ChatSessionsCubit(getIt.get<ChatRepository>()),
);
```

---

### Component 6: View Layer Updates

#### [MODIFY] [Chat_screen.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/chat_bot/veiw/Chat_screen.dart)

- Wrap with `MultiBlocProvider` providing `ChatCubit` and `ChatSessionsCubit` from GetIt
- Replace static `_sampleMessages` with `BlocBuilder<ChatCubit, ChatState>`
- Connect `ChatInputBar.onSend` to `chatCubit.sendMessage()`
- Resolve `profileId` from `ProfileListCubit` state or `ProfileRepository`
- Resolve `appLanguage` from `context.locale`

#### [MODIFY] [chat_message.dart](file:///d:/Flutter_Projects/Cureta-Frontend/lib/features/chat_bot/widgets/chat_message.dart)

- Update `ChatMessage` widget model to be constructible from `ChatMessageModel` (add `factory ChatMessage.fromModel(ChatMessageModel)`)

---

## File Inventory (all under 100 lines)

| File | Est. Lines | Layer |
|------|-----------|-------|
| `data/models/chat_session_model.dart` | ~30 | Model |
| `data/models/chat_message_model.dart` | ~30 | Model |
| `data/models/send_message_request.dart` | ~30 | Model |
| `data/models/send_message_response.dart` | ~25 | Model |
| `data/services/chat_service.dart` | ~40 | Service |
| `data/repo/chat_repository.dart` | ~80 | Repository |
| `veiw_model/chat_sessions_state.dart` | ~35 | State |
| `veiw_model/chat_sessions_cubit.dart` | ~35 | Cubit |
| `veiw_model/chat_state.dart` | ~40 | State |
| `veiw_model/chat_cubit.dart` | ~75 | Cubit |

---

## Open Questions

> [!IMPORTANT]
> **`appLanguage` value**: The API expects a string like `"Egyptian Arabic"`. Should this be derived from `context.locale` (e.g., `ar` → `"Egyptian Arabic"`, `en` → `"English"`) or hardcoded? Please confirm the mapping.

> [!IMPORTANT]
> **Chat sessions list screen**: The API supports listing sessions per profile (`GET /api/chats/profile/{profile_id}`). Do you want a **chat sessions list screen** (to pick or resume old conversations) built as part of this work, or only the single active-chat screen?

---

## Verification Plan

### Automated Tests
```shell
flutter analyze lib/features/chat_bot/ lib/core/Services/GetItServices.dart
```

### Manual Verification
1. Open the Chat screen → verify it starts with `ChatInitial` (empty state)
2. Type a message and tap send → verify loading indicator while waiting for API
3. Verify the assistant response appears as a new bubble
4. Close and re-open the chat → verify messages reload from `GET /messages`
5. Test error states: turn off network → verify error snackbar appears
