import 'dart:ui';
import 'file:///C:/Users/Pudim/Desktop/PFC/pfc_app_annotation/lib/annotation/annotation.dart';
import 'package:appannotation/auth/auth.dart';
import 'package:appannotation/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:appannotation/utils/utils.dart';
import 'package:appannotation/utils/attributes.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends  State<Register> {
  final formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _visibility = false;
  TextEditingController _usernameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _confirmPasswordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            title: Text(Attributes.signUp2),
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
                        Utils.fromTitle(Attributes.username),
                        _username(),
                        Utils.fromTitle(Attributes.email),
                        _emailText(),
                        Utils.fromTitle(Attributes.password),
                        _passwordText(),
                        Utils.fromTitle(Attributes.confirmPassword),
                        _confirmPasswordText(),
                        Visibility(
                            visible: _visibility,
                            child: SpinKitFadingCircle(color: Colors.white)
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        _buttonCreateAccount(),
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

  TextFormField _username(){
    return TextFormField(
      controller: _usernameController,
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
      decoration: Utils.inputTextDecoration(
        "",
        null,
        Icon(Icons.person,color: Colors.white))
    );
  }

  TextFormField _emailText(){
    return TextFormField(
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
    );
  }

  TextFormField _passwordText(){
    return TextFormField(
      controller: _passwordController,
      autocorrect: true,
      style: TextStyle(
          fontSize: 16,
          color: Colors.white
      ),
      obscureText: _obscurePassword,
      validator: (value) {
        if (value.isEmpty) {
          return Attributes.passwordEmpty;
        }
        return null;
      },
      decoration: Utils.inputTextDecoration("", null,
          IconButton(
              onPressed: _togglePassword,
              icon: _obscurePassword ?
              Icon(Icons.visibility,color: Colors.white):
              Icon(Icons.visibility_off,color: Colors.white)
          )),
    );
  }

  TextFormField _confirmPasswordText(){
    return TextFormField(
      controller: _confirmPasswordController,
      autocorrect: true,
      style: TextStyle(
          fontSize: 16,
          color: Colors.white
      ),
      obscureText: _obscurePassword,
      validator: (value) {
        if (value.isEmpty) {
          return Attributes.confirmPasswordError;
        }
        if(Utils.confirmPassword( value, _passwordController.text)){
          return Attributes.passwordMatchError;
        }
        return null;
      },
      decoration: Utils.inputTextDecoration("", null, null),
    );
  }

  void _togglePassword(){
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  _buttonCreateAccount(){
    return Container(
        margin: EdgeInsets.only(top:50),
        child:ButtonTheme(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Utils.pinkButton(Attributes.createAccount,() async {
            if(Utils.validate(formKey)){
              setState(() {
                _visibility = true;
              });
              String result = await AuthService().createAccount(
                  _usernameController.text,
                  _emailController.text,
                  _passwordController.text
              );
              setState(() {
                _visibility = false;
              });
              (result == Attributes.success)?
              _successDialog(result):_errorDialog(result);
            }
          }),
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
                  builder: (context) => Login()
              ),
              ModalRoute.withName('/')
          );
        });
      },
    );
  }
}