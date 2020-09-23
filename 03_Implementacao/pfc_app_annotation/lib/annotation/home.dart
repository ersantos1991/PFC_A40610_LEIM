import 'package:appannotation/run/run.dart';
import 'package:appannotation/model/annotationModel.dart';
import 'package:appannotation/db/cloudFirestore.dart';
import 'package:appannotation/run/utils.dart';
import 'package:appannotation/utils/attributes.dart';
import 'package:appannotation/utils/myColors.dart';
import 'package:appannotation/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Home extends StatefulWidget {
  final FirebaseUser user;
  Home({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(user);
}

class _HomePageState extends State<Home>{
  SharedPreferences prefs;
  final formKey = GlobalKey<FormState>();
  FirebaseUser user;
  TextEditingController contextController;
  PanelController _panelController = PanelController();
  List suggestionContext = [];
  List lastContext = [];
  Map<String, dynamic> data;
  List annotations = [];


  _HomePageState(FirebaseUser user){
    this.user = user;
    (() async {
      data = await CloudFirestore().getData(Attributes.users, user.uid);
      if(data == null) {
        CloudFirestore().addData(Attributes.users, user.uid, {
          Attributes.uid: user.uid,
          Attributes.firstName.toLowerCase(): "",
          Attributes.lastName.toLowerCase(): "",
          Attributes.gender.toLowerCase(): Attributes.other,
          Attributes.birthDate: DateTime.now().toString(),
          "annotations": [],
          "devices": [],
        });
      }
      data = await CloudFirestore().getData(Attributes.users, user.uid);
      setState(() {
        annotations = data["annotations"];
      });
    })();
  }

  @override
  void initState() {
    super.initState();
    (() async {
      prefs = await SharedPreferences.getInstance();
      String context = prefs.getString('context') ?? "";
      contextController = TextEditingController(text: context);
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(top:100),
      //child: _inputContext(),
      child: SlidingUpPanel(
        controller: _panelController,
        parallaxEnabled: false,
        renderPanelSheet: false,
        panel: _floatingPanel(),
        color: Colors.red,
        body: Form(
          key: formKey,
          child: Column(
            children: [
              _inputContext(),
              _buttonStartAnnotation()
            ],
          ),
        )
      ),
    );
  }

  Widget _floatingCollapsed(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
      ),
      child: Center(
        child: Text(
          "This is the collapsed Widget",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _floatingPanel(){
    return Container(
      decoration: BoxDecoration(
        color:Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 20.0,
              color: Colors.transparent,
            ),
          ]
      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              margin: EdgeInsets.symmetric(vertical: 15),
              height: 3,
              color: Colors.grey
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(FontAwesome.lightbulb_o,color: MyColors.colorPink,),
                    Text(Attributes.suggestions,style: TextStyle(
                     fontSize: 18
                    ))
                  ],
                ),
            ),
            Divider(),
            FutureBuilder(
              future: CloudFirestore().getDocumentsId("tag"),
              builder: (context, AsyncSnapshot<List<dynamic>> tags){
                if(!tags.hasData || tags.data == null)
                  return Container();

                return Flexible(
                  child:ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(8.0),
                    children: tags.data.map((id) => ListTile(
                      leading: Icon(FontAwesome.pencil),
                      title: Text(id[0].toUpperCase() + id.substring(1)),
                      onTap: () => {
                        setState(() {
                          contextController.text =
                              id[0].toUpperCase() + id.substring(1);
                          prefs.setString('context', contextController.text);
                          prefs.setStringList('tags',[]);
                        })
                      },
                    )
                    ).toList(),
                  ),
                );
              },
            ),
            Divider(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(FontAwesome.book,color: MyColors.colorPink,),
                  Text(Attributes.lastContexts,style: TextStyle(
                      fontSize: 18
                  ))
                ],
              ),
            ),
            (annotations.isNotEmpty)?Flexible(
              child:ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(8.0),
                  itemCount: annotations.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Icon(FontAwesome.pencil),
                      title:Text(annotations[index]["context"][0].toUpperCase()+
                          annotations[index]["context"].substring(1)),
                      onTap: () => {
                        setState(() {
                          contextController.text =
                              annotations[index]["context"][0].toUpperCase() +
                                  annotations[index]["context"].substring(1);
                            prefs.setString('context', contextController.text);
                            prefs.setStringList('tags',[]);

                        })
                      },
                    );
                    return new Text(data["annotations"][index]);
                  }
              ),
            ):Container()

          ],
        ),
      )
    );
  }

  _inputContext(){
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 25),
        child:TextFormField(
          controller: contextController,
          autocorrect: true,
          style: TextStyle(
              fontSize: 16,
              color: Colors.white
          ),
          validator: (value) {
            if (value.isEmpty) {
              return Attributes.usernameEmpty;
            }
            return null;
          },
          onTap: () {
            _panelController.open();
          },
          onChanged: (text) async{
            await prefs.setString('context', text);
            prefs.setStringList('tags',[]);
          },
          decoration: Utils.inputTextDecoration(
              Attributes.selectContext,
              null,
              Icon(FontAwesome.search,color: Colors.white))
      )
    );
  }

  _buttonStartAnnotation(){
    return Container(
      margin: EdgeInsets.only(bottom:15,right: 15,left: 15),
      child:ButtonTheme(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Utils.pinkButton(Attributes.startAnnotation2,() async {
          if(Utils.validate(formKey)){
            List tags = prefs.getStringList("tags") ?? [];
            AnnotationModel annotationModel = await UtilsRun()
                .startAnnotation(contextController.text, user, tags);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Run(
                  annotationModel: annotationModel)
              ),
            );
          }
          return true;
        }),
      ),
    );
  }
}


