
import 'package:appannotation/annotation/annotation.dart';
import 'package:appannotation/connector/utilsBLE.dart';
import 'package:appannotation/db/cloudFirestore.dart';
import 'package:appannotation/model/annotationModel.dart';
import 'package:appannotation/run/utils.dart';
import 'package:appannotation/utils/attributes.dart';
import 'package:appannotation/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'location.dart';

class Tags extends StatefulWidget {
  final AnnotationModel annotationModel;
  final Location location;
  Tags({
    Key key,
    @required this.annotationModel ,
    @required this.location ,
  }) : super(key: key);

  @override
  _TagsPageState createState() => _TagsPageState(annotationModel,location);
}

class _TagsPageState extends State<Tags>{
  SharedPreferences prefs;
  TextEditingController _tagController;
  AnnotationModel annotationModel;
  Location location;
  List _tags = [];

  _TagsPageState(AnnotationModel annotationModel,Location location){
    this.annotationModel = annotationModel;
    this.location = location;
    (() async {
      prefs = await SharedPreferences.getInstance();
      String context = prefs.getString('context') ?? "";
      List prefsTags = prefs.getStringList('tags') ?? List<String>();
      setTags(prefsTags);
      CloudFirestore().getData(Attributes.tag, context.toLowerCase())
          .then((value) {if(value!= null) setTags(List<String>.from(value["tags"]));});
    })();
  }

  void setTags(value){
    if(value != null){
      setState(() {
        _tags.addAll(value);
        _tags = _tags.toSet().toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tagController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:90,left: 15,right: 15),
      child:Column(
        children: [
          _addTag(),
          ScrollConfiguration(
            behavior: NoGlowBehavior(),
            child: Flexible(
              child: buildListViewTags(context),
            ),
          ),
          UtilsRun().buttonStopAnnotation(context,location,annotationModel)
        ],
      )
    );
  }
  TextFormField _addTag(){
    return TextFormField(
        controller: _tagController,
        autocorrect: true,
        style: TextStyle(
            fontSize: 16,
            color: Colors.white
        ),
        validator: (value) {
          if (value.isEmpty) {
            return Attributes.tagEmpty;
          }
          return null;
        },
        decoration: Utils.inputTextDecoration(
            "Add tag",
            null,
            IconButton(
              icon: new Icon(FontAwesome.plus_circle),
              highlightColor: Colors.white,
              color: Colors.white,
              onPressed: (){
                setState(() {
                  _tags.insert(0, _tagController.text);
                  _tagController.text = "";
                });
              },
            ))
    );
  }

  Widget buildListViewTags(BuildContext context){
    return ListView.builder(
        itemCount: _tags.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _tags[index];
          return Dismissible(
            key: Key(item),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction)  {
                UtilsBLE().getIdLocation().then((id) => {
                  setState(() {
                    _tags.removeAt(index);
                    _tags.insert(0, item);
                    var data = {
                      "timestamp":DateTime.now().toUtc().toString(),
                      "tag":item,
                      "locationId":id
                    };
                    this.annotationModel.tags.add(data);
                    CloudFirestore().updateArrayData(
                      Attributes.annotation.toLowerCase(), annotationModel.uuid, "tags", data);
                })
              });
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text("$item Selected")));
            },
            child: Card(
              color: Colors.white,
              child: ListTile(
                title: Center(
                  child: Text(
                    item[0].toUpperCase() + item.substring(1),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey.shade700),
                  )
                )
              ),
            ),
          );
        }
    );
  }

  Widget _buttonStopAnnotation() {
    return Container(
      margin: EdgeInsets.only(bottom: 15, right: 15, left: 15,top:15),
      child: ButtonTheme(
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Utils.pinkButton(Attributes.stopAnnotation, () {
          location.stop();
          CloudFirestore().updateData(
            Attributes.annotation.toLowerCase(),
            annotationModel.uuid,
            {
              "running":false,
              "end":DateTime.now().toUtc().toString()
            }
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Annotation()),
          );
        }),
      ),
    );
  }
}

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}