package com.a40610.appannotation.background.ble.decode.pulseOn

import android.bluetooth.BluetoothGattCharacteristic
import com.a40610.appannotation.background.ble.decode.Decode
import com.a40610.appannotation.background.utils.Constants
import com.a40610.appannotation.background.utils.Utils
import java.util.*

class POHeartRate(characteristic: BluetoothGattCharacteristic):Decode{

    private val poHeartRate: MutableMap<String, Any> = HashMap()
    private val values: BitSet = BitSet.valueOf(characteristic.value)
    init {
        poHeartRate[Constants.type] = Constants.heartRateMeasurement
        poHeartRate[Constants.rollingCounter] = extractValue(values.get(0,32).toLongArray())
        poHeartRate[Constants.hRReliable] = extractValue(values.get(32,33).toLongArray())
        poHeartRate[Constants.hRatTimeout] = extractValue(values.get(33,34).toLongArray())
        poHeartRate[Constants.newIBIData] = extractValue(values.get(34,35).toLongArray())
        poHeartRate[Constants.hr] = extractValue(values.get(35,43).toLongArray())
        poHeartRate[Constants.hRQuality] = extractValue(values.get(43,51).toLongArray())
        poHeartRate[Constants.ibi] = extractValue(values.get(51,67).toLongArray())
        poHeartRate[Constants.ibiQuality] = extractValue(values.get(67,75).toLongArray())
        poHeartRate[Constants.timestamp] = Utils.getTimeStampNow()
    }

    override fun getData(): MutableMap<String, Any> {
        return poHeartRate
    }
    
    override fun getName(): String{
        return Constants.hrp
    }

    override fun toString():String{
        return poHeartRate.toString()
    }

    private fun extractValue(value: LongArray): Long {
        return if(value.isNotEmpty()) value[0] else 0
    }
}
