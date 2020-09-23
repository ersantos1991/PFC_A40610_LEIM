package com.a40610.appannotation.background.ble

import android.annotation.TargetApi
import android.bluetooth.*
import android.bluetooth.BluetoothProfile.STATE_CONNECTED
import android.bluetooth.BluetoothProfile.STATE_DISCONNECTED
import android.os.Build
import android.util.Log
import com.a40610.appannotation.background.ble.decode.pulseOn.POHeartRate
import com.a40610.appannotation.background.ble.decode.standard.BatteryLevel
import com.a40610.appannotation.background.ble.decode.Characteristics
import com.a40610.appannotation.background.ble.decode.pulseOn.POActivity
import com.a40610.appannotation.background.ble.decode.pulseOn.POPPG
import com.a40610.appannotation.background.ble.decode.standard.HeartRate
import com.a40610.appannotation.background.db.Firebase
import com.a40610.appannotation.background.utils.Utils

@TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR2)
class BLECallback: BluetoothGattCallback() {

    private var state = STATE_DISCONNECTED
    private var services: List<BluetoothGattService>? = null;

    override fun onConnectionStateChange(gatt: BluetoothGatt?, status: Int, newState: Int) {
        super.onConnectionStateChange(gatt, status, newState)
        when(newState){
            STATE_CONNECTED -> {
                state = STATE_CONNECTED
                gatt?.discoverServices()
            }
            STATE_DISCONNECTED -> {
                state = STATE_DISCONNECTED
            }
        }
    }

    override fun onServicesDiscovered(gatt: BluetoothGatt?, status: Int) {
        super.onServicesDiscovered(gatt, status)
        when (status) {
            BluetoothGatt.GATT_SUCCESS -> setServices(gatt?.services!!)
            else -> Log.w("SERVICES", "onServicesDiscovered received: $status")
        }
    }

    override fun onCharacteristicRead(
        gatt: BluetoothGatt?,
        characteristic: BluetoothGattCharacteristic?,
        status: Int)
    {
        super.onCharacteristicRead(gatt, characteristic, status)
        handleDecode(characteristic!!)
        Log.e("data",Utils.byteArrayToString(characteristic.value))
    }

    override fun onCharacteristicWrite(
        gatt: BluetoothGatt?,
        characteristic: BluetoothGattCharacteristic?,
        status: Int) {
        super.onCharacteristicWrite(gatt, characteristic, status)


    }


    override fun onCharacteristicChanged(
        gatt: BluetoothGatt?,
        characteristic: BluetoothGattCharacteristic?)
    {
        super.onCharacteristicChanged(gatt, characteristic)
        handleDecode(characteristic!!)
        Log.e("data",Utils.byteArrayToString(characteristic.value))
    }

    private fun setServices(services:List<BluetoothGattService> ){
        this.services = services
    }

    fun getServices(): List<BluetoothGattService>? {
        return services
    }

    fun getService(uuidService:String):BluetoothGattService?{
        var uuid: String?
        services?.forEach { service ->
            uuid = service.uuid.toString()
            if(uuid == uuidService){
                return service
            }
        }
        return null
    }

    fun getCharacteristic(
            service:BluetoothGattService,
            uuidCharacteristic:String
        ): BluetoothGattCharacteristic? {
            val gattCharacteristics : List<BluetoothGattCharacteristic> = service.characteristics
            var uuid: String?
            gattCharacteristics.forEach{ characteristic ->
                uuid = characteristic.uuid.toString()
                if(uuid == uuidCharacteristic){
                    return characteristic
                }
            }
            return null
    }

    fun getState(): Int {
        return state
    }

    private fun handleDecode(characteristic : BluetoothGattCharacteristic){
        when(characteristic.uuid){
            Characteristics.RATE_MEASUREMENT ->
                Firebase.instance.sendDecodeToDB(HeartRate(characteristic))
            Characteristics.RATE_LEVEL ->
                Firebase.instance.sendDecodeToDB(BatteryLevel(characteristic))
            Characteristics.PO_HEART_RATE -> Firebase.instance.sendDecodeToDB(POHeartRate(characteristic))
            Characteristics.PO_ACTIVITY -> Firebase.instance.sendDecodeToDB(POActivity(characteristic))
            Characteristics.PO_PPG -> Firebase.instance.sendDecodeToDB(POPPG(characteristic))
            else -> Log.e("data",Utils.byteArrayToString(characteristic.value))
        }
    }

}