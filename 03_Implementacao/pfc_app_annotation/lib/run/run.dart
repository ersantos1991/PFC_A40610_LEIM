import 'dart:async';
import 'dart:io';
import 'package:appannotation/menu/runMenu.dart';
import 'package:appannotation/run/location.dart';
import 'package:appannotation/model/annotationModel.dart';
import 'package:appannotation/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Run extends StatefulWidget {
  final AnnotationModel annotationModel;
  Run({
    Key key,
    @required this.annotationModel
  }) : super(key: key);

  @override
  _RunPage createState() => _RunPage(annotationModel);
}

class _RunPage extends State<Run> {
  RunMenu runMenu;
  AnnotationModel annotationModel;
  Location location;

  _RunPage(AnnotationModel annotationModel){
    this.annotationModel = annotationModel;
    location = Location(annotationModel.uuid);
    location.start();
    runMenu = new RunMenu(annotationModel,location);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:() async => _onWillPop(),
      child:Scaffold(
        resizeToAvoidBottomPadding: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(annotationModel.context),
          backgroundColor: Colors.transparent,
          elevation: 0.0
        ),
        body: Stack(
          children: <Widget>[
            Utils.backgroundImage(),
            runMenu.widgetOptions(context).elementAt(runMenu.getSelectedIndex()),
          ]
        ),
        bottomNavigationBar:runMenu.menu(onItemTapped),
      )
    );
  }

Future<bool> _onWillPop() async {
  return (await showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: new Text('Are you sure?'),
      content: new Text('Do you want to exit an App'),
      actions: <Widget>[
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: new Text('No'),
        ),
        new FlatButton(
          onPressed: () => exit(0),
          child: new Text('Yes'),
        ),
      ],
    ),
  )) ?? false;
}

  void onItemTapped(int index) {
    setState(() {
      runMenu.setSelectedIndex(index);
    });
  }

}