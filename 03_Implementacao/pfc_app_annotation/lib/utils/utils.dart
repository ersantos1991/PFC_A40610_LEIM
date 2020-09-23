import 'dart:ui';
import 'package:appannotation/utils/iconPath.dart';
import 'package:appannotation/utils/imagePath.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'attributes.dart';
import 'myColors.dart';

class Utils {

  // background
  static backgroundImage(){
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage(ImagePath.mainBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
        ),
      ),
    );
  }


  static imageLogo(){
    return Container(
      margin: EdgeInsets.only(top:100.0,bottom: 50.0),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
      child: Container(
        padding: EdgeInsets.only(
          top: 10.0,
          bottom: 10.0,
          right: 10.0,
          left: 10.0
        ),
        height: 150,
        width: 150,
        decoration: BoxDecoration(
            color: Color(0xffffffff).withOpacity(0.24),
            shape: BoxShape.circle
        ),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage(IconPath.iconTree),
              fit: BoxFit.cover,
            ),
          ),
        )
        ,
      ),
    );
  }
  // decoration
  static InputDecoration inputTextDecoration(
      String _hintText,
      _prefixIcon,
      _suffixIcon){
    return InputDecoration(
      hintText: _hintText,
      prefixIcon: _prefixIcon,
      suffixIcon: _suffixIcon,
      filled: true,
      fillColor: Colors.black.withOpacity(0.30),
      hintStyle: TextStyle(
          fontSize: 18,
          color: Colors.white70
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(
              color: Colors.black.withOpacity(0.30),
              width: 0)
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(
              color: Colors.black.withOpacity(0.30),
              width: 0)
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Colors.white, width: 0)
      ),
    );
  }

  static RaisedButton pinkButton(String text,_onPressed){
    return RaisedButton(
      onPressed: _onPressed,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)
      ),
      color: MyColors.colorPink,
      textColor: Colors.white,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 18
        ),
      ),
    );
  }

  static RaisedButton grayButton(String text,_onPressed){
    return RaisedButton(
      onPressed: _onPressed,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)
      ),
      color: Colors.white,
      textColor: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 4, 4, 4),
            child: Text(text,
              style: TextStyle(fontSize: 18)
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Icon(FontAwesome.calendar)
          ),
        ],
      )
    );
  }

  static Container separator(width){
    return Container(
        height: 1.00,
        width: width,
        margin: EdgeInsets.only(top:30.0),
        color: Colors.white
    );
  }

  static Row fromTitle(text){
    return Row(
        children:<Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(5, 20, 0, 5),
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18
              ),
            ),
          )]
    );
  }

  // alerts
  static AlertDialog errorAlert(String message,Function _onPressed){
    return AlertDialog(
      title: Row(
        children: <Widget>[
          Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: MyColors.colorRed,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning,
                color: Colors.white,
                size: 28.0,
              )
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              Attributes.error,
              style: TextStyle(
                  color: MyColors.colorRed
              ),
            ) ,
          )
        ],
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(message)
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            Attributes.ok,
            style: TextStyle(
                fontSize: 18,
                color: MyColors.colorRed
            ),
          ),
          onPressed: _onPressed,
        ),
      ],
    );
  }

  static AlertDialog successAlert(String message,String buttonMessage,Function _onPressed){
    return AlertDialog(
      title: Row(
        children: <Widget>[
          Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: MyColors.colorGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 28.0,
              )
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              Attributes.success,
              style: TextStyle(
                  color: MyColors.colorGreen
              ),
            ) ,
          )
        ],
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(message)
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            buttonMessage,
            style: TextStyle(
                fontSize: 18,
                color: MyColors.colorGreen
            ),
          ),
          onPressed: _onPressed,
        ),
      ],
    );
  }

  // validation
  static bool validate(GlobalKey<FormState> formKey) {
    final FormState form = formKey.currentState;
    return form.validate();
  }

  static bool validateEmail(String email){
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return !regex.hasMatch(email);
  }

  static bool confirmPassword(String pass1, String pass2){
    return !(pass1 == pass2);
  }



}