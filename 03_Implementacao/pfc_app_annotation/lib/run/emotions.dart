
import 'package:appannotation/connector/utilsBLE.dart';
import 'package:appannotation/db/cloudFirestore.dart';
import 'package:appannotation/model/annotationModel.dart';
import 'package:appannotation/run/utils.dart';
import 'package:appannotation/utils/attributes.dart';
import 'package:appannotation/utils/myColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'location.dart';

class Emotions extends StatefulWidget {
  final AnnotationModel annotationModel;
  final Location location;
  Emotions({
    Key key,
    @required this.annotationModel ,
    @required this.location ,
  }) : super(key: key);

  @override
  _EmotionsPageState createState() => _EmotionsPageState(annotationModel,location);
}

class _EmotionsPageState extends State<Emotions>{
  AnnotationModel annotationModel;
  double _valenceSliderValue = 5;
  double _arousalSliderValue = 5;
  IconData valence = FontAwesome5.meh;
  IconData arousal = FontAwesome5.grin_alt;
  Location location;
  var valenceColor = Colors.yellow;
  var arousalColor = Colors.yellow;


  _EmotionsPageState(AnnotationModel annotationModel,Location location){
    this.annotationModel = annotationModel;
    this.location = location;
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top:90,left: 15,right: 15),
        child:Column(
          children: [
            Card(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: Text("Valence (Negative - Positive)",style: TextStyle(
                      color: MyColors.colorPink,
                      fontSize: 22
                    ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: Icon(
                      valence,
                      color: valenceColor,
                      size: 80,
                    ),
                  ),
                  Slider(
                    value: _valenceSliderValue,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    activeColor: MyColors.colorPink,
                    label: _valenceSliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _valenceSliderValue = value;
                        if(value<=1){
                          valence = FontAwesome5.sad_tear;
                          valenceColor = Colors.red;
                        }
                        if(value>=2 && value<=3){
                          valence = FontAwesome5.frown;
                          valenceColor = Colors.orange;
                        }
                        if(value>=4 && value<=6){
                          valence = FontAwesome5.meh;
                          valenceColor = Colors.yellow;
                        }
                        if(value>=7 && value<=8){
                          valence = FontAwesome5.smile;
                          valenceColor = Colors.lightGreen;
                        }
                        if(value>=9){
                          valence = FontAwesome5.laugh_beam;
                          valenceColor = Colors.green;
                        }
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Text("0",style: TextStyle(color: Colors.black45)),
                        new Text("5",style: TextStyle(color: Colors.black45)),
                        new Text("10",style: TextStyle(color: Colors.black45)),
                      ]
                  ),
                  ),

                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'SEND',
                          style: TextStyle(
                            color: MyColors.colorPink
                          ),
                        ),
                        onPressed: () async {
                          String id = await UtilsBLE().getIdLocation();
                          var data = {
                            "timestamp":DateTime.now().toUtc().toString(),
                            "type":"arousel",
                            "value":_arousalSliderValue,
                            "locationId":id
                          };
                          this.annotationModel.emotions.add(data);
                          CloudFirestore().updateArrayData(
                              Attributes.annotation.toLowerCase(), annotationModel.uuid, "emotions", data);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: Text("Arousal (Calm - Excited)",style: TextStyle(
                        color: MyColors.colorPink,
                        fontSize: 22
                    ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: Icon(
                      arousal,
                      color: arousalColor,
                      size: 80,
                    ),
                  ),
                  Slider(
                    value: _arousalSliderValue,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    activeColor: MyColors.colorPink,
                    label: _arousalSliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _arousalSliderValue = value;
                        if(value<=1){
                          arousal = FontAwesome5.meh;
                          arousalColor = Colors.red;
                        }
                        if(value>=2 && value<=3){
                          arousal = FontAwesome5.meh_rolling_eyes;
                          arousalColor = Colors.orange;
                        }
                        if(value>=4 && value<=6){
                          arousal = FontAwesome5.grin_alt;
                          arousalColor = Colors.yellow;
                        }
                        if(value>=7 && value<=8){
                          arousal = FontAwesome5.grin_squint;
                          arousalColor = Colors.lightGreen;
                        }
                        if(value>=9){
                          arousal = FontAwesome5.laugh_squint;
                          arousalColor = Colors.green;
                        }
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          new Text("0",style: TextStyle(color: Colors.black45)),
                          new Text("5",style: TextStyle(color: Colors.black45)),
                          new Text("10",style: TextStyle(color: Colors.black45)),
                        ]
                    ),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'SEND',
                          style: TextStyle(
                              color: MyColors.colorPink
                          ),
                        ),
                        onPressed: () async{
                          String id = await UtilsBLE().getIdLocation();
                          var data = {
                            "timestamp":DateTime.now().toUtc().toString(),
                            "type":"arousel",
                            "value":_arousalSliderValue,
                            "locationId":id
                          };
                          this.annotationModel.emotions.add(data);
                          CloudFirestore().updateArrayData(
                            Attributes.annotation.toLowerCase(), annotationModel.uuid, "emotions", data);},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            UtilsRun().buttonStopAnnotation(context,location,annotationModel)
          ],
        )
    );
  }

}

