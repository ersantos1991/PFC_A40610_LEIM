package com.a40610.appannotation.background

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build

class StartActivityOnBootReceiver: BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (Intent.ACTION_BOOT_COMPLETED == intent!!.action) {
            val forService = Intent(context, BackgroundService::class.java)
            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
                context!!.startForegroundService(forService)
            }else{
                context!!.startService(forService)
            }
        }
    }
}