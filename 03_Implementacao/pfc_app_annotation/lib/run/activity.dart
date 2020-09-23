import 'dart:async';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:flutter/material.dart';


class ActivityGoogle extends StatefulWidget {
  @override
  _ActivityGoogleState createState() => new _ActivityGoogleState();
}


class _ActivityGoogleState extends State<ActivityGoogle> {

  Activity latestActivity = Activity.empty();
  final Stream<Activity> stream = ActivityRecognition.activityUpdates();
  final StreamController<Activity> streamController = new StreamController();
  var myListener;

  @override
  void initState() {
    super.initState();
    stream.asBroadcastStream();
    stream.listen(onData);
  }

  void onData(Activity activity) {
    setState(() {
      latestActivity = activity;
      print(latestActivity.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(latestActivity.toString());
  }
  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }
}

class ActivityRecognitionGoogle{
  Stream<Activity> stream;
  Activity latestActivity = Activity.empty();
  StreamSubscription myListener;

  ActivityRecognitionGoogle(){
    stream = ActivityRecognition.activityUpdates().asBroadcastStream();
  }

  void onData(Activity activity) {
    latestActivity = activity;
    print(latestActivity.toString());
  }
  void start(){
    myListener = stream.listen(onData);
  }
  void stop(){
    myListener.cancel();
  }
}