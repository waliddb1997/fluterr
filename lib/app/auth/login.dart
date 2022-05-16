import 'package:flutter/material.dart';

class Login extends StatefulWidget{
  Login({Key? key}):super(key:key);
  @override
 State<Login> createState()=>_LoginState();
}

class _LoginState extends State<Login>{
 @override
 Widget build(BuildContext context) {
      return Scaffold(

       body: ListView(children: [
         Form(
           child: Column(
             children: [
                Image(image: AssetImage('images/heart.png'),),
                TextFormField(),
                TextFormField(),
           ],),
         )
       ],),
     );
  }
}