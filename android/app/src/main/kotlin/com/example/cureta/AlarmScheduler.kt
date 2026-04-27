package com.example.cureta

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import java.util.Calendar

class AlarmScheduler : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val medicineName = intent.getStringExtra("medicine_name") ?: "Medicine"
        val alarmId = intent.getIntExtra("alarm_id", 0)
        val timeMillis = intent.getLongExtra("time_millis", 0L)
        val localId = intent.getStringExtra("local_id") ?: ""
        val dose = intent.getStringExtra("dose_amount") ?: ""
        val imagePath = intent.getStringExtra("image_path") ?: ""

        val serviceIntent = Intent(context, AlarmService::class.java).apply {
            putExtra("medicine_name", medicineName)
            putExtra("alarm_id", alarmId)
            putExtra("local_id", localId)
            putExtra("dose_amount", dose)
            putExtra("image_path", imagePath)
            putExtra("launch_full_screen", true)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(serviceIntent)
        } else {
            context.startService(serviceIntent)
        }

        rescheduleAlarmForNextDay(context, alarmId, localId, medicineName, dose, imagePath, timeMillis)
    }

    companion object {
        private const val PREFS_NAME = "cureta_alarms"

        fun scheduleAlarm(context: Context, id: Int, localId: String, medicineName: String, dose: String, imagePath: String, triggerTimeMillis: Long) {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val intent = Intent(context, AlarmScheduler::class.java).apply {
                putExtra("medicine_name", medicineName)
                putExtra("alarm_id", id)
                putExtra("local_id", localId)
                putExtra("dose_amount", dose)
                putExtra("image_path", imagePath)
                putExtra("time_millis", triggerTimeMillis)
            }
            val pendingIntent = PendingIntent.getBroadcast(
                context, id, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setAlarmClock(
                    AlarmManager.AlarmClockInfo(triggerTimeMillis, pendingIntent),
                    pendingIntent
                )
            } else {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP, triggerTimeMillis, pendingIntent
                )
            }
            saveAlarmToPrefs(context, id, localId, medicineName, dose, imagePath, triggerTimeMillis)
        }

        fun cancelAlarm(context: Context, id: Int) {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val intent = Intent(context, AlarmScheduler::class.java)
            val pendingIntent = PendingIntent.getBroadcast(
                context, id, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            alarmManager.cancel(pendingIntent)
            removeAlarmFromPrefs(context, id)
        }

        fun rescheduleAlarmForNextDay(context: Context, alarmId: Int, localId: String, medicineName: String, dose: String, imagePath: String, originalTimeMillis: Long) {
            val originalCalendar = Calendar.getInstance().apply {
                timeInMillis = originalTimeMillis
            }
            val nextCalendar = Calendar.getInstance().apply {
                set(Calendar.HOUR_OF_DAY, originalCalendar.get(Calendar.HOUR_OF_DAY))
                set(Calendar.MINUTE, originalCalendar.get(Calendar.MINUTE))
                set(Calendar.SECOND, 0)
                set(Calendar.MILLISECOND, 0)
            }
            if (nextCalendar.timeInMillis <= System.currentTimeMillis()) {
                nextCalendar.add(Calendar.DAY_OF_YEAR, 1)
            }
            scheduleAlarm(context, alarmId, localId, medicineName, dose, imagePath, nextCalendar.timeInMillis)
        }

        fun rescheduleAllFromPrefs(context: Context) {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            for ((key, value) in prefs.all) {
                if (!key.startsWith("alarm_")) continue
                try {
                    val parts = (value as String).split("|", limit = 6)
                    if (parts.size < 6) continue
                    val id = parts[0].toInt()
                    val medicineName = parts[1]
                    val timeMillis = parts[2].toLong()
                    val localId = parts[3]
                    val dose = parts[4]
                    val imagePath = parts[5]

                    if (timeMillis < System.currentTimeMillis()) {
                        rescheduleAlarmForNextDay(context, id, localId, medicineName, dose, imagePath, timeMillis)
                    } else {
                        scheduleAlarm(context, id, localId, medicineName, dose, imagePath, timeMillis)
                    }
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
        }

        fun saveAlarmToPrefs(context: Context, id: Int, localId: String, name: String, dose: String, imagePath: String, timeMillis: Long) {
            context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                .edit()
                .putString("alarm_$id", "$id|$name|$timeMillis|$localId|$dose|$imagePath")
                .apply()
        }

        fun removeAlarmFromPrefs(context: Context, id: Int) {
            context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                .edit()
                .remove("alarm_$id")
                .apply()
        }
    }
}
