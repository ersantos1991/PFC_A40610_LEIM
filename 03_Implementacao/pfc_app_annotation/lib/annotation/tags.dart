
import 'package:appannotation/connector/utilsBLE.dart';
import 'package:appannotation/db/cloudFirestore.dart';
import 'package:appannotation/utils/attributes.dart';
import 'package:appannotation/utils/myColors.dart';
import 'package:appannotation/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Tags extends StatefulWidget {
  final FirebaseUser user;
  String context;
  Tags({
    Key key,
    @required this.user,
    @required this.context,
  }) : super(key: key);
  @override
  _TagsPageState createState() => _TagsPageState(user,context);
}

class _TagsPageState  extends State<Tags>{
  final formKey = GlobalKey<FormState>();
  SharedPreferences prefs;
  FirebaseUser user;
  TextEditingController tagController;
  List<String> tags = [];

  _TagsPageState(FirebaseUser user, String context){
    this.user = user;
    (() async {
      prefs = await SharedPreferences.getInstance();
      String context = prefs.getString('context') ?? "";
      List prefsTags = prefs.getStringList('tags') ?? List<String>();
      setTags(prefsTags);
      CloudFirestore().getData(Attributes.tag, context.toLowerCase())
          .then((value) {if(value!= null) setTags(List<String>.from(value["tags"]));});
    })();
  }

  void setTags(List<String> list){
    if(list != null){

      setState(() {
        tags.addAll(list);
        tags = tags.toSet().toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    tagController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {

    return Center(
        child:Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white60,
            ),
            constraints: BoxConstraints.expand(),
            margin: const EdgeInsets.only(left: 10.0, right: 10.0,top:80.0,bottom: 10.0),
            child: Form(
                key: formKey,
                child: Column(
                  children: [
                    _inputTag(),
                    ScrollConfiguration(
                      behavior: NoGlowBehavior(),
                      child: Flexible(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                          child: buildListViewTags(context),
                        ),
                      ),
                    ),
                  ],
                ),
              )
        )
    );
  }

  _inputTag(){
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 25),
        child:TextFormField(
            controller: tagController,
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
                "Tag",
                null,
                IconButton(
                  icon: new Icon(FontAwesome.plus_circle),
                  highlightColor: Colors.white,
                  color: Colors.white,
                  onPressed: (){
                    if(Utils.validate(formKey)){
                      setState(() {
                        tags.insert(0, tagController.text);
                        tagController.text = "";
                        tags = tags.toSet().toList();
                      });
                    }
                  },
                ))
        )
    );
  }

  Widget buildListViewTags(BuildContext context){
    return ListView.builder(
        itemCount: tags.length,
        itemBuilder: (BuildContext context, int index) {
          final item = tags[index];
          return Dismissible(
            key: Key(item),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
              setState(() {
                tags.removeAt(index);
              });
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text("$item Removed")));
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
              )
            ),
          );
        }
    );
  }
  @override
  void dispose() {
    (() async {
      await prefs.setStringList("tags",tags);
    })() ;
    super.dispose();

  }

}

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}