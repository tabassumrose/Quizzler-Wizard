import 'package:flutter/material.dart';
import 'package:quizzler_app/helper/functions.dart';
import 'package:quizzler_app/views/Home.dart';
import 'package:quizzler_app/views/SignIn.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   bool _isLoggedin = false;
   @override
    void initState() {
     checkUserLoggedInStatus();
     super.initState();
   }

   checkUserLoggedInStatus() async {
     HelperFunctions.getUserLoggedInDetails().then((value){
       setState(() {
         _isLoggedin = value;
       });
     });
   }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: (_isLoggedin ?? false) ? Home() :  SignIn()  ,
    );
  }
}

