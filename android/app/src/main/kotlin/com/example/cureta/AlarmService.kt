package com.example.cureta

import android.app.*
import android.content.Context
import android.content.Intent
import android.media.*
import android.os.*
import android.speech.tts.TextToSpeech
import java.util.Locale

class AlarmService : Service(), TextToSpeech.OnInitListener {

    private var mediaPlayer: MediaPlayer? = null
    private var vibrator: Vibrator? = null
    private var tts: TextToSpeech? = null
    private var pendingMedicineName: String? = null
    private var originalAlarmVolume: Int = -1  // لحفظ الـ volume الأصلي

    companion object {
        const val CHANNEL_ID = "cureta_alarm_channel"
        const val NOTIFICATION_ID = 9001
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        tts = TextToSpeech(this, this)
    }

    override fun onInit(status: Int) {
        if (status == TextToSpeech.SUCCESS) {
            val arResult = tts?.setLanguage(Locale("ar"))
            if (arResult == TextToSpeech.LANG_MISSING_DATA || arResult == TextToSpeech.LANG_NOT_SUPPORTED) {
                tts?.setLanguage(Locale.getDefault())
            }
            pendingMedicineName?.let { speakMedicineName(it) }
            pendingMedicineName = null
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == "STOP") {
            stopSelf()
            return START_NOT_STICKY
        }

        mediaPlayer?.apply { if (isPlaying) stop(); release() }
        mediaPlayer = null
        vibrator?.cancel()
        vibrator = null

        val medicineName = intent?.getStringExtra("medicine_name") ?: "Medicine"
        val localId      = intent?.getStringExtra("local_id")      ?: ""
        val remoteId     = intent?.getStringExtra("remote_id")     ?: ""
        val dose         = intent?.getStringExtra("dose_amount")    ?: ""
        val imagePath    = intent?.getStringExtra("image_path")     ?: ""
        val launchFullScreen = intent?.getBooleanExtra("launch_full_screen", false) ?: false

        // ✅ ارفع الـ alarm volume للـ maximum قبل ما يبدأ الصوت
        forceMaxAlarmVolume()

        startForeground(NOTIFICATION_ID, buildNotification(medicineName, localId, remoteId, dose, imagePath))
        playAlarmSound()
        startVibration()

        Handler(Looper.getMainLooper()).postDelayed({
            pendingMedicineName = medicineName
            if (tts != null) {
                speakMedicineName(medicineName)
                pendingMedicineName = null
            }
        }, 2500)

        if (launchFullScreen) {
            launchFullScreenActivity(medicineName, localId, remoteId, dose, imagePath)
        }

        return START_NOT_STICKY
    }

    // ✅ ارفع الـ volume للـ max وخزّن الأصلي عشان نرجعه لما الإنذار يتوقف
    private fun forceMaxAlarmVolume() {
        try {
            val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
            originalAlarmVolume = audioManager.getStreamVolume(AudioManager.STREAM_ALARM)
            val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_ALARM)
            audioManager.setStreamVolume(AudioManager.STREAM_ALARM, maxVolume, 0)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    // ✅ رجّع الـ volume للقيمة الأصلية لما الإنذار يتوقف
    private fun restoreAlarmVolume() {
        try {
            if (originalAlarmVolume >= 0) {
                val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
                audioManager.setStreamVolume(AudioManager.STREAM_ALARM, originalAlarmVolume, 0)
                originalAlarmVolume = -1
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun speakMedicineName(name: String) {
        try {
            val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
            val currentVolume = audioManager.getStreamVolume(AudioManager.STREAM_ALARM)
            // خفّض الصوت للـ 40% أثناء الكلام
            audioManager.setStreamVolume(
                AudioManager.STREAM_ALARM,
                (currentVolume * 0.4).toInt().coerceAtLeast(1),
                0
            )

            tts?.speak("حان وقت دواء $name", TextToSpeech.QUEUE_FLUSH, null, "medicine_tts")

            // ✅ رجّع الصوت بعد ما الـ TTS يخلص مش بعد وقت ثابت
            tts?.setOnUtteranceProgressListener(object : android.speech.tts.UtteranceProgressListener() {
                override fun onStart(utteranceId: String?) {}
                override fun onDone(utteranceId: String?) {
                    Handler(Looper.getMainLooper()).post {
                        val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_ALARM)
                        audioManager.setStreamVolume(AudioManager.STREAM_ALARM, maxVolume, 0)
                    }
                }
                override fun onError(utteranceId: String?) {
                    Handler(Looper.getMainLooper()).post {
                        val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_ALARM)
                        audioManager.setStreamVolume(AudioManager.STREAM_ALARM, maxVolume, 0)
                    }
                }
            })
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun launchFullScreenActivity(medicineName: String, localId: String, remoteId: String, dose: String, imagePath: String) {
        val intent = Intent(this, AlarmFullScreenActivity::class.java).apply {
            putExtra("medicine_name", medicineName)
            putExtra("local_id", localId)
            putExtra("remote_id", remoteId)
            putExtra("dose_amount", dose)
            putExtra("image_path", imagePath)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
            addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
        }
        startActivity(intent)
    }

    override fun onDestroy() {
        mediaPlayer?.apply { if (isPlaying) stop(); release() }
        mediaPlayer = null
        vibrator?.cancel()
        vibrator = null
        tts?.stop()
        tts?.shutdown()
        tts = null
        // ✅ رجّع الـ volume للأصلي لما الإنذار يتوقف
        restoreAlarmVolume()
        super.onDestroy()
    }

    private fun buildNotification(medicineName: String, localId: String, remoteId: String, dose: String, imagePath: String): Notification {
        val stopIntent = Intent(this, AlarmService::class.java).apply { action = "STOP" }
        val stopPending = PendingIntent.getService(
            this, 1, stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val fsIntent = Intent(this, AlarmFullScreenActivity::class.java).apply {
            putExtra("medicine_name", medicineName)
            putExtra("local_id", localId)
            putExtra("remote_id", remoteId)
            putExtra("dose_amount", dose)
            putExtra("image_path", imagePath)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
        }
        val fsPending = PendingIntent.getActivity(
            this, 2, fsIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            Notification.Builder(this, CHANNEL_ID)
        else
            @Suppress("DEPRECATION") Notification.Builder(this)

        return builder
            .setContentTitle("⏰ وقت الدواء")
            .setContentText(medicineName)
            .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
            .setCategory(Notification.CATEGORY_ALARM)
            .setVisibility(Notification.VISIBILITY_PUBLIC)
            .setFullScreenIntent(fsPending, true)
            .setOngoing(true)
            .setAutoCancel(false)
            .setContentIntent(fsPending)
            .addAction(android.R.drawable.ic_menu_close_clear_cancel, "إيقاف", stopPending)
            .build()
    }

    private fun playAlarmSound() {
        try {
            val uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
                ?: RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE)
            mediaPlayer = MediaPlayer().apply {
                setDataSource(applicationContext, uri)
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .setLegacyStreamType(AudioManager.STREAM_ALARM)
                        .build()
                )
                isLooping = true
                setVolume(1.0f, 1.0f)
                prepare()
                start()
            }
        } catch (e: Exception) { e.printStackTrace() }
    }

    private fun startVibration() {
        vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S)
            (getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager).defaultVibrator
        else
            @Suppress("DEPRECATION") getSystemService(Context.VIBRATOR_SERVICE) as Vibrator

        val pattern = longArrayOf(0, 800, 400)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            vibrator?.vibrate(VibrationEffect.createWaveform(pattern, 0))
        else
            @Suppress("DEPRECATION") vibrator?.vibrate(pattern, 0)
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID, "تنبيهات الدواء", NotificationManager.IMPORTANCE_HIGH
            ).apply {
                setBypassDnd(true)
                enableVibration(false)
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            }
            (getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager)
                .createNotificationChannel(channel)
        }
    }
}
