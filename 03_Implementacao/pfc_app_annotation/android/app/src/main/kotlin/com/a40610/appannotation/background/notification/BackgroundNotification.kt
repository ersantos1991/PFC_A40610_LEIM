package com.a40610.appannotation.background.notification

import android.annotation.TargetApi
import android.app.*
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.graphics.Color
import android.os.Build
import com.a40610.appannotation.R


class BackgroundNotification() {
    private val channelId = "com.a40610.notification_tests"
    private val description = "Test notification"
    private val id = 1234

    private lateinit var context: Context
    private lateinit var notificationManager: NotificationManager
    private lateinit var intent: Intent
    private lateinit var notificationChannel: NotificationChannel
    private lateinit var  builder: Notification.Builder
    private lateinit var pendingIntent: PendingIntent


    constructor(context: Context) : this() {
        this.context = context
        notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE)
                as NotificationManager
        intent = Intent(context, LauncherActivity::class.java)
        pendingIntent = PendingIntent.getActivity(
                context, 0, intent, 0)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            createNotificationChannel()
        }
    }

    @TargetApi(Build.VERSION_CODES.O)
    private fun createNotificationChannel(){
        notificationChannel = NotificationChannel(
                channelId,description,
                NotificationManager.IMPORTANCE_HIGH )
        notificationChannel.enableLights(true )
        notificationChannel.lightColor = Color.GREEN
        notificationChannel.enableVibration(true )
        notificationManager.createNotificationChannel( notificationChannel )
    }

    @TargetApi(Build.VERSION_CODES.O)
    private fun handlerSendNotification(title:String, text:String, channelId: String ){
        builder = Notification.Builder(context,channelId)
                .setContentTitle(title)
                .setContentText(text)
                .setSmallIcon(R.drawable.app_icon)
                .setLargeIcon(BitmapFactory.decodeResource(context.resources, R.drawable.app_icon))
                .setContentIntent(pendingIntent)

        (context as Service).startForeground(id,builder.build())
    }

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    private fun handlerSendNotification(title:String, text:String){
        builder = Notification.Builder(context)
                .setContentTitle(title)
                .setContentText(text)
                .setSmallIcon(R.drawable.app_icon)
                .setLargeIcon(BitmapFactory.decodeResource(context.resources, R.drawable.app_icon))
                .setContentIntent(pendingIntent)
        (context as Service).startForeground(id,builder.build())
    }

    fun sendNotification(title:String, text:String){
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            handlerSendNotification( title, text, channelId )
        else handlerSendNotification( title, text )
    }
}