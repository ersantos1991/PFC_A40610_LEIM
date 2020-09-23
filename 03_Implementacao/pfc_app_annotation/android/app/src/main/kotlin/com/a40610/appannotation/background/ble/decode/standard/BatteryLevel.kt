package com.a40610.appannotation.background.ble.decode.standard

import android.annotation.TargetApi
import android.bluetooth.BluetoothGattCharacteristic
import android.os.Build
import com.a40610.appannotation.background.ble.decode.Decode
import com.a40610.appannotation.background.utils.Constants
import com.a40610.appannotation.background.utils.Utils
import java.util.HashMap

@TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR2)
class BatteryLevel(characteristic: BluetoothGattCharacteristic):Decode{

    private val batteryLevel: MutableMap<String, Any> = HashMap()

    init {
        batteryLevel[Constants.type] = Constants.batteryLevel
        batteryLevel[Constants.level] = characteristic.getIntValue(
                BluetoothGattCharacteristic.FORMAT_UINT8, 0)
        batteryLevel[Constants.timestamp] = Utils.getTimeStampNow()
    }

    override fun getData(): MutableMap<String, Any> {
        return batteryLevel
    }
    
    override fun getName(): String{
        return Constants.br
    }

    override fun toString():String{
        return batteryLevel.toString()
    }

}
