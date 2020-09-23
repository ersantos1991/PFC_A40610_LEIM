package com.a40610.appannotation.background.ble.decode.pulseOn


import android.bluetooth.BluetoothGattCharacteristic
import com.a40610.appannotation.background.ble.decode.Decode
import com.a40610.appannotation.background.utils.Constants
import com.a40610.appannotation.background.utils.Utils
import java.util.*

class POActivity(characteristic: BluetoothGattCharacteristic):Decode{

    private val poActivity: MutableMap<String, Any> = HashMap()
    private val values: BitSet = BitSet.valueOf(characteristic.value)
    private var count = 0
    init {
        poActivity[Constants.type] = Constants.activity
        poActivity[Constants.sleep_data_present] = extractValue(values.get(count,++count).toLongArray())
        poActivity[Constants.speed_data_present] = extractValue(values.get(count,++count).toLongArray())
        poActivity[Constants.distance_data_present] = extractValue(values.get(count,++count).toLongArray())
        poActivity[Constants.swim_data_present] = extractValue(values.get(count,++count).toLongArray())
        poActivity[Constants.workout_status_changed] = extractValue(values.get(count,++count).toLongArray())
        poActivity[Constants.worn_status_changed] = extractValue(values.get(count,++count).toLongArray())
        poActivity[Constants.activity_data_changed] = extractValue(values.get(count,++count).toLongArray())
        poActivity[Constants.rollingCounter] = extractValue(values.get(count,32+count).toLongArray())
        count+= 32
        poActivity[Constants.k_calories] = extractValue(values.get(count,24+count).toLongArray())
        count+= 24
        poActivity[Constants.speed] = extractValue(values.get(count,16+count).toLongArray())
        count+= 16
        poActivity[Constants.steps] = extractValue(values.get(count,24+count).toLongArray())
        count+= 24
        poActivity[Constants.distance] = extractValue(values.get(count,24+count).toLongArray())
        count+= 24
        poActivity[Constants.activity_type] = extractValue(values.get(count,4+count).toLongArray())
        count+= 4
        poActivity[Constants.workout_state] = extractValue(values.get(count,++count).toLongArray())
        poActivity[Constants.worn_state] = extractValue(values.get(count,++count).toLongArray())
        poActivity[Constants.timestamp] = Utils.getTimeStampNow()
    }

    override fun getData(): MutableMap<String, Any> {
        return poActivity
    }
    
    override fun getName(): String{
        return Constants.activity
    }

    override fun toString():String{
        return poActivity.toString()
    }

    private fun extractValue(value: LongArray): Long {
        return if(value.isNotEmpty()) value[0] else 0
    }
}
