import 'package:appannotation/Auth/LoginSocial.dart';
import 'package:appannotation/mainLoading.dart';
import 'package:appannotation/utils/attributes.dart';
import 'package:flutter/material.dart';
import 'annotation/annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Attributes.mainTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> user){

        if(user.connectionState == ConnectionState.waiting)
          return MainLoading();

        if(!user.hasData || user.data == null){
          return LoginSocial();
        }
        return Annotation(user:user.data);
      },
    );
  }
}



