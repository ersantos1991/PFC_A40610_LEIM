package com.a40610.appannotation.background.ble

import android.annotation.TargetApi
import android.bluetooth.*
import android.content.Context
import android.os.Build
import android.os.Handler
import android.util.Log
import com.a40610.appannotation.background.ble.decode.Characteristics
import java.nio.charset.Charset
import java.util.*
import kotlin.collections.HashMap

@TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR2)
class MyBLE() {

    private lateinit var context: Context
    private lateinit var bluetoothManager: BluetoothManager
    private lateinit var bluetoothAdapter: BluetoothAdapter
    private val devicesConnect = HashMap<BluetoothDevice,BluetoothGatt>()
    private val devices = HashMap<String,BluetoothDevice>()

    private val gattCallback = BLECallback()

    constructor(context: Context) : this() {
        this.context = context
        bluetoothManager = context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        bluetoothAdapter = bluetoothManager.adapter
    }

    private fun isEnable(): Boolean {
        return bluetoothAdapter.isEnabled
    }

    fun connect(mac:String) {
        val device = bluetoothAdapter.getRemoteDevice(mac)
        devices[mac] = device
        devicesConnect[device] = device.connectGatt(context, false, gattCallback)
    }

    fun disconnect(mac:String) {
        val device = bluetoothAdapter.getRemoteDevice(mac)
        devicesConnect[device]?.disconnect()
    }
    fun disconnectAll() {
        devicesConnect.forEach{ (key, device) ->
            device.disconnect()
        }
    }

    fun read(mac:String, uuidService:UUID, uuidCharacteristic:UUID): Boolean? {
        val device = bluetoothAdapter.getRemoteDevice(mac)
        val service = devicesConnect[device]?.getService(uuidService)
        val characteristic = service?.getCharacteristic(uuidCharacteristic)


        if(uuidCharacteristic == Characteristics.MAXIM_NOTIFY){
            Log.e("write","test")
            Handler().postDelayed({
                read(mac, uuidService, uuidCharacteristic)

            }, 200)
        }
        return devicesConnect[device]?.readCharacteristic(characteristic)
    }

    fun write(mac:String, uuidService:UUID, uuidCharacteristic:UUID, data: String) {
        Log.e("write",data)
        val device = bluetoothAdapter.getRemoteDevice(mac)
        val service = devicesConnect[device]?.getService(uuidService)
        val characteristic = service?.getCharacteristic(uuidCharacteristic)
        val dataByte = data.toByteArray()
        characteristic?.value = data.toByteArray()
        val result = devicesConnect[device]?.writeCharacteristic(characteristic)
        Log.e("write",result.toString())
    }

    fun notify(mac:String, uuidService:UUID, uuidCharacteristic:UUID):Boolean? {
        val device = bluetoothAdapter.getRemoteDevice(mac)
        val service = devicesConnect[device]?.getService(uuidService)
        val characteristic = service?.getCharacteristic(uuidCharacteristic)
        characteristic?.descriptors?.forEach {
            descriptor ->
            descriptor.apply { value = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE  }
            devicesConnect[device]?.writeDescriptor(descriptor)
        }
        val result = devicesConnect[device]?.setCharacteristicNotification(characteristic,true)
        /*val descriptor = characteristic?.getDescriptor(uuidDescriptor)?.apply {
            value = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
        }
        devicesConnect[device]?.writeDescriptor(descriptor)*/
        Log.e("device",device.toString())
        Log.e("service",service.toString())
        Log.e("characteristic",characteristic.toString())
        Log.e("RESULT_BLE",result.toString())
        return result
    }

    fun getDeviceName(mac:String): String {
        val device = bluetoothAdapter.getRemoteDevice(mac)
        return device.name
    }
    fun getDevices():HashMap<String,BluetoothDevice>{
        return devices
    }
}