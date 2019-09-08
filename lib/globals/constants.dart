//Dart Packages
import 'dart:io';

//Flutter Packages
import 'package:flutter/material.dart';


//Duration Constants
const DefaultSneakBarDuration = const Duration(seconds: 2);

//Color Constants
Color acknowledgementTextColor = Color.fromRGBO(44, 44, 44, 0.6);
Color defaultIconColor = Color.fromRGBO(14, 14, 14, 1);
Color defaultSnackBarColor = Color.fromRGBO(255, 255, 255, 1);
const List<Color> PredColor = [ 
                                Colors.white,
                                Colors.pink,
                                Colors.pinkAccent,
                                Colors.amber,
                                Colors.blue,
                                Colors.blueAccent,
                                Colors.purple,
                                Colors.purpleAccent ];

//Directory Constants
Directory directory;
const fileName = "jsonData.json";
File file;
