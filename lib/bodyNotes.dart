//Dart packages

// import "dart:math";
import 'dart:io';
import "dart:convert";

import "package:flutter/material.dart";
import 'package:notes/createNewNote.dart';

import "./appConst.dart";
import "./noteData.dart";
import 'jsonFetch.dart';

class BodyNotes extends StatefulWidget {
  // BuildContext context;
  // BodyNotes(this.context);
  @override
  _BodyNotesState createState() => _BodyNotesState();
}

class _BodyNotesState extends State<BodyNotes> {

  // var r_generator = new Random();
  //Generates a list having values [1,2,3,...,5]
  dynamic notesList = [];

  GetFilesAndFolder faf = new GetFilesAndFolder();

  @override
  void initState(){
    super.initState();

    getDataFromJSON().then( (String data) {
      print(data);
      setState( () {
        print("Data: ");
        print(data.length);
        if (data.length > 0){
          notesList = jsonDecode(data);
        }
      });
    }).catchError((e){
      print(e);
    });
  }



  Future<String> getDataFromJSON() async{
    File f = await faf.localfile;
    String data = await f.readAsString();
    return data;
  }

  Future<List> _addItem({dynamic item,int index}) async {

    File f = await faf.localfile;
    List l = notesList;
    l.insert(index, item);
    f = await f.writeAsString(jsonEncode(l));
    return l;
  }

  Future<List> _removeItem(int index) async {

    File f = await faf.localfile;
    List l = notesList;
    l.removeAt(index);
    f = await f.writeAsString(jsonEncode(l));
    return l;

  }

  Future<void> _navigateToNoteData(int index,BuildContext context) async{
    final s = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context)=> new NoteData.addData(notesList[index],index),
      )
    );

    print(s);

    // if()
    setState(() {
      notesList = s;
    });
  }
  
  void _noteDismiss(int index,BuildContext context){
    var item = notesList[index];
    print("index= $index");
    _removeItem(index).then((List l){
      print(l);
      setState(() {
        notesList = l;
      });
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: new Text(
          "Note Removed",
          style: new TextStyle(
            color: defaultSnackBarColor,
          ),
        ),
        duration: DefaultSneakBarDuration,
        action: SnackBarAction(
          label: "UNDO",
          onPressed: (){
              _addItem(
                index: index,
                item: item
              ).then((List l){
                setState(() {
                  notesList = l;
                });
              }).catchError((e)=>print(e));
          },
        ),
      ));
    }).catchError((e)=>print(e));
  }

  _navigateToNewNote(BuildContext context) async{
    
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewNote()),
    );

    // return notesList;

    // Scaffold.of(widget.context)
    //   ..hideCurrentSnackBar()
    //   ..showSnackBar(new SnackBar(
    //     content: Text("Saved")
    //   ));

    // print("f = $f");


    // return list;

  }

  Future<void> _refreshNotes() async {

    await Future.delayed(Duration(seconds: 2));

    getDataFromJSON().then( (String data) {
      print(data);
      setState( () {
        print("Data: ");
        print(data.length);
        if (data.length > 0){
          notesList = jsonDecode(data);
        }
      });
    }).catchError((e){
      print(e);
    });
  }

  Widget notesTemplete(BuildContext context,int index){
    return new Dismissible(
      key: new Key(notesList[index]["id"]),
      background: new Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20.0),
          color: Colors.red,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
      ),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(15.0),
                  child: new CircleAvatar(
                    child: new Text("${notesList[index]["title"]==""? "N":notesList[index]["title"][0]}".toUpperCase(),style: new TextStyle(color: Colors.white)),
                    backgroundColor: Colors.green,
                  ),
                ),
                new Expanded(
                  child: new InkWell(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text("${notesList[index]["title"]}",
                          style: new TextStyle(
                            // decoration: TextDecoration.underline,
                            fontSize: 17
                          ),
                        ),
                        new Padding(padding: EdgeInsets.only(top: 7.0),),
                        new Text("${notesList[index]["note"]}",
                          // overflow: TextOverflow.fade,
                          style: new TextStyle(
                            color: Color.fromRGBO(44, 44, 44, 0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    onTap: () => _navigateToNoteData(index,context).catchError((e) => print(e)),
                  ),
                ),
              ],
            ),
          new Divider(),
        ]
      ),
      onDismissed: (direction){
        _noteDismiss(index,context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // List l = new List.generate(notesList.length, (int index){return index;});

    if(notesList.length > 0){
      return new RefreshIndicator(
        onRefresh: _refreshNotes,
        child: new ListView.builder(
          itemCount: notesL//Dart packages

// import "dart:math";
import 'dart:io';
import "dart:convert";

import "package:flutter/material.dart";
import 'package:notes/createNewNote.dart';

import "./appConst.dart";
import "./noteData.dart";
import 'jsonFetch.dart';

class BodyNotes extends StatefulWidget {
  // BuildContext context;
  // BodyNotes(this.context);
  @override
  _BodyNotesState createState() => _BodyNotesState();
}

class _BodyNotesState extends State<BodyNotes> {

  // var r_generator = new Random();
  //Generates a list having values [1,2,3,...,5]
  dynamic notesList = [];

  GetFilesAndFolder faf = new GetFilesAndFolder();

  @override
  void initState(){
    super.initState();

    getDataFromJSON().then( (String data) {
      print(data);
      setState( () {
        print("Data: ");
        print(data.length);
        if (data.length > 0){
          notesList = jsonDecode(data);
        }
      });
    }).catchError((e){
      print(e);
    });
  }



  Future<String> getDataFromJSON() async{
    File f = await faf.localfile;
    String data = await f.readAsString();
    return data;
  }

  Future<List> _addItem({dynamic item,int index}) async {

    File f = await faf.localfile;
    List l = notesList;
    l.insert(index, item);
    f = await f.writeAsString(jsonEncode(l));
    return l;
  }

  Future<List> _removeItem(int index) async {

    File f = await faf.localfile;
    List l = notesList;
    l.removeAt(index);
    f = await f.writeAsString(jsonEncode(l));
    return l;

  }

  Future<void> _navigateToNoteData(int index,BuildContext context) async{
    final s = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context)=> new NoteData.addData(notesList[index],index),
      )
    );

    print(s);

    // if()
    setState(() {
      notesList = s;
    });
  }
  
  void _noteDismiss(int index,BuildContext context){
    var item = notesList[index];
    print("index= $index");
    _removeItem(index).then((List l){
      print(l);
      setState(() {
        notesList = l;
      });
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: new Text(
          "Note Removed",
          style: new TextStyle(
            color: defaultSnackBarColor,
          ),
        ),
        duration: DefaultSneakBarDuration,
        action: SnackBarAction(
          label: "UNDO",
          onPressed: (){
              _addItem(
                index: index,
                item: item
              ).then((List l){
                setState(() {
                  notesList = l;
                });
              }).catchError((e)=>print(e));
          },
        ),
      ));
    }).catchError((e)=>print(e));
  }

  //Not Used yet.

  _navigateToNewNote(BuildContext context) async{
    
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewNote()),
    );

    // return notesList;

    // Scaffold.of(widget.context)
    //   ..hideCurrentSnackBar()
    //   ..showSnackBar(new SnackBar(
    //     content: Text("Saved")
    //   ));

    // print("f = $f");


    // return list;

  }

  Future<void> _refreshNotes() async {

    await Future.delayed(Duration(seconds: 2));

    getDataFromJSON().then( (String data) {
      print(data);
      setState( () {
        print("Data: ");
        print(data.length);
        if (data.length > 0){
          notesList = jsonDecode(data);
        }
      });
    }).catchError((e){
      print(e);
    });
  }

  Widget notesTemplete(BuildContext context,int index){
    return new Dismissible(
      key: new Key(notesList[index]["id"]),
      background: new Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20.0),
          color: Colors.red,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
      ),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(15.0),
                  child: new CircleAvatar(
                    child: new Text("${notesList[index]["title"]==""? "N":notesList[index]["title"][0]}".toUpperCase(),style: new TextStyle(color: Colors.white)),
                    backgroundColor: Colors.green,
                  ),
                ),
                new Expanded(
                  child: new InkWell(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text("${notesList[index]["title"]}",
                          style: new TextStyle(
                            // decoration: TextDecoration.underline,
                            fontSize: 17
                          ),
                        ),
                        new Padding(padding: EdgeInsets.only(top: 7.0),),
                        new Text("${notesList[index]["note"]}",
                          // overflow: TextOverflow.fade,
                          style: new TextStyle(
                            color: Color.fromRGBO(44, 44, 44, 0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    onTap: () => _navigateToNoteData(index,context).catchError((e) => print(e)),
                  ),
                ),
              ],
            ),
          new Divider(),
        ]
      ),
      onDismissed: (direction){
        _noteDismiss(index,context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // List l = new List.generate(notesList.length, (int index){return index;});

    Widget w;

    if(notesList.length > 0){
      w = new ListView.builder(
          itemCount: notesList.length,
          itemBuilder: (context,int index){
            return notesTemplete(context, index);
          },
        );
    } else {
      w = new ListView.builder(
        itemCount: 1,
        itemBuilder: (context,int index){
          return new Padding(
            padding: EdgeInsets.only(top: 30),
            child: new Center(
              child: new Text(
                "No Notes Found.",
                style: new TextStyle(
                  color: acknowledgementTextColor,
                  fontSize: 20.0,
                ),
              ),
            ),
          );
        },
      );

      
      //Can be Viewed Some times.

      /*w = new Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Text("No Notes found.",
                    style: new TextStyle(
                      color: acknowledgementTextColor,
                      fontSize: 20.0,
                    ),
                  ),
                  new Padding(padding: EdgeInsets.only(top: 30),),
                  new Text("Add Note",
                    style: new TextStyle(
                      color: acknowledgementTextColor,
                    )
                  ),
                  new Padding(padding: EdgeInsets.only(top: 10,)),
                  new CircleAvatar(
                    child: new IconButton(
                      icon: new Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      color: Colors.white,
                      iconSize: 30.0,
                      onPressed: (){
                        _navigateToNewNote(context);
                        // then((List l){
                        //   if(l != null){
                        //     setState(() {
                        //       notesList = l; 
                        //     });
                        //   }
                        // }).catchError((e) => print(e));
                      },
                    ),
                    backgroundColor: Colors.green,
                    maxRadius: 30,
                    minRadius: 30,
                  ),
                ],
              ),
          ),
          ],
        );*/
    }
    
    return new RefreshIndicator(
      onRefresh: _refreshNotes,
      child: w,
    );
  }
}ist.length,
          itemBuilder: (context,int index){
            return notesTemplete(context, index);
          },
        ),
      );
    } else {
      return new RefreshIndicator(
        onRefresh: _refreshNotes,
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text("No Notes found.",
                style: new TextStyle(
                  color: acknowledgementTextColor,
                  fontSize: 20.0,
                ),
              ),
              new Padding(padding: EdgeInsets.only(top: 30),),
              new Text("Add Note",
                style: new TextStyle(
                  color: acknowledgementTextColor,
                )
              ),
              new Padding(padding: EdgeInsets.only(top: 10,)),
              new CircleAvatar(
                child: new IconButton(
                  icon: new Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  color: Colors.white,
                  iconSize: 30.0,
                  onPressed: (){
                    _navigateToNewNote(context);
                    // then((List l){
                    //   if(l != null){
                    //     setState(() {
                    //       notesList = l; 
                    //     });
                    //   }
                    // }).catchError((e) => print(e));
                  },
                ),
                backgroundColor: Colors.green,
                maxRadius: 30,
                minRadius: 30,
              ),
            ],
          ),
        ),
      );
    }
  }
}