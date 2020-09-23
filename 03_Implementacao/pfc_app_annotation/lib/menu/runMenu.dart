


import 'package:appannotation/annotation/bluetoothView.dart';
import 'package:appannotation/annotation/home.dart';
import 'package:appannotation/model/annotationModel.dart';
import 'package:appannotation/run/activity.dart';
import 'package:appannotation/run/location.dart';
import 'package:appannotation/run/emotions.dart';
import 'package:appannotation/run/tags.dart';
import 'package:appannotation/utils/attributes.dart';
import 'package:appannotation/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';


class RunMenu {
  int _selectedIndex = 0;
  BluetoothView ble = new BluetoothView();
  ActivityGoogle activityGoogle = new ActivityGoogle();
  AnnotationModel annotationModel;
  Location location;

  RunMenu(AnnotationModel annotationModel,Location location){
    this.annotationModel = annotationModel;
    this.location = location;
  }

  BottomNavigationBar menu(onItemTapped){
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer),
          title: Text(Attributes.tags),
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesome.heart),
          title: Text(Attributes.emotions),
        ),
        /*BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          title: Text(Attributes.activity),
        ),*/
        /*BottomNavigationBarItem(
          icon: Icon(Icons.bluetooth),
          title: Text(Attributes.devices),
        ),*/
      ],
      backgroundColor: Colors.white,
      currentIndex: _selectedIndex,
      selectedItemColor: MyColors.colorPink,
      unselectedItemColor: Colors.black54,
      type: BottomNavigationBarType.fixed,
      onTap: onItemTapped,
    );
  }

  List<Widget> widgetOptions(context)  {
    return <Widget>[
      Tags(
          annotationModel: annotationModel,
          location: location),
      Emotions(
          annotationModel: annotationModel,
          location: location),
      //ble,

    ];
  }

  int getSelectedIndex(){
    return _selectedIndex;
  }

  void setSelectedIndex(int index){
    _selectedIndex = index;
  }

  Text _item(text){
    return Text(
      text,
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );
  }

}