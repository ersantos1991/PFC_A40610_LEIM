import 'package:appannotation/annotation/bluetoothView.dart';
import 'package:appannotation/annotation/home.dart';
import 'package:appannotation/annotation/tags.dart';
import 'package:appannotation/utils/attributes.dart';
import 'package:appannotation/utils/myColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class BottomMenu {
  FirebaseUser user;
  int _selectedIndex = 0;
  Home home;
  BluetoothView ble;
  Tags tags;

  BottomMenu(FirebaseUser user){
    this.user = user;
    home = new Home(user: user);
    ble = new BluetoothView(user: user);
    tags = new Tags(user: user);

  }

  BottomNavigationBar menu(onItemTapped){
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text(Attributes.home),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer),
          title: Text(Attributes.tags),
        ),
        /*BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          title: Text(Attributes.schedule),
        ),*/
        BottomNavigationBarItem(
          icon: Icon(Icons.bluetooth),
          title: Text(Attributes.devices),
        ),
        /*BottomNavigationBarItem(
          icon: Icon(Icons.insert_drive_file),
          title: Text(Attributes.data),
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
      home,
      tags,
      ble,
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