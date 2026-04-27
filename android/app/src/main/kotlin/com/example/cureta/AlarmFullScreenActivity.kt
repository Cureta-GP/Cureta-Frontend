package com.example.cureta

import android.app.Activity
import android.app.KeyguardManager
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import java.io.File

class AlarmFullScreenActivity : Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Wake + show on lock screen
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
                WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
            )
        }

        // Keep screen on so the activity doesn't get reclaimed
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)

        setContentView(R.layout.activity_alarm_full_screen)
        bindIntentData(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        bindIntentData(intent)
    }

    private fun bindIntentData(intent: Intent) {
        val medicineName = intent.getStringExtra("medicine_name") ?: "تنبيه دواء"
        val doseAmount = intent.getStringExtra("dose_amount") ?: ""
        val imagePath = intent.getStringExtra("image_path") ?: ""

        findViewById<TextView>(R.id.tv_medicine_name)?.text = medicineName
        findViewById<TextView>(R.id.tv_dose_amount)?.text = doseAmount

        // Show medicine image if available
        val ivImage = findViewById<ImageView>(R.id.iv_medicine_image)
        val tvIcon = findViewById<TextView>(R.id.tv_alarm_icon)
        if (imagePath.isNotEmpty()) {
            try {
                val file = File(imagePath)
                if (file.exists()) {
                    val bitmap = BitmapFactory.decodeFile(file.absolutePath)
                    if (bitmap != null) {
                        ivImage?.setImageBitmap(bitmap)
                        ivImage?.visibility = android.view.View.VISIBLE
                        tvIcon?.visibility = android.view.View.GONE
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

        // Taken → stop alarm, close
        findViewById<Button>(R.id.btn_taken)?.setOnClickListener {
            stopAlarmAndFinish()
        }

        // Missed → stop alarm, close
        findViewById<Button>(R.id.btn_missed)?.setOnClickListener {
            stopAlarmAndFinish()
        }
    }

    private fun stopAlarmAndFinish() {
        stopService(Intent(this, AlarmService::class.java))
        finishAndRemoveTask()
    }

    @Deprecated("Deprecated in Java")
    override fun onBackPressed() {
        // Block back button — user must tap Taken or Missed
    }
}
