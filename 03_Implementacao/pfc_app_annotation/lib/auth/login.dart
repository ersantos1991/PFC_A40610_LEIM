import 'dart:ui';

import 'package:appannotation/Auth/auth.dart';
import 'file:///C:/Users/Pudim/Desktop/PFC/pfc_app_annotation/lib/annotation/annotation.dart';
import 'package:appannotation/auth/forgotPassword.dart';
import 'package:appannotation/auth/register.dart';
import 'package:appannotation/utils/attributes.dart';
import 'package:appannotation/utils/fonts.dart';
import 'package:appannotation/utils/myColors.dart';
import 'package:appannotation/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



class Login extends StatefulWidget {
  final String email;
  final String password;
  Login({
    Key key,
    @required this.email ,
    @required this.password,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState(email,password);
}

class _LoginPageState extends  State<Login> {

  final formKey = GlobalKey<FormState>();
  String email;
  String password;
  bool _obscureText = true;
  bool _visibility = false;
  TextEditingController _emailController;
  TextEditingController _passwordController;

  _LoginPageState(String email, String password){
    this.email = email;
    this.password = password;
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: email);
    _passwordController = TextEditingController(text: password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0
      ),
      body: Stack(
        children: <Widget>[
          Utils.backgroundImage(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child:Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Utils.imageLogo(),
                      _emailText(),
                      _passwordText(),
                      _forgetPassword(),
                      Visibility(
                          visible: _visibility,
                          child: SpinKitFadingCircle(color: Colors.white)
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      _buttonLogin(),
                      _signUpLink()
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      )
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
          Attributes.email,
          Icon(Icons.person,color: Colors.white),
          null
        )
      )
    );
  }

  _passwordText(){
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child:TextFormField(
        controller: _passwordController,
        autocorrect: true,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white
        ),
        obscureText: _obscureText,
        validator: (value) {
          if (value.isEmpty) {
            return Attributes.someText;
          }
          return null;
        },
        decoration: Utils.inputTextDecoration(
            Attributes.password,
            Icon(Icons.lock,color: Colors.white),
            IconButton(
                onPressed: _toggle,
                icon: _obscureText ?
                Icon(Icons.visibility,color: Colors.white):
                Icon(Icons.visibility_off,color: Colors.white)
            )
        )
      )
    );
  }

  void _toggle(){
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool validate() {
    final FormState form = formKey.currentState;
    return form.validate();
  }

  Container _buttonLogin(){
    return Container(
        margin: EdgeInsets.only(top:50),
        child:ButtonTheme(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Utils.pinkButton(Attributes.login,() async {
            if(validate()){
              setState(() {
                _visibility = !_visibility;
              });
              bool result =  await AuthService().signInWithEmail
                (_emailController.text, _passwordController.text);
              if(!result){
                _errorDialog(Attributes.loginInvalid);
              }
              setState(() {
                _visibility = !_visibility;
              });
              if(result){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Annotation()),
                );
              }
            }
          })
        )
    );
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


  Container _forgetPassword(){
    return Container(
      margin: EdgeInsets.only(bottom: 15.0 ,top: 15.0),
      child:Text.rich(
        TextSpan(
          text: Attributes.forgetPassword,
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontFamily: Fonts.helveticaNeue,
            fontSize: 14,
            color: Colors.white,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.push(
                context,
                MaterialPageRoute(builder:
                  (context) => ForgotPassword(email:_emailController.text)
                ),
              );
            },
        ),
      ),
    );
  }

  Container _signUpLink(){
    return Container(
      margin: EdgeInsets.only(bottom: 50.0 ,top: 50.0),
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

}