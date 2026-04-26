package com.example.cureta

import android.app.Activity
import android.app.KeyguardManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import android.widget.Button
import android.widget.TextView

class AlarmFullScreenActivity : Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
            val km = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
            km.requestDismissKeyguard(this, null)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
            )
        }

        setContentView(R.layout.activity_alarm_full_screen)

        val medicineName = intent.getStringExtra("medicine_name") ?: "تنبيه دواء"
        findViewById<TextView>(R.id.tv_medicine_name)?.text = medicineName

        findViewById<Button>(R.id.btn_dismiss)?.setOnClickListener {
            stopService(Intent(this, AlarmService::class.java))
            finish()
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val medicineName = intent.getStringExtra("medicine_name") ?: "تنبيه دواء"
        findViewById<TextView>(R.id.tv_medicine_name)?.text = medicineName
    }

    @Deprecated("Deprecated in Java")
    override fun onBackPressed() {
        // Block back button — user must tap Dismiss
    }
}
