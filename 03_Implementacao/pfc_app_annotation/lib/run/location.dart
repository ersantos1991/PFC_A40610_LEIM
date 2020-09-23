import 'dart:async';

import 'package:appannotation/db/cloudFirestore.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  String uuid;
  StreamSubscription<Position> positionStream;
  CloudFirestore cloudFirestore = CloudFirestore();
  Position currentPosition;
  int id = 0;
  bool isEnable = false;

  Location(String uuid){
    this.uuid = uuid;
    cloudFirestore.addData("location", uuid,
        {
          "start":DateTime.now().toUtc().toString(),
          "locations": []
        }
    );
  }

  void start(){
    if(isEnable){
      positionStream = getPositionStream(
          desiredAccuracy:LocationAccuracy.bestForNavigation
      ).listen(
              (Position position) {
            currentPosition = position;
            Map<String, dynamic> data = position.toJson();
            data["id"] =  id++;
            cloudFirestore.updateArrayData("location", uuid, "locations",data);
            print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
          });
    }
  }

  void stop(){
    if(isEnable){
      positionStream.cancel();
    }
  }

  @override
  String toString() {
    return currentPosition.latitude.toString()
        + ', ' + currentPosition.longitude.toString();
  }
}