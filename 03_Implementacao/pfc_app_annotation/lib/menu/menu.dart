import 'package:appannotation/annotation/annotation.dart';
import 'package:appannotation/auth/auth.dart';
import 'package:appannotation/utils/attributes.dart';
import 'package:appannotation/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';


class MenuAnnotation {
  String user = "";
  MenuAnnotation(BuildContext context){
    getUser().then((value) =>  user = value);

  }


  Drawer menu(context){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
        DrawerHeader(
          //TODO change
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 70.0,
                  height: 70.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child:Text("E",
                      textAlign:TextAlign.center,
                      style: TextStyle(
                          color: MyColors.colorPink,
                          fontSize: 38
                      )
                    )
                  )
                ),
                Text(
                  user,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  ),
                )
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

  Future<String> getUser() async{
    FirebaseUser user = await AuthService().getUser();
    if(user!=null){
      return user.email;
    }
    return "user";
  }
}

