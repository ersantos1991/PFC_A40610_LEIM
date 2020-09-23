package com.a40610.appannotation.background

import android.bluetooth.BluetoothDevice
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import com.a40610.appannotation.background.ble.decode.Characteristics
import com.a40610.appannotation.background.ble.decode.Services
import com.a40610.appannotation.background.db.Firebase
import com.a40610.appannotation.background.utils.Constants
import com.a40610.appannotation.background.utils.Utils

import java.util.*
import kotlin.collections.ArrayList
import kotlin.collections.HashMap

class Annotation() {

    private val configs: HashMap<String,HashMap<String,ArrayList<Any>>> = HashMap()

    constructor(uuid: String) : this() {
        Firebase.instance.setUUID(uuid)
        val empty = java.util.HashMap<String, ArrayList<Any>>()
        empty[Constants.hrm] = ArrayList()
        empty[Constants.br] = ArrayList()
        empty[Constants.hrp] = ArrayList()
        empty[Constants.activity] = ArrayList()
        empty[Constants.ppg] = ArrayList()
        Firebase.instance.createEmptyData(empty)
    }

    @RequiresApi(Build.VERSION_CODES.N)
    fun start(){
        if(BackgroundService.isRunning){
            val devices:HashMap<String,BluetoothDevice> = BackgroundService.myBLE!!.getDevices()
            for((mac,device) in devices){
                configs.forEach{ (key, config) ->
                    if(device.name.contains(key)){
                        handlerConfig(config,mac)
                    }
                }
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.N)
    private fun handlerConfig(config: HashMap<String,ArrayList<Any>>,mac:String){
        config.forEach { (name, service) ->
                Thread.sleep(200)
                when(service[0]){
                    Constants.notify -> BackgroundService.myBLE!!.notify(
                            mac,
                            service[1] as UUID,
                            service[2] as UUID)
                    Constants.read -> BackgroundService.myBLE!!.read(
                            mac,
                            service[1] as UUID,
                            service[2] as UUID)
                    Constants.write -> BackgroundService.myBLE!!.write(
                            mac,
                            service[1] as UUID,
                            service[2] as UUID,
                            "get_device_info\n")
                }

        }
    }

    init {
        configs[Constants.pulseOnName] = hashMapOf(
                Constants.hrm to arrayListOf(
                        Constants.notify,
                        Services.HEART_RATE,
                        Characteristics.RATE_MEASUREMENT),
                Constants.br to arrayListOf(
                        Constants.notify,
                        Services.BATTERY_RATE,
                        Characteristics.RATE_LEVEL),
                Constants.br to arrayListOf(
                        Constants.notify,
                        Services.BATTERY_RATE,
                        Characteristics.RATE_LEVEL),
                Constants.hrp to arrayListOf(
                        Constants.notify,
                        Services.PULSE_ON,
                        Characteristics.PO_HEART_RATE),
                Constants.activity to arrayListOf(
                        Constants.notify,
                        Services.PULSE_ON,
                        Characteristics.PO_ACTIVITY),
                Constants.ppg to arrayListOf(
                        Constants.notify,
                        Services.PULSE_ON,
                        Characteristics.PO_PPG)
        )
        configs[Constants.maximName] = hashMapOf(
                "0" to arrayListOf(
                        Constants.read,
                        Services.MAXIM,
                        Characteristics.MAXIM_NOTIFY),
                "1" to arrayListOf(
                        Constants.write,
                        Services.MAXIM,
                        Characteristics.MAXIM_WRITE)

        )

    }

}