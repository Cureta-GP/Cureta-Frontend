package com.example.cureta

import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "medicine_alarm"
    private var fullScreenPermissionRequested = false
    private var methodChannel: MethodChannel? = null

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleAlarmIntent(intent)
    }

    override fun onResume() {
        super.onResume()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS) != android.content.pm.PackageManager.PERMISSION_GRANTED) {
                requestPermissions(arrayOf(android.Manifest.permission.POST_NOTIFICATIONS), 101)
            }
        }

        if (!fullScreenPermissionRequested &&
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE
        ) {
            fullScreenPermissionRequested = true
            val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            if (!nm.canUseFullScreenIntent()) {
                startActivity(
                    Intent(
                        Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT,
                        Uri.parse("package:$packageName")
                    )
                )
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
                when (call.method) {

                    "scheduleAlarm" -> {
                        val id   = call.argument<Int>("id")              ?: 0
                        val localId = call.argument<String>("local_id") ?: ""
                        val name = call.argument<String>("medicine_name") ?: ""
                        val dose = call.argument<String>("dose_amount") ?: ""
                        val imagePath = call.argument<String>("image_path") ?: ""
                        val time = call.argument<Long>("time_millis")    ?: 0L
                        val frequency = call.argument<String>("frequency") ?: "daily"
                        AlarmScheduler.scheduleAlarm(this, id, localId, name, dose, imagePath, time, frequency)
                        result.success(null)
                    }

                    "triggerAlarm" -> {
                        val name = call.argument<String>("medicine_name") ?: "تنبيه"

                        val activityIntent = Intent(this, AlarmFullScreenActivity::class.java).apply {
                            putExtra("medicine_name", name)
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                            addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
                        }
                        startActivity(activityIntent)

                        val serviceIntent = Intent(this, AlarmService::class.java).apply {
                            putExtra("medicine_name", name)
                        }
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                            startForegroundService(serviceIntent)
                        else
                            startService(serviceIntent)

                        result.success(null)
                    }

                    "cancelAlarm" -> {
                        val id = call.argument<Int>("id") ?: 0
                        AlarmScheduler.cancelAlarm(this, id)
                        result.success(null)
                    }

                    "stopAlarm" -> {
                        stopService(Intent(this, AlarmService::class.java))
                        result.success(null)
                    }

                    "canScheduleExactAlarms" -> {
                        val canSchedule = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            val am = getSystemService(Context.ALARM_SERVICE) as android.app.AlarmManager
                            am.canScheduleExactAlarms()
                        } else {
                            true
                        }
                        result.success(canSchedule)
                    }

                    "openExactAlarmSettings" -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            startActivity(
                                Intent(
                                    Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM,
                                    Uri.parse("package:$packageName")
                                )
                            )
                        }
                        result.success(null)
                    }

                    "rescheduleAllAlarms" -> {
                        AlarmScheduler.rescheduleAllFromPrefs(this)
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }
            
        handleAlarmIntent(intent)
    }

    private fun handleAlarmIntent(intent: Intent) {
        val action = intent.getStringExtra("alarm_action")
        val localId = intent.getStringExtra("local_id")
        if (action != null && localId != null) {
            methodChannel?.invokeMethod("onAlarmAction", mapOf("action" to action, "local_id" to localId))
            intent.removeExtra("alarm_action")
            intent.removeExtra("local_id")
        }
    }
}
