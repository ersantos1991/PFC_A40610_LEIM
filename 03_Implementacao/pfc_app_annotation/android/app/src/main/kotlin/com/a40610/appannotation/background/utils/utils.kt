package com.a40610.appannotation.background.utils

import android.annotation.TargetApi
import android.os.Build
import java.time.Instant
import java.time.format.DateTimeFormatter


object Utils {

    @TargetApi(Build.VERSION_CODES.O)
    fun getTimeStampNow():String {
        return DateTimeFormatter.ISO_INSTANT.format(Instant.now())
    }

    fun byteArrayToString(data: ByteArray):String{
        return if(data.isNotEmpty()) data.joinToString(separator = " "){
            String.format("%02X", it)
        } else ""
    }

}