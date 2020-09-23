import 'package:appannotation/utils/utils.dart';
import 'package:flutter/material.dart';

class MainLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
        Utils.backgroundImage(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Utils.imageLogo()
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top:100,bottom: 10),
                      child:SizedBox(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                        height: 50.0,
                        width: 50.0,
                      )
                    )
                  ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Loading",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                    ),
                  )
                ],
              )
              ]
            )
          )
        ]
      ),
    );
  }

}