
import 'package:appannotation/annotation/annotation.dart';
import 'package:appannotation/auth/auth.dart';
import 'package:appannotation/connector/utilsBLE.dart';
import 'package:appannotation/db/cloudFirestore.dart';
import 'package:appannotation/model/annotationModel.dart';
import 'package:appannotation/run/run.dart';
import 'package:appannotation/utils/attributes.dart';
import 'package:appannotation/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'location.dart';

class UtilsRun{
  Widget buttonStopAnnotation(context,Location location,AnnotationModel annotationModel) {
    return Container(
      margin: EdgeInsets.only(bottom: 15, right: 15, left: 15,top:15),
      child: ButtonTheme(
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Utils.pinkButton(Attributes.stopAnnotation, () async {
          location.stop();
          await UtilsBLE().stopService();
          annotationModel.end = DateTime.now().toUtc().toString();
          annotationModel.running = false;
          CloudFirestore().updateData(
              Attributes.annotation.toLowerCase(),
              annotationModel.uuid,
              annotationModel.toJson()
          );
          FirebaseUser user = await AuthService().getUser();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Annotation(user: user,)),
          );
        }),
      ),
    );
  }

  Future<AnnotationModel> startAnnotation(String contextAnnotation, FirebaseUser user,List tags) async {
    AnnotationModel annotationModel = AnnotationModel();
    annotationModel.context = contextAnnotation;
    annotationModel.userId = user.uid;
    await UtilsBLE().startService(annotationModel.context);
    await CloudFirestore().addData(
        Attributes.annotation.toLowerCase(),
        annotationModel.uuid,
        annotationModel.toJson());
    await CloudFirestore().updateArrayData(
        "users",
        user.uid,
        "annotations",
        {
          "context":annotationModel.context,
          "tags":tags,
        });
    Map<String, dynamic> userInfo = await CloudFirestore().getData(
        "users", user.uid);
    print(userInfo);
    if(userInfo != null){
      UtilsBLE().start(userInfo["devices"],annotationModel.uuid);
    }
    return annotationModel;
  }

}