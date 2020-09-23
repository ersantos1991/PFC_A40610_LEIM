import 'dart:ui';
import 'package:appannotation/auth/LoginSocial.dart';
import 'package:appannotation/auth/auth.dart';
import 'package:appannotation/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:appannotation/utils/utils.dart';
import 'package:appannotation/utils/attributes.dart';
import 'package:appannotation/utils/fonts.dart';
import 'package:appannotation/utils/myColors.dart';
import 'file:///C:/Users/Pudim/Desktop/PFC/pfc_app_annotation/lib/annotation/annotation.dart';

class ForgotPassword extends StatefulWidget {
  final String email;
  ForgotPassword({Key key, @required this.email }) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState(email);
}

class _ForgotPasswordPageState extends  State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _emailController;
  bool _visibility = false;
  String email;

  _ForgotPasswordPageState(String email){
    this.email = email;
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: email);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            title: Text(Attributes.passwordRecovery),
            backgroundColor: Colors.transparent,
            elevation: 0.0
        ),
        body: Stack(
          children: <Widget>[
            Utils.backgroundImage(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 80.0),
              child:Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        _fromTitle(Attributes.email),
                        _emailText(),
                        _buttonPasswordRecovery(),
                        Visibility(
                            visible: _visibility,
                            child: SpinKitFadingCircle(color: Colors.white)
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        )
    );
  }

  Row _fromTitle(text){
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

  _emailText(){
    return Container(
        child:TextFormField(
          controller: _emailController,
          autocorrect: true,
          style: TextStyle(
              fontSize: 16,
              color: Colors.white
          ),
          validator: (value) {
            if (value.isEmpty) {
              return Attributes.emailEmpty;
            }
            if (Utils.validateEmail(value)) {
              return Attributes.emailInvalid;
            }
            return null;
          },
          decoration: Utils.inputTextDecoration(
              Attributes.emailFrom,
              null,
              Icon(Icons.email,color: Colors.white)
          )
        )
    );
  }

  _buttonPasswordRecovery(){
    return Container(
        margin: EdgeInsets.only(top:50),
        child:ButtonTheme(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: RaisedButton(
            onPressed: () async {
              if(validate()){
                setState(() {
                  _visibility = true;
                });
                String result = await AuthService().forgotPassword(
                  _emailController.text,
                );
                setState(() {
                  _visibility = false;
                });
                (result == Attributes.success)?
                _successDialog(result):_errorDialog(result);
              }
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)
            ),
            color: MyColors.colorPink,
            textColor: Colors.white,
            child: Text(
              Attributes.sendEmail,
              style: TextStyle(
                  fontSize: 18
              ),
            ),
          ),
        )
    );
  }

  bool validate() {
    final FormState form = formKey.currentState;
    return form.validate();
  }
  Future<void> _errorDialog(message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Utils.errorAlert(message, () {
          Navigator.of(context).pop();
        });
      },
    );
  }

  Future<void> _successDialog(message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Utils.successAlert(message,
            Attributes.goToAnnotation
            , () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Login(
                        email: _emailController.text,
                        password: ""
                      )
                  ),
                  ModalRoute.withName('/')
              );
            });
      },
    );
  }
}