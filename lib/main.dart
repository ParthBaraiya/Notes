//Dart Packages
// import 'dart:convert';
import 'dart:io';

//Flutter Packages
import "package:flutter/material.dart";
import 'package:notes/appConst.dart';

//Created Classes
import "./bodyNotes.dart";
import './createNewNote.dart';
import "./appConst.dart";
import './jsonFetch.dart';
// import './noteData.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Notes",
      
      home: new NotesData(),
      
      theme: new ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Color.fromRGBO(254, 254, 254, 1.0),
        brightness: Brightness.light,
        accentColor: Colors.green,
      ),
    );
  }
}

class NotesData extends StatefulWidget {
  @override
  _NotesDataState createState() => _NotesDataState();
}

class _NotesDataState extends State<NotesData> {

  @override
  void initState(){
    super.initState();

    initializeFilesAndFolders().then((val){
      setState((){});
    });
  }

  Future<void> initializeFilesAndFolders() async{
    GetFilesAndFolder faf = new GetFilesAndFolder();
    File f = await faf.localfile; 
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Notes"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.add,
              size: 30,
              color: defaultIconColor,
            ),
            padding: EdgeInsets.only(right: 10),
            onPressed: (){
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (BuildContext context) => new NewNote(),
                )
              );
            },
          )
        ],
      ),
      body: new BodyNotes(),
    );
  }
}