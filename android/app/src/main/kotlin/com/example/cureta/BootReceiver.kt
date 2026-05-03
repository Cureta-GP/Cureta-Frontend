package com.example.cureta

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class BootReceiver : BroadcastReceiver() {

    companion object {
        // Minimum gap (ms) between two clock-change reschedules to
        // prevent a storm of reschedules when the user rapidly adjusts time.
        private const val RESCHEDULE_COOLDOWN_MS = 2 * 60 * 1000L
        private const val PREFS_KEY = "last_reschedule_ms"
        private const val PREFS_NAME = "cureta_alarms"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val isBootEvent = intent.action == Intent.ACTION_BOOT_COMPLETED ||
            intent.action == "android.intent.action.LOCKED_BOOT_COMPLETED"
        val isClockEvent = intent.action == Intent.ACTION_TIME_CHANGED ||
            intent.action == Intent.ACTION_TIMEZONE_CHANGED

        if (!isBootEvent && !isClockEvent) return

        // For clock-change events apply a cooldown so rapid adjustments
        // don't stack reschedules and cause phantom alarm triggers.
        if (isClockEvent) {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val lastMs = prefs.getLong(PREFS_KEY, 0L)
            val now = System.currentTimeMillis()
            if (now - lastMs < RESCHEDULE_COOLDOWN_MS) return
            prefs.edit().putLong(PREFS_KEY, now).apply()
        }

        AlarmScheduler.rescheduleAllFromPrefs(context)
    }
}
