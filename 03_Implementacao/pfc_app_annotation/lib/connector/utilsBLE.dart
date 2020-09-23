
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class UtilsBLE{
  MethodChannel _methodChannel;

  UtilsBLE(){
    if(Platform.isAndroid){
      _methodChannel = MethodChannel('com.a40610.messages');
    }
  }
  Future<String> start(List devices,String uuid) async{
    print(devices);
    String data = await _methodChannel. invokeMethod("startAnnotation",
        {
          "devices": devices,
          "uuid":uuid,
        }
    );
    debugPrint(data);
    return data;
  }

  Future<String> connect(String mac) async{
    String data = await _methodChannel.invokeMethod("connect", {'mac': mac});
    debugPrint(data);
    return data;
  }

  Future<String> disconnect(String mac) async{
    String data = await _methodChannel.invokeMethod("disconnect",{'mac': mac});
    debugPrint(data);
    return data;
  }

  Future<String> stopService() async{
    debugPrint("test");
    String data = await _methodChannel.invokeMethod("stopService");
    debugPrint(data);
    return data;
  }

  Future<String> startService(String annotation) async{
    String data = await _methodChannel.invokeMethod("startService",{
      "annotation":annotation,
    });
    debugPrint(data);
    return data;
  }

  Future<String> getIdLocation() async{
    String data = await _methodChannel.invokeMethod("getIdLocation",);
    debugPrint(data);
    return data;
  }

}