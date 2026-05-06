package com.example.cureta

import android.app.Activity
import android.app.KeyguardManager
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
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
        val doseAmount   = intent.getStringExtra("dose_amount")   ?: ""
        val imagePath    = intent.getStringExtra("image_path")    ?: ""

        findViewById<TextView>(R.id.tv_medicine_name)?.text = medicineName
        findViewById<TextView>(R.id.tv_dose_amount)?.text   = doseAmount

        // Load medicine image downsampled to avoid OOM crash on large camera photos.
        val ivImage = findViewById<ImageView>(R.id.iv_medicine_image)
        val tvIcon  = findViewById<TextView>(R.id.tv_alarm_icon)
        if (imagePath.isNotEmpty()) {
            try {
                val file = File(imagePath)
                if (file.exists()) {
                    val bmp = decodeSampledBitmap(file.absolutePath, 512, 512)
                    if (bmp != null) {
                        ivImage?.setImageBitmap(bmp)
                        ivImage?.visibility = android.view.View.VISIBLE
                        tvIcon?.visibility  = android.view.View.GONE
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

        findViewById<Button>(R.id.btn_taken)?.setOnClickListener  { stopAlarmAndFinish("TAKEN") }
        findViewById<Button>(R.id.btn_missed)?.setOnClickListener { stopAlarmAndFinish("MISSED") }
    }

    private fun stopAlarmAndFinish(action: String) {
        val localId = intent.getStringExtra("local_id") ?: ""
        val remoteId = intent.getStringExtra("remote_id") ?: ""

        stopService(Intent(this, AlarmService::class.java))
        sendBroadcast(
            Intent(this, AlarmActionReceiver::class.java).apply {
                putExtra("alarm_action", action)
                putExtra("local_id", localId)
                putExtra("remote_id", remoteId)
            }
        )

        finishAndRemoveTask()
    }

    // Decodes a file bitmap scaled down so neither side exceeds reqW×reqH.
    // Two-pass approach: first reads only the dimensions, then decodes with
    // the calculated inSampleSize — zero heap cost for the full-res image.
    private fun decodeSampledBitmap(path: String, reqW: Int, reqH: Int): Bitmap? {
        val opts = BitmapFactory.Options().apply { inJustDecodeBounds = true }
        BitmapFactory.decodeFile(path, opts)
        opts.inSampleSize    = calcSampleSize(opts, reqW, reqH)
        opts.inJustDecodeBounds = false
        return BitmapFactory.decodeFile(path, opts)
    }

    private fun calcSampleSize(opts: BitmapFactory.Options, reqW: Int, reqH: Int): Int {
        val h = opts.outHeight
        val w = opts.outWidth
        var size = 1
        if (h > reqH || w > reqW) {
            val halfH = h / 2
            val halfW = w / 2
            while (halfH / size >= reqH && halfW / size >= reqW) size *= 2
        }
        return size
    }

    @Deprecated("Deprecated in Java")
    override fun onBackPressed() {
        // Block back — user must tap Taken or Missed.
    }
}
