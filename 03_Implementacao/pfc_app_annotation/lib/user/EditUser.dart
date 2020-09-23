
import 'dart:io';

import 'file:///C:/Users/Pudim/Desktop/PFC/pfc_app_annotation/lib/annotation/annotation.dart';
import 'package:appannotation/db/cloudFirestore.dart';
import 'package:appannotation/user/User.dart';
import 'package:appannotation/utils/attributes.dart';
import 'package:appannotation/utils/myColors.dart';
import 'package:appannotation/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appannotation/auth/auth.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;


class EditUser extends StatefulWidget {
  EditUser({
    Key key,
  }) : super(key: key);

  @override
  _EditUserPage createState() => _EditUserPage();
}

class _EditUserPage extends State<EditUser> {
  final formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  User user;
  bool _obscurePassword = true;
  TextEditingController
      _usernameController,
      _emailController,
      _passwordController,
      _firstNameController,
      _lastNameController;
  String _profileImageUrl;
  String _gender = Attributes.other;
  DateTime _birthDate;
  File _image;



  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController(text: "");
    (() async {
      FirebaseUser firebaseUser= await AuthService().getUser();
      Map<String, dynamic> data = await CloudFirestore().getData(Attributes.users, firebaseUser.uid);
      if(data == null) {
        CloudFirestore().addData(Attributes.users, firebaseUser.uid, {
          Attributes.uid: firebaseUser.uid,
          Attributes.firstName.toLowerCase(): "",
          Attributes.lastName.toLowerCase(): "",
          Attributes.gender.toLowerCase(): _gender,
          Attributes.birthDate: DateTime.now().toString(),
        });
        data = await CloudFirestore()
            .getData(Attributes.users, firebaseUser.uid);
      }
      user = User(firebaseUser,data);
      setState(() {

        _usernameController = TextEditingController(text: user.getUsername());
        _emailController = TextEditingController(text: user.getEmail());
        _profileImageUrl = user.getPhotoUrl();
        _gender = user.getGender();
        _firstNameController = TextEditingController(text: user.getFirstName());
        _lastNameController = TextEditingController(text: user.getLastName());
        _birthDate = user.getBirthDate();
      });
    })();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(Attributes.editUser),
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
              child:Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    height: MediaQuery.of(context).size.height-180,
                    child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _imageProfile(),
                            Utils.fromTitle(Attributes.username),
                            _usernameText(),
                            Utils.fromTitle(Attributes.firstName),
                            _firstNameText(),
                            Utils.fromTitle(Attributes.lastName),
                            _lastNameText(),
                            Utils.fromTitle(Attributes.email),
                            _emailText(),
                            Utils.fromTitle(Attributes.password),
                            _passwordText(),
                            Utils.fromTitle(Attributes.gender),
                            _buttonGenderDropdown(),
                            Utils.fromTitle(Attributes.birthday),
                            _buttonBirthDate(),
                          ],
                        )
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      _buttonUpdateUser()
                    ],
                  )

                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _imageProfile(){
    return Container(
        width: MediaQuery.of(context).size.width/1.3,
        height: MediaQuery.of(context).size.height/5,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(2,3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              child: _profileImageUrl==null?
                CircleAvatar(
                  backgroundColor: MyColors.colorPink,
                  child: Icon(Icons.person, color:Colors.white,size: 50,),
                  radius: 50.0):
                CircleAvatar(
                  backgroundImage: NetworkImage(_profileImageUrl),
                  radius: 50.0,)
              ),
            _buttonChangePhoto()
          ],
        )
    );
  }

  TextFormField _usernameText(){
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

  TextFormField _firstNameText(){
    return TextFormField(
        controller: _firstNameController,
        autocorrect: true,
        style: TextStyle(
            fontSize: 16,
            color: Colors.white
        ),
        decoration: Utils.inputTextDecoration(
            "",
            null,
            null)
    );
  }

  TextFormField _lastNameText(){
    return TextFormField(
        controller: _lastNameController,
        autocorrect: true,
        style: TextStyle(
            fontSize: 16,
            color: Colors.white
        ),
        decoration: Utils.inputTextDecoration(
            "",
            null,
            null)
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
            "",
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

  _buttonUpdateUser(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
        child:ButtonTheme(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Utils.pinkButton(Attributes.update,() async {
            user.updateUsername(_usernameController.text);
            user.updateLastName(_firstNameController.text);
            user.updateFirstName(_lastNameController.text);
            user.updateEmail(_emailController.text);
            user.updatePassword(_passwordController.text);
            user.updateGender(_gender);
            user.updateBirthDate(_birthDate);
            user.updatePhotoUrl(_profileImageUrl);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Annotation()),
            );
          }),
        )
    );
  }


  _buttonGenderDropdown(){

    return Container(
        padding: const EdgeInsets.only(top: 6, bottom: 6, right: 5, left: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
        ),
        child:DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _gender,
            isExpanded: true,
            iconSize: 40,
            elevation: 16,
            onChanged: (String newValue) {
              setState(() {
                _gender = newValue;
              });
            },
            iconEnabledColor: Colors.black,
            dropdownColor: Colors.white,
            items: <String>[Attributes.male, Attributes.female, Attributes.other]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black
                )),
              );
            }).toList(),
          )
        )
    );
  }
  
  
  _buttonBirthDate(){
    final f = DateFormat(Attributes.formatBirthDate);
    return Container(
        margin: EdgeInsets.only(top:0),
        child:ButtonTheme(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Utils.grayButton(
            _birthDate == null ? "" : f.format(_birthDate),() {
            showDatePicker(
                context: context,
                initialDate: _birthDate == null ? DateTime.now() : _birthDate,
                firstDate: DateTime(1920),
                lastDate: DateTime.now()
            ).then((date) {
              setState(() {
                if(date!=null){
                  _birthDate = date;
                }
              });
            });
          }),
        )
    );
  }

  _buttonChangePhoto() {
    return RaisedButton(
      onPressed: () async {
        await getImage();
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
                Attributes.changePhoto,
                style: TextStyle(
                    fontSize: 14
                ),
              )
          )
        ],
      ),
    );
  }

  void _togglePassword(){
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
    });
    uploadImage(context);
  }

  Future uploadImage(BuildContext context) async {
    String basename = path.basename(_image.path);
    StorageReference storageReference = FirebaseStorage.instance.ref()
        .child(basename);
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String url = await storageReference.getDownloadURL();
    setState(() {
      _profileImageUrl = url;
    });
  }
}
