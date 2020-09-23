
import 'dart:io';
import 'dart:ui';
import 'file:///C:/Users/Pudim/Desktop/PFC/pfc_app_annotation/lib/menu/bottomMenu.dart';
import 'package:appannotation/run/run.dart';
import 'package:appannotation/auth/LoginSocial.dart';
import 'package:appannotation/auth/auth.dart';
import 'package:appannotation/db/cloudFirestore.dart';
import 'package:appannotation/model/annotationModel.dart';
import 'package:appannotation/user/EditUser.dart';
import 'package:appannotation/utils/attributes.dart';
import 'package:appannotation/utils/myColors.dart';
import 'package:appannotation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../main.dart';

class Annotation extends StatefulWidget {
  final FirebaseUser user;
  Annotation({
    Key key,
    @required this.user ,
  }) : super(key: key);

  @override
  _AnnotationPage createState() => _AnnotationPage(user);
}


class _AnnotationPage extends State<Annotation> {
  BottomMenu bottomMenu;
  FirebaseUser user;
  CloudFirestore cloudFirestore;

  _AnnotationPage(FirebaseUser user){
    this.user = user;
    bottomMenu = new BottomMenu(user);
    cloudFirestore = CloudFirestore();
  }

  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid){
      var methodChannel = MethodChannel('com.a40610.messages');
      //methodChannel.invokeMethod("startService");
    }
  }


  Future<FirebaseUser> getUser() async{
    return await AuthService().getUser();
  }

  void onItemTapped(int index) {
    setState(() {
      bottomMenu.setSelectedIndex(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return (user != null) ? FutureBuilder(
      future: cloudFirestore.getAnnotation("annotation",user.uid),
      builder: (context, AsyncSnapshot<AnnotationModel> annotation){
        if(!annotation.hasData || annotation.data == null)
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
                title: Text(Attributes.annotation),
                backgroundColor: Colors.transparent,
                elevation: 0.0
            ),
            body: Stack(
                children: <Widget>[
                  Utils.backgroundImage(),
                  bottomMenu.widgetOptions(context)
                      .elementAt(bottomMenu.getSelectedIndex()),
                ]
            ),
            bottomNavigationBar:bottomMenu.menu(onItemTapped),
            drawer: menu(context)
        );

        return Run(
          annotationModel: annotation.data,
        );
      },
    ) : LoginSocial();
  }

  Drawer menu(context){
    return Drawer(
      child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 2,horizontal: 5),
                        child: user==null?
                        CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, color:MyColors.colorPink,size: 42,),
                            radius: 50.0):
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.photoUrl),
                          radius: 42,)
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user == null?"":user.displayName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                          ),
                        ),
                        IconButton(
                          icon: Icon(FontAwesome.edit,color: Colors.white,),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditUser()),
                            );
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [MyColors.colorPink,MyColors.colorBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            _item(Attributes.home, Icons.home, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Annotation()),
              );
            }),
            _item(Attributes.historic, FontAwesome.book, () {
              AuthService().logOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
              );
            }),
            _item(Attributes.challenges, FontAwesome.trophy, () {AuthService().logOut(); }),
            _item(Attributes.settings, Icons.settings, () {AuthService().logOut(); }),
            _item(Attributes.logout, Icons.exit_to_app, () {
              AuthService().logOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
              );
            }),
          ]),
    );
  }

  ListTile _item(text,icon,activity){
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
            fontSize: 20
        ),
      ),
      leading: Icon(icon),
      onTap:activity,
    );
  }

  static _contextText(){
    return Container(
        alignment: FractionalOffset.bottomCenter,
        margin: EdgeInsets.only(top: 100,right: 15,left: 15),
        child:TextFormField(
          controller: null,
          autocorrect: true,
          style: TextStyle(
              fontSize: 20,
              color: Colors.white
          ),
          validator: null,
          decoration: InputDecoration(
            hintText: 'Select your context',
            prefixIcon: Icon(Icons.person,color: Colors.white),
            filled: true,
            fillColor: Color(0xff000000).withOpacity(0.30),
            hintStyle: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(color: Color(0xff000000).withOpacity(0.30), width: 0)
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(color: Colors.white, width: 0)
            ),
          ),
        )
    );
  }

  _buttonEditUser() {
    return RaisedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditUser()),
        );
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0)
      ),
      color: MyColors.colorPink,
      textColor: Colors.white,
      child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(FontAwesome.edit),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  Attributes.editUser,
                  style: TextStyle(
                      fontSize: 14
                  ),
                )
              )
            ],
      ),
    );
  }
}

