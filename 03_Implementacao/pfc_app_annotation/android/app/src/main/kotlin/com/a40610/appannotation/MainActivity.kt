package com.a40610.appannotation

import android.content.Intent
import android.os.Build
import android.widget.Toast
import androidx.annotation.NonNull
import com.a40610.appannotation.background.Annotation
import com.a40610.appannotation.background.BackgroundService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*
import kotlin.collections.ArrayList


class MainActivity: FlutterActivity() {
    private lateinit var currentAnnotation: Annotation

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,"com.a40610.messages")
            .setMethodCallHandler{methodCall, result ->
                when(methodCall.method){
                    "startService" -> startService(methodCall,result)
                    "stopService" -> stopService(methodCall,result)
                    "connect" -> connect(methodCall,result)
                    "disconnect" -> disconnect(methodCall,result)
                    "startAnnotation" -> startAnnotation(methodCall,result)
                    "getIdLocation" -> getIdLocation(methodCall,result)
                }
            }
    }

    private fun startService(methodCall: MethodCall, result: Result){
        val annotation = methodCall.argument<String>("annotation")
        BackgroundService.annotation = annotation
        if(!BackgroundService.isRunning){
            val forService = Intent(this, BackgroundService::class.java)
            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
                startForegroundService(forService)
            }else{
                startService(forService)
            }
        }
        result.success("startService")
    }

    private fun stopService(methodCall: MethodCall, result: Result){
        if(BackgroundService.isRunning){
            val forService = Intent(this, BackgroundService::class.java)
            stopService(forService)
            //BackgroundService.backgroundService?.onDestroy()
        }
        result.success("StopService")
    }

    private fun connect(methodCall: MethodCall, result: Result){
        val mac = methodCall.argument<String>("mac")
        Toast.makeText(this, "connect $mac", Toast.LENGTH_SHORT).show()
        BackgroundService.myBLE!!.connect(mac!!)
        result.success("connect")
    }

    private fun disconnect(methodCall: MethodCall, result: Result){
        val mac = methodCall.argument<String>("mac")
        Toast.makeText(this, "disconnect $mac", Toast.LENGTH_SHORT).show()
        result.success("disconnect")
        BackgroundService.myBLE!!.disconnect(mac!!)
    }

    private  fun startAnnotation(methodCall: MethodCall, result: Result){
        val devices = methodCall.argument<ArrayList<String>>("devices")
        val uuidAnnotation = methodCall.argument<String>("uuid")
        for ( device in devices!!){
            BackgroundService.myBLE!!.connect(device)
        }
        val uuid = UUID.randomUUID()
        Thread.sleep(3000)
        currentAnnotation = Annotation(uuidAnnotation!!)
        currentAnnotation.start()
        result.success(uuid.toString())
    }

    private fun getIdLocation(methodCall: MethodCall, result: Result){
        var id = 0
        if(BackgroundService.isRunning){
            if(BackgroundService.location != null) id = BackgroundService.location!!.id
        }
        result.success(id.toString())
    }
}
