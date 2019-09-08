//Dart Packages

//Flutter Packages
import "package:flutter/material.dart";

//App Packages
import "./pages/homepage.dart";


void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Notes",
    home: HomePage(),
    theme: ThemeData(
      primarySwatch: Colors.green,
      primaryColor: Color.fromRGBO(254, 254, 254, 1.0),
      brightness: Brightness.light,
      accentColor: Colors.green,
    ),
  )
);