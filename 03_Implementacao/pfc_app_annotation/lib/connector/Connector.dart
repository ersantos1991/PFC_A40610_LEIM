import 'dart:io';
import 'package:appannotation/utils/attributes.dart';
import 'package:flutter/services.dart';

class Connector{

  Future<String> startServicePlatform(context) async {
    if(Platform.isAndroid){
      var methodChannel = MethodChannel(Attributes.connectorChannel);
      return await methodChannel.invokeMethod(
          Attributes.startAnnotation,
          {Attributes.context: context}
      );
    }
    return null;
  }
}