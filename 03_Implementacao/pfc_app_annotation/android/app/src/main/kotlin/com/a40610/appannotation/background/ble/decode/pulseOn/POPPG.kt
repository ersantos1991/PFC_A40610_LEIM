package com.a40610.appannotation.background.ble.decode.pulseOn


import android.bluetooth.BluetoothGattCharacteristic
import com.a40610.appannotation.background.ble.decode.Decode
import com.a40610.appannotation.background.utils.Constants
import com.a40610.appannotation.background.utils.Utils
import java.util.*

class POPPG(characteristic: BluetoothGattCharacteristic):Decode{

    private val poPPG: MutableMap<String, Any> = HashMap()
    private lateinit var values: BitSet
    private val ppg_array = ArrayList<MutableMap<String, Any>>()
    init {
        val data = characteristic.value
        for (i in 0..4){
            poPPG[Constants.type] = Constants.ppg
            values = BitSet.valueOf(
                Arrays.copyOfRange(data,i*4,i*4 + 4)
            )
            poPPG[Constants.time] = extractValue(values.get(0,16).toLongArray())
            poPPG[Constants.ppg] = extractValue(values.get(16,32).toLongArray())
            poPPG[Constants.timestamp] = Utils.getTimeStampNow()
            ppg_array.add(poPPG)
        }
    }

    override fun getData(): MutableMap<String, Any> {
        return poPPG
    }
    
    override fun getName(): String{
        return Constants.ppg
    }

    override fun toString():String{
        return ppg_array.toString()
    }

    private fun extractValue(value: LongArray): Long {
        return if(value.isNotEmpty()) value[0] else 0
    }
}
