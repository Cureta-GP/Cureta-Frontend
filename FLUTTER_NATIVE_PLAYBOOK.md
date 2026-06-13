# Flutter and Native Developer Playbook

This playbook abstracts a production-grade Flutter codebase into reusable architectural rules and boilerplate. The goal is portability: no business logic, just repeatable patterns.

## Project Structure (Folder-by-Folder)

- android/  
  Native alarm stack: exact alarms, boot persistence, foreground service, full-screen activity, and MethodChannel bridge.
- lib/core/theme/  
  Design tokens and ThemeExtension-based UI system (colors, typography, spacing, radius, durations).
- lib/core/Services/  
  Networking bootstrap (Dio client) and platform bridge services.
- lib/core/error_handling/  
  Unified exception model + UI-safe error presentation.
- lib/features/<feature>/data/  
  Repository + local service patterns; offline-first sync and upsert rules.
- lib/features/<feature>/view_model/  
  Cubit or Bloc layers subscribing to local streams.

---

## 1) Theming and UI System (Design Tokens)

The Concept/Rule:  
ThemeExtensions give you typed, scalable design tokens (colors, typography, spacing, radius, durations). This eliminates hardcoded values and enables fluid responsiveness by lerping token sets across breakpoints.

Best Practices:
- Centralize all tokens in ThemeExtensions and expose them through BuildContext extensions.
- Use a ThemeFactory to compute token sets based on device width and brightness.
- Prefer context.typography/context.colors over Theme.of(context).textTheme and Colors.*.
- Keep Material colorScheme only for framework widgets; use tokens for your UI.
- Avoid hardcoded numbers in padding, radius, and animation duration outside theme.

Reusable Boilerplate:
```dart
// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.background,
    required this.textPrimary,
  });

  final Color primary;
  final Color background;
  final Color textPrimary;

  static const light = AppColors(
    primary: Color(0xFF00A1A9),
    background: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF212121),
  );

  static const dark = AppColors(
    primary: Color(0xFF00A1A9),
    background: Color(0xFF133A3E),
    textPrimary: Color(0xFFF5F5F5),
  );

  static AppColors fromBrightness(Brightness b) =>
      b == Brightness.dark ? dark : light;

  @override
  AppColors copyWith({
    Color? primary,
    Color? background,
    Color? textPrimary,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      background: background ?? this.background,
      textPrimary: textPrimary ?? this.textPrimary,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      background: Color.lerp(background, other.background, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
    );
  }
}

// lib/core/theme/app_typography.dart
@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({required this.title, required this.body});

  final TextStyle title;
  final TextStyle body;

  static const mobile = AppTypography(
    title: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
    body: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
  );

  static const desktop = AppTypography(
    title: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
    body: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
  );

  @override
  AppTypography copyWith({TextStyle? title, TextStyle? body}) {
    return AppTypography(
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  @override
  AppTypography lerp(ThemeExtension<AppTypography>? other, double t) {
    if (other is! AppTypography) return this;
    return AppTypography(
      title: TextStyle.lerp(title, other.title, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
    );
  }
}

// lib/core/theme/theme_extensions.dart
extension ThemeContextExtensions on BuildContext {
  AppColors get colors =>
      Theme.of(this).extension<AppColors>() ?? AppColors.light;
  AppTypography get typography =>
      Theme.of(this).extension<AppTypography>() ?? AppTypography.mobile;
}

// lib/core/theme/app_theme_factory.dart
class AppThemeFactory {
  const AppThemeFactory._();

  static ThemeData create({
    required Brightness brightness,
    required double screenWidth,
  }) {
    final colors = AppColors.fromBrightness(brightness);
    final typography = screenWidth < 900
        ? AppTypography.mobile
        : AppTypography.desktop;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(seedColor: colors.primary),
      scaffoldBackgroundColor: colors.background,
      extensions: [colors, typography],
    );
  }
}
```

---

## 2) Native Android Integrations (Exact Alarms and Full-Screen Intents)

The Concept/Rule:  
Exact alarms are platform-managed, not app-managed. To be reliable, alarms must be scheduled with AlarmManager, persisted locally, rescheduled on boot/time changes, and executed through a foreground service that can wake the device and show a full-screen UI.

Best Practices:
- Use setAlarmClock or setExactAndAllowWhileIdle for exact alarms.
- Persist alarms in SharedPreferences to reschedule on boot/time/timezone changes.
- Add a cooldown on time-change reschedules to avoid reschedule storms.
- Use a foreground service to keep audio/vibration alive until dismissed.
- Use a full-screen activity with showWhenLocked/turnScreenOn for visibility.
- Request exact alarm and full-screen intent permissions on Android 12+ / 14+.
- Bridge alarm actions back to Flutter via MethodChannel; persist actions if the app is dead.

Reusable Boilerplate:
```kotlin
// AndroidManifest.xml (snippet)
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>

<receiver android:name=".BootReceiver" android:exported="true">
  <intent-filter>
    <action android:name="android.intent.action.BOOT_COMPLETED"/>
    <action android:name="android.intent.action.TIME_SET"/>
    <action android:name="android.intent.action.TIMEZONE_CHANGED"/>
  </intent-filter>
</receiver>

<receiver android:name=".AlarmScheduler" android:exported="false"/>
<receiver android:name=".AlarmActionReceiver" android:exported="false"/>
<service android:name=".AlarmService" android:exported="false" />
<activity android:name=".AlarmFullScreenActivity"
    android:launchMode="singleTop"
    android:showOnLockScreen="true"
    android:turnScreenOn="true"
    android:excludeFromRecents="true" />

// MainActivity.kt (MethodChannel)
class MainActivity : FlutterActivity() {
  private val CHANNEL = "alarm_channel"
  private var channel: MethodChannel? = null

  override fun configureFlutterEngine(engine: FlutterEngine) {
    super.configureFlutterEngine(engine)
    channel = MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL)
    channel?.setMethodCallHandler { call, result ->
      when (call.method) {
        "scheduleAlarm" -> { /* read args and schedule */ result.success(null) }
        "cancelAlarm" -> { /* cancel */ result.success(null) }
        "stopAlarm" -> { stopService(Intent(this, AlarmService::class.java)); result.success(null) }
        "consumePendingActions" -> { result.success(readPendingActions()) }
        else -> result.notImplemented()
      }
    }
  }
}

// BootReceiver.kt
class BootReceiver : BroadcastReceiver() {
  override fun onReceive(context: Context, intent: Intent) {
    val isBoot = intent.action == Intent.ACTION_BOOT_COMPLETED
    val isTime = intent.action == Intent.ACTION_TIME_CHANGED ||
        intent.action == Intent.ACTION_TIMEZONE_CHANGED
    if (!isBoot && !isTime) return
    AlarmScheduler.rescheduleAllFromPrefs(context)
  }
}

// AlarmScheduler.kt
class AlarmScheduler : BroadcastReceiver() {
  override fun onReceive(context: Context, intent: Intent) {
    context.startForegroundService(Intent(context, AlarmService::class.java).apply {
      putExtras(intent.extras ?: Bundle())
    })
    // reschedule next occurrence here
  }

  companion object {
    fun scheduleAlarm(context: Context, id: Int, triggerAt: Long) {
      val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
      val pi = PendingIntent.getBroadcast(
        context, id, Intent(context, AlarmScheduler::class.java),
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
      )
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        am.setAlarmClock(AlarmManager.AlarmClockInfo(triggerAt, pi), pi)
      } else {
        am.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAt, pi)
      }
      saveToPrefs(context, id, triggerAt)
    }
  }
}

// AlarmService.kt
class AlarmService : Service() {
  override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
    startForeground(9001, buildNotification())
    playLoopingAlarm()
    launchFullScreenActivity(intent)
    return START_NOT_STICKY
  }
}

// AlarmFullScreenActivity.kt
class AlarmFullScreenActivity : Activity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setShowWhenLocked(true)
    setTurnScreenOn(true)
    setContentView(R.layout.activity_alarm_full_screen)
    // buttons -> broadcast action to AlarmActionReceiver
  }
}
```

```dart
// lib/core/services/alarm_channel.dart
import 'package:flutter/services.dart';

class AlarmChannel {
  static const _channel = MethodChannel('alarm_channel');

  Future<void> scheduleAlarm(Map<String, dynamic> payload) =>
      _channel.invokeMethod('scheduleAlarm', payload);

  Future<void> cancelAlarm(int id) =>
      _channel.invokeMethod('cancelAlarm', {'id': id});

  Future<void> stopAlarm() => _channel.invokeMethod('stopAlarm');

  Future<List<dynamic>> consumePendingActions() async =>
      await _channel.invokeMethod<List<dynamic>>('consumePendingActions') ?? [];
}
```

---

## 3) Reactive Offline-First Architecture (Double-Write and Upsert)

The Concept/Rule:  
The local database is the source of truth. All writes go to local first, then sync to remote. Remote responses upsert into local only if they do not override unsynced local changes.

Best Practices:
- Use a broadcast StreamController in the local service to push state to UI.
- Store syncStatus (pending/synced/failed) on every local row.
- Upsert remote data by checking remoteId + updatedAt to avoid overwriting local edits.
- Expose a syncPending method to retry failed or pending writes.
- Keep repository logic deterministic: local write, then remote attempt, then update status.

Reusable Boilerplate:
```dart
// LocalDbService.dart
class LocalDbService<T> {
  final _controller = StreamController<List<T>>.broadcast();
  Database? _db;

  Stream<List<T>> watchAll() => _controller.stream;

  Future<void> init() async {
    _db = await openDatabase('app.db', version: 1, onCreate: _create);
    await _emitAll();
  }

  Future<void> insert(Map<String, dynamic> row) async {
    await _db!.insert('items', row, conflictAlgorithm: ConflictAlgorithm.replace);
    await _emitAll();
  }

  Future<void> upsertFromRemote(
    Map<String, dynamic> remote, {
    required bool Function(Map<String, dynamic> local) shouldKeepLocal,
    required bool Function(Map<String, dynamic> local, Map<String, dynamic> remote) isRemoteOlder,
  }) async {
    final local = await _findByRemoteId(remote['remote_id']);
    if (local != null) {
      if (shouldKeepLocal(local) || isRemoteOlder(local, remote)) return;
      await _db!.update('items', remote, where: 'id = ?', whereArgs: [local['id']]);
    } else {
      await _db!.insert('items', remote, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await _emitAll();
  }

  Future<void> _emitAll() async {
    final rows = await _db!.query('items');
    _controller.add(rows.map(_fromMap).toList());
  }

  T _fromMap(Map<String, dynamic> row) => throw UnimplementedError();

  Future<Map<String, dynamic>?> _findByRemoteId(String id) async => null;
}

// Repository.dart
class Repository {
  final LocalDbService<Model> local;
  final RemoteService remote;

  Repository(this.local, this.remote);

  Future<Model> add(Model model) async {
    await local.insert(model.toLocalMap(syncStatus: 'pending'));
    try {
      final dto = await remote.create(model);
      await local.insert(model.copyWith(remoteId: dto.id, syncStatus: 'synced').toLocalMap());
      return model.copyWith(remoteId: dto.id, syncStatus: 'synced');
    } catch (_) {
      return model; // Keep pending
    }
  }

  Stream<List<Model>> watchAll() => local.watchAll();

  Future<void> syncPending() async {
    final pending = await local.getPending();
    for (final item in pending) {
      try {
        await remote.upsert(item);
        await local.markSynced(item.id);
      } catch (_) {
        await local.markFailed(item.id);
      }
    }
  }
}

// Cubit example: subscribe to local stream and emit UI state
class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit(this._repo) : super(const ItemsState.loading());

  final Repository _repo;
  StreamSubscription<List<Model>>? _sub;

  void watch() {
    _sub?.cancel();
    _sub = _repo.watchAll().listen(
      (items) => emit(ItemsState.data(items)),
      onError: (_) => emit(const ItemsState.error()),
    );
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
```

---

## 4) Error Handling and Networking

The Concept/Rule:  
Normalize all exceptions into a single AppException model and centralize UI display so the app never crashes and all errors present consistently.

Best Practices:
- Map SocketException, timeouts, and DioException explicitly.
- Convert backend codes and HTTP status into user-friendly messages.
- Keep UI handling in one place (dialog/snackbar/full-screen).
- Centralize Dio configuration (timeouts, headers, interceptors).
- Never expose raw exceptions to UI layers.

Reusable Boilerplate:
```dart
// app_exceptions.dart
enum ErrorType { dialog, snackbar, fullScreen, inline }

class AppException implements Exception {
  final String message;
  final ErrorType type;
  final Map<String, String>? fieldErrors;

  AppException(this.message, this.type, {this.fieldErrors});

  factory AppException.network() =>
      AppException('No internet connection', ErrorType.fullScreen);

  factory AppException.timeout() =>
      AppException('Request timeout', ErrorType.fullScreen);

  factory AppException.validation({String? msg, Map<String, String>? fields}) =>
      AppException(msg ?? 'Invalid input', ErrorType.inline, fieldErrors: fields);
}

// error_handler.dart
class ErrorHandler {
  static AppException handle(dynamic error) {
    if (error is AppException) return error;
    if (error is SocketException) return AppException.network();
    if (error is DioException) return _handleDio(error);
    return AppException('Server error', ErrorType.fullScreen);
  }

  static AppException _handleDio(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return AppException.timeout();
    }
    final status = e.response?.statusCode;
    if (status == 401) return AppException('Unauthorized', ErrorType.dialog);
    if (status == 422) return AppException.validation(msg: 'Validation error');
    return AppException('Server error', ErrorType.fullScreen);
  }

  static void show(BuildContext context, AppException error) {
    switch (error.type) {
      case ErrorType.snackbar:
      case ErrorType.fullScreen:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
        break;
      case ErrorType.dialog:
        showDialog(
          context: context,
          builder: (_) => AlertDialog(content: Text(error.message)),
        );
        break;
      case ErrorType.inline:
        // Handled at form-field level
        break;
    }
  }
}

// dio_client.dart
class DioClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.example.com/',
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Content-Type': 'application/json'},
    ),
  )..interceptors.add(LogInterceptor(responseBody: true));
}
```
