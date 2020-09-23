package com.a40610.appannotation.background.ble.decode.standard

import android.annotation.TargetApi
import android.bluetooth.BluetoothGattCharacteristic
import android.os.Build
import com.a40610.appannotation.background.ble.decode.Decode
import com.a40610.appannotation.background.utils.Constants
import com.a40610.appannotation.background.utils.Utils
import java.util.HashMap

@TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR2)
class HeartRate(characteristic: BluetoothGattCharacteristic):Decode{

    private val flag = characteristic.properties
    private val formatBit = when(flag and 0x01){
        0x01 -> BluetoothGattCharacteristic.FORMAT_UINT16
        else -> BluetoothGattCharacteristic.FORMAT_UINT8
    }
    private val sensorContact:Int = (flag and 0x06)
    private val energyExpendedStatus:Boolean = (flag and 0x08) == 0x08
    private val rrIntervalStatus:Boolean = (flag and 0x16) == 0x16
    private val heartRate: MutableMap<String, Any> = HashMap()

    init {
        heartRate[Constants.type] = Constants.heartRateMeasurement
        heartRate[Constants.sensorContact] = sensorContact
        heartRate[Constants.heartRateValue] = characteristic.getIntValue(formatBit, 1)
        heartRate[Constants.energyExpended] =
                if(energyExpendedStatus) characteristic.getIntValue(formatBit, 3)
                else Constants.empty
        heartRate[Constants.rrInterval] =
                if(rrIntervalStatus) characteristic.getIntValue(formatBit, 4)
                else Constants.empty
        heartRate[Constants.timestamp] = Utils.getTimeStampNow()
    }

    override fun getData(): MutableMap<String, Any> {
        return heartRate
    }
    
    override fun getName(): String{
        return Constants.hrm
    }

    override fun toString():String{
        return heartRate.toString()
    }

}
