package com.a40610.appannotation.background

import android.content.ContentValues.TAG
import android.content.Context
import android.location.LocationListener
import android.location.LocationManager
import android.os.Bundle
import android.util.Log
import com.a40610.appannotation.background.db.Firebase


class Location(private val context: Context): LocationListener{
    var location: android.location.Location? = null
    private var mLocationManager:LocationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
    private val LOCATION_INTERVAL = 0
    private val LOCATION_DISTANCE = 0f
    var id = 0

    fun start(){
        try {
            mLocationManager.requestLocationUpdates(
                    LocationManager.GPS_PROVIDER,
                    LOCATION_INTERVAL.toLong(),
                    LOCATION_DISTANCE,
                    this
            )
        } catch (ex: SecurityException) {
            Log.i(TAG, "fail to request location update, ignore", ex)
        } catch (ex: IllegalArgumentException) {
            Log.d(TAG, "network provider does not exist, " + ex.message)
        }
    }



    fun stop(){
        mLocationManager.removeUpdates(this)
    }

    override fun onLocationChanged(location: android.location.Location?) {
        this.location = location
        id += 1
        Firebase.instance.sendLocationToDB(location!!)
        /*val toast = Toast.makeText(context, location.toString(), Toast.LENGTH_LONG)
        toast.show()*/
    }

    override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) {
        Log.e(TAG, "onProviderDisabled: " + provider)
    }

    override fun onProviderEnabled(provider: String?) {
        Log.e(TAG, "onProviderEnabled: " + provider)
    }

    override fun onProviderDisabled(provider: String?) {
        Log.e(TAG, "onStatusChanged: " + provider)
    }

}