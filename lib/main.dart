import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:pfe/ble/widgets.dart';
import 'package:pfe/ble/bluetooth.dart';
import 'package:pfe/app/auth/login.dart';
void main() async{
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'IOT Medical PFE Application',
      initialRoute: "/",
      routes: {
        "/":(context)=> FlutterBlueApp(),
        "Login":(context) => Login()
      },
    );
  }
}
