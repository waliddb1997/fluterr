import 'dart:async';
import 'dart:convert' show utf8 ;
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';


 class HomePage extends  StatefulWidget{
  const HomePage({Key ?key, required this.device}) : super (key: key);
  final BluetoothDevice device ;
  @override
  _HomePageState create() => _HomePageState();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

}
class _HomePageState extends State<HomePage>{
  final String SERVICE_UUID ="";
  final String CHARACTERISTIC_UUID="";
   bool isReady=false;
  late Stream<List<int>> stream;


  @override
  void initState(){
    super.initState();
  }
  connectToDevice() async {
    if (widget.device == null) {
      _pop();
      return;
    }
    new Timer(const Duration(seconds: 15),(){
      if(!isReady){
        disconnectFromDevice();
        _pop();
      }
    });
    await widget.device.connect();
    discoverServices();
  }

  disconnectFromDevice(){
    if(widget.device == null){
      _pop();
      return;
    }
    widget.device.disconnect();
  }
  discoverServices()async{
    if(widget.device == null){
      _pop();
      return;
    }
    List<BluetoothService> services = await widget.device.discoverServices();
    services.forEach((service) { 
      if(service.uuid.toString()==SERVICE_UUID){
        service.characteristics.forEach((characteristic) {

          if(characteristic.uuid.toString() == CHARACTERISTIC_UUID){
            characteristic.setNotifyValue(!characteristic.isNotifying);
            stream = characteristic.value;

            setState(() {
              isReady=true;
            });
          }
        });
      }
    });
    if(!isReady){
      _pop();
    }
  }
  Future<dynamic> _onWillPop(){
    return showDialog(context: context,
        builder: (context) => new AlertDialog(title :Text('are you sure ?'),
          content: Text('do you want to disconenect and go back ? '),
          actions: <Widget>[
            new FlatButton(onPressed: ()=> Navigator.of(context).pop(false), child: new Text('No')),
            new FlatButton(onPressed: (){
              disconnectFromDevice();
              Navigator.of(context).pop(true);
            } , child: new Text('yes')),
    ], ) ??
    false
     );
  }
  _pop(){
    Navigator.of(context).pop(true);
  }
  String _dataParser(List<int> dataFromDevice){
    return utf8.decode(dataFromDevice);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop (),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tempurature and Heart rate '),),
      body: Container(child: !isReady ? Center(child: Text("Waiting...",),
      ) : Container(
        child: StreamBuilder<List<int>>(
          stream: stream,
          builder: (BuildContext context , AsyncSnapshot<List<int>> snapshot){
            if(snapshot.hasError) return Text("Error: ${snapshot.error}");
            if(snapshot.connectionState == ConnectionState.active){
             var currentValue = _dataParser(snapshot.data);
             return Center(child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 Text('tempurature value',),Text('${currentValue}')
               ],
             ),);
            }
          },
        ),
      ),
      ),
      ),

    );
  }
}