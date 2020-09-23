package com.a40610.appannotation.background.ble.decode

import java.util.*

object Characteristics {
    val RATE_MEASUREMENT: UUID = UUID.fromString("00002a37-0000-1000-8000-00805f9b34fb")
    val RATE_LEVEL: UUID = UUID.fromString("00002a19-0000-1000-8000-00805f9b34fb")
    val PO_ACTIVITY: UUID = UUID.fromString("feca57d9-7aee-fbbd-a144-3c695a4baaeb")
    val PO_HEART_RATE: UUID = UUID.fromString("feca57da-7aee-fbbd-a144-3c695a4baaeb")
    val PO_PPG: UUID = UUID.fromString("feca57db-7aee-fbbd-a144-3c695a4baaeb")
    val MAXIM_WRITE : UUID = UUID.fromString("00001027-1212-efde-1523-785feabcd123")
    val MAXIM_NOTIFY : UUID = UUID.fromString("00001011-1212-efde-1523-785feabcd123")
}