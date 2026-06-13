package com.example.cureta

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import org.json.JSONArray
import org.json.JSONObject

class AlarmActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.getStringExtra("alarm_action") ?: return
        val localId = intent.getStringExtra("local_id") ?: return
        val remoteId = intent.getStringExtra("remote_id") ?: ""
        val scheduledAtMillis = intent.getLongExtra("scheduled_at_millis", 0L)
        if (action.isBlank() || localId.isBlank()) return
        Log.d("AlarmActionReceiver", "Received action=$action local_id=$localId remote_id=$remoteId scheduled_at_millis=$scheduledAtMillis")

        val prefs = context.getSharedPreferences("cureta_alarm_events", Context.MODE_PRIVATE)
        val currentRaw = prefs.getString("pending_actions", "[]") ?: "[]"
        val arr = try {
            JSONArray(currentRaw)
        } catch (_: Exception) {
            JSONArray()
        }
        arr.put(
            JSONObject().apply {
                put("action", action)
                put("local_id", localId)
                put("remote_id", remoteId)
                put("scheduled_at_millis", scheduledAtMillis)
                put("timestamp", System.currentTimeMillis())
            }
        )
        // commit() is used to guarantee cross-process visibility immediately.
        val saved = prefs.edit().putString("pending_actions", arr.toString()).commit()
        Log.d("AlarmActionReceiver", "Pending actions persisted=$saved")
    }
}
