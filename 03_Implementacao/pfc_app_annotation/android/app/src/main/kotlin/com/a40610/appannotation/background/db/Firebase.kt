package com.a40610.appannotation.background.db

import android.content.Context
import android.location.Location
import android.util.Log
import android.widget.Toast
import com.a40610.appannotation.background.ble.decode.Decode
import com.a40610.appannotation.background.utils.Constants
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import com.google.firebase.firestore.FieldValue
import com.google.firebase.firestore.FirebaseFirestore
import java.util.*
import kotlin.collections.ArrayList


class Firebase() {
    private val db = FirebaseFirestore.getInstance()
    private lateinit var uuid: String
    private var id = 0
    companion object {
        val instance = Firebase()
    }

    fun setUUID(uuid: String){
        id = 0
        this.uuid = uuid
    }

    fun sendDecodeToDB(decode: Decode){
        val data = decode.getData()
        data["idLocation"] = id
        db.collection(Constants.data)
            .document(uuid)
            .update(decode.getName(), FieldValue.arrayUnion(data))
            .addOnSuccessListener {
                Log.d("test", "DocumentSnapshot successfully written!")
            }
            .addOnFailureListener { e ->
                Log.w("test", "Error writing document", e)
            }
    }

    fun createEmptyData(empty: HashMap<String, ArrayList<Any>>){
        db.collection(Constants.data)
            .document(uuid)
            .set(empty)
            .addOnSuccessListener {
                Log.d("test", "DocumentSnapshot successfully written!")
            }
            .addOnFailureListener { e ->
                Log.w("test", "Error writing document", e)
            }
    }

    fun sendLocationToDB(location: Location){
        id += 1
        db.collection("location")
                .document(uuid)
                .update("locations", FieldValue.arrayUnion(location))
                .addOnSuccessListener {
                    Log.d("test", "DocumentSnapshot successfully written!")
                }
                .addOnFailureListener { e ->
                    Log.w("test", "Error writing document", e)
                }
    }
}