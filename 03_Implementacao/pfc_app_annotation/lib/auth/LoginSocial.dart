import 'dart:ui';
import 'file:///C:/Users/Pudim/Desktop/PFC/pfc_app_annotation/lib/annotation/annotation.dart';
import 'package:appannotation/auth/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:appannotation/Auth/auth.dart';
import 'package:appannotation/Auth/login.dart';
import 'package:appannotation/utils/attributes.dart';
import 'package:appannotation/utils/fonts.dart';
import 'package:appannotation/utils/iconPath.dart';
import 'package:appannotation/utils/myColors.dart';
import 'package:appannotation/utils/utils.dart';

import '../mainLoading.dart';




class LoginSocial extends StatefulWidget {

  LoginSocial({Key key}) : super(key: key);

  @override
  _LoginSocialState createState() => _LoginSocialState();
}


class _LoginSocialState extends State<LoginSocial> {

  bool _visibility = false;
  FirebaseUser user;

  @override
  Widget build(BuildContext context) {

    final double widthScreen = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> user){

        if(user.connectionState == ConnectionState.waiting)
          return MainLoading();

        if(!user.hasData || user.data == null){
          return Scaffold(
              body: Stack(
                  children: <Widget>[
                    Utils.backgroundImage(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Utils.imageLogo(),
                        Visibility(
                            visible: _visibility,
                            child: SpinKitFadingCircle(color: Colors.white)
                        ),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _socialButton(IconPath.iconGoogle,Social.Google),
                                  _socialButton(IconPath.iconFacebook,Social.Facebook),
                                  _socialButton(IconPath.iconTwitter,Social.Twitter),
                                ],
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Utils.separator(widthScreen * 0.4),
                                    Container(
                                      margin: EdgeInsets.only(top:30,left:10.0,right: 10.0),
                                      child: Text(
                                        Attributes.or,
                                        style: TextStyle(
                                          fontFamily: Fonts.helveticaNeue,
                                          fontSize: 12,
                                          color:Colors.white,
                                        ),
                                      ),
                                    ),
                                    Utils.separator(widthScreen * 0.4),
                                  ]
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[ _signInLink() ]
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[ _signUpLink() ]
                              )
                            ]
                        ),
                      ],
                    ),
                  ]
              )
          );
        }
        return Annotation(user:user.data);
      },
    );
    return Scaffold(
        body: Stack(
          children: <Widget>[
          Utils.backgroundImage(),
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Utils.imageLogo(),
                Visibility(
                    visible: _visibility,
                    child: SpinKitFadingCircle(color: Colors.white)
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _socialButton(IconPath.iconGoogle,Social.Google),
                          _socialButton(IconPath.iconFacebook,Social.Facebook),
                          _socialButton(IconPath.iconTwitter,Social.Twitter),
                        ],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Utils.separator(widthScreen * 0.4),
                            Container(
                              margin: EdgeInsets.only(top:30,left:10.0,right: 10.0),
                              child: Text(
                                Attributes.or,
                                style: TextStyle(
                                  fontFamily: Fonts.helveticaNeue,
                                  fontSize: 12,
                                  color:Colors.white,
                                ),
                              ),
                            ),
                            Utils.separator(widthScreen * 0.4),
                          ]
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[ _signInLink() ]
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[ _signUpLink() ]
                      )
                    ]
                ),
              ],
            ),
          ]
        )
    );
  }


  _socialButton(icon,type){
    return GestureDetector(
      onTap: () async{
        bool result;
        switch(type){
          case Social.Google:
            _changeVisibility();
            _loginGoogle();
            _changeVisibility();

            break;
          case Social.Facebook:
            print('Facebook');
            setState(() {
              _visibility = true;
            });

            result = true;
            break;
          case Social.Twitter:
            print('Twitter');
            setState(() {
              _visibility = true;
            });
            result = true;
            break;
        }
        print(result);
      },
      child: Container(
        height: 50,
        width: 50,
        margin: const EdgeInsets.only(right: 25, left: 25),
        decoration: BoxDecoration(
          color: MyColors.colorPink,
          border: Border.all(width: 1.00, color: Colors.white),
          shape: BoxShape.circle,
        ),
        child: Container(
          height: 17.91,
          width: 8.41,
          decoration:BoxDecoration(
            image: DecorationImage(
              image: AssetImage(icon),
            ),
          ),
        ),
      ),
    );
  }


  _signUpLink(){
    return Container(
        margin: EdgeInsets.only(bottom: 30.0),
        child:Text.rich(
        TextSpan(
          text: Attributes.register,
          style: TextStyle(
            fontFamily: Fonts.helveticaNeue,
            fontSize: 14,
            color:Colors.white,
          ),
          children: <TextSpan>[
            TextSpan(
              text: Attributes.signUp,
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontFamily: Fonts.helveticaNeue,
                fontSize: 14,
                color: MyColors.colorPink,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
            )
          ],
        ),
      ),
    );
  }


  _signInLink(){
    return Container(
      margin: EdgeInsets.only(top:30.0, bottom: 30.0),
      child:Text.rich(
        TextSpan(
          text: Attributes.usingAccount,
          style: TextStyle(
            fontFamily: Fonts.helveticaNeue,
            fontSize: 14,
            color:Colors.white,
          ),
          children: <TextSpan>[
            TextSpan(
              text: Attributes.signIn,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontFamily: Fonts.helveticaNeue,
                  fontSize: 14,
                  color: MyColors.colorPink,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
            )
          ],
        ),
      ),
    );
  }
  _changeVisibility(){
    setState(() {
      _visibility = !_visibility;
    });
  }

  _loginGoogle() async {
    setState(() {
      _visibility = !_visibility;
    });
    await AuthService().loginGoogle();
    setState(() {
      _visibility = !_visibility;
    });
  }

}

enum Social {
  Google,
  Facebook,
  Twitter
}

/*_signInButton() {
    return new GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        },
        child: new Container(
          height: 40,
          width: MediaQuery
              .of(context)
              .size
              .width / 1.3,
          margin: const EdgeInsets.only(bottom: 80.0),
          padding: const EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
            color: Color(0xff9a9a9a),
            border: Border.all(width: 1.00, color: Color(0xffffffff),),
            borderRadius: BorderRadius.circular(5.00),
          ),
          child: new Text(
            "Sign In",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Helvetica Neue",
              fontSize: 16,
              color: Color(0xffffffff),
            ),
          ),
        )
    );
  }*/