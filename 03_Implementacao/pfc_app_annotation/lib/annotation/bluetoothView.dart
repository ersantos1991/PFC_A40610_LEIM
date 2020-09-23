
import 'package:appannotation/connector/utilsBLE.dart';
import 'package:appannotation/db/cloudFirestore.dart';
import 'package:appannotation/utils/myColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BluetoothView extends StatefulWidget {
  final FirebaseUser user;
  BluetoothView({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  _BluetoothViewPageState createState() => _BluetoothViewPageState(user);
}

class _BluetoothViewPageState  extends State<BluetoothView>{
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  UtilsBLE _utilsBLE = new UtilsBLE();
  FirebaseUser user;
  bool scanning = false;
  List selectedDevices = [];
  List devicesNames = [
    'hBAND'
  ];

  _BluetoothViewPageState(FirebaseUser user){
    this.user = user;
    CloudFirestore().getData("users", user.uid).then(
      (value) {
        setState(() {
          if(value["devices"] != null) selectedDevices = value["devices"];
        });
      }
    );
  }
  void _onRefresh() async{
    FlutterBlue.instance.isScanning.listen((event) {
      scanning = event;
    });
    if(!scanning){
      FlutterBlue.instance.startScan(timeout: Duration(seconds: 10));
      await Future.delayed(Duration(milliseconds: 1000));

    }
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            return Center(
                child:Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white60,
                    ),
                    constraints: BoxConstraints.expand(),
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0,top:80.0,bottom: 80.0),
                    child:bleScan(context)
                )
            );
          }
          return bleOff(context,state);
        });
  }

  Container bleOff(context,state){
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white,
            ),
            Text(
              'Bluetooth is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  SmartRefresher bleScan(context){
    _onRefresh();
    return SmartRefresher(
      enablePullDown: true,
      //header: WaterDropHeader(),
      child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data.map((d) =>deviceContent(d)).toList(),
                ),
              ),
              /*StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data.map((d) =>deviceContent(d)).toList(),
                ),
              ),*/
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: snapshot.data.map((r) =>deviceContent(r.device)).toList(),
                  ),
                ),
              ),
            ],
          )
      ),
      onRefresh: () => {_onRefresh()},
      controller: _refreshController
    );
  }

  Container deviceContent(BluetoothDevice device){
    bool contains = false;
    devicesNames.forEach((name) {
      print(device.name);
      if(device.name.contains(name)){
        contains = true;
      }
    });
    if(contains)
      return Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0,top:10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 1,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child:ListTile(
            leading: Icon(
              Icons.bluetooth,
              color: MyColors.colorBlue,
              size: 40.0,
            ),
            title: Text(
              device.name == ''?'Unknown Device':device.name,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
            subtitle: Text(device.id.toString()),
            trailing: buttonSelect(device)
            /*trailing: StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.disconnected,
              builder: (c, snapshot) {
                if (snapshot.data == BluetoothDeviceState.connected) {
                  return RaisedButton(
                    onPressed: () async{
                      debugPrint('disconnect'+device.id.toString());
                      String result = await _utilsBLE.disconnect(device.id.toString());
                      _onRefresh();
                    },
                    color: MyColors.colorBlue,
                    child: Text(
                        'Disconnect',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  );
                }
                else{
                  return RaisedButton(
                    onPressed: () async {
                      //r.device.connect();
                      String result = await _utilsBLE.connect(device.id.toString());
                      _onRefresh();
                      debugPrint(result);

                    },
                    color: MyColors.colorBlue,
                    child: Text(
                        'Connect',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  );
                }
              },
            )*/
        )
    );
    return Container();
  }

  RaisedButton buttonSelect(BluetoothDevice device){
    return RaisedButton(
      onPressed: () async {
        setState(() {
          if(selectedDevices.contains(device.id.toString())){
            selectedDevices.remove(device.id.toString());
          }
          else{
            selectedDevices.add(device.id.toString());
          }
        });
        CloudFirestore().updateData("users", user.uid, {
          "devices":selectedDevices
        });
      },
      color: MyColors.colorBlue,
      child: Text(
          !selectedDevices.contains(device.id.toString()) ? "Select":"Deselect",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}
