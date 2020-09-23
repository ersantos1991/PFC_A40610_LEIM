package com.a40610.appannotation.background

import android.annotation.TargetApi
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.widget.Toast
import androidx.annotation.Nullable
import androidx.core.app.NotificationCompat
import com.a40610.appannotation.background.ble.MyBLE
import com.a40610.appannotation.background.notification.BackgroundNotification

class BackgroundService : Service() {

    companion object{
        var isRunning = false
        var backgroundService: BackgroundService? = null
        var myBLE: MyBLE? = null
        var location: Location? = null
        var annotation: String? = null
    }

    private lateinit var backgroundNotification: BackgroundNotification



    override fun onCreate() {
        super.onCreate()
        isRunning = true
        backgroundService = this
        backgroundNotification = BackgroundNotification(this)
        backgroundNotification.sendNotification(
                "App Annotation",
                "This is running in background  - $annotation")
        myBLE = MyBLE(this)
        location = Location(this)
        location?.start()
    }

    @Nullable
    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    @TargetApi(Build.VERSION_CODES.ECLAIR)
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return super.onStartCommand(intent, flags, startId)
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        Toast.makeText(this, "stop service", Toast.LENGTH_SHORT).show()
        isRunning = false
        backgroundService?.stopSelf()
        backgroundService = null
        myBLE?.disconnectAll()
        myBLE = null
        location?.stop()
    }
}


