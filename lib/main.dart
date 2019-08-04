//Dart Packages

//Flutter Packages
import "package:flutter/material.dart";

//App Packages
import "./pages/homepage.dart";


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Notes",
      
      home: HomePage(),
      
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Color.fromRGBO(254, 254, 254, 1.0),
        brightness: Brightness.light,
        accentColor: Colors.green,
      ),
    );
  }
}