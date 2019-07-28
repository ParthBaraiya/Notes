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

  Future<void> _addItem({dynamic item,int index}) async {

    File f = await faf.localfile;
    notesList.insert(index,item);
    f = await f.writeAsString(jsonEncode(notesList));
    
    setState(() {});
  
  }

  Future<void> _removeItem(int index) async {

    File f = await faf.localfile;

    notesList.removeAt(index);
    
    f = await f.writeAsString(jsonEncode(notesList));
    
    setState(() {});

  }

  void showLabel(String event,int index,{BuildContext context,}){
    if(event == "tapped"){
      // Scaffold.of(subContext).showSnackBar(SnackBar(
      //   content: new Text("Item ${index+1} tapped."),
      //   duration: DefaultSneakBarDuration,
      // ));
      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context)=> new NoteData.addData(notesList[index],index),
        )
      );
    } else if (event == "dismissed") {
      var item = notesList[index];
      _removeItem(index).then((a){
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
                ).catchError((e)=>print(e));
            },
          ),
        ));
      }).catchError((e)=>print(e));
    }
  }

  Widget notesTemplete(BuildContext context,int index){
    return new Dismissible(
      key: new Key(index.toString()),
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
                    child: new Text("${notesList[index]["title"][0]}".toUpperCase(),style: new TextStyle(color: Colors.white)),
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
                            decoration: TextDecoration.underline,
                            fontSize: 15,
                          ),
                        ),
                        new Padding(padding: EdgeInsets.only(top: 7.0),),
                        new Text("${notesList[index]["note"]}",
                          overflow: TextOverflow.clip,
                          style: new TextStyle(
                            color: Color.fromRGBO(44, 44, 44, 0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    onTap: () => showLabel("tapped", index, context: context),
                  ),
                ),
              ],
            ),
          new Divider(),
        ]
      ),
      onDismissed: (direction){
        showLabel("dismissed", index,context: context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if(notesList.length > 0){
      return new Container(
        child: new ListView.builder(
          itemCount: notesList.length,
          itemBuilder: (context,int index){
            return notesTemplete(context, index);
          },
        ),
      );
    } else {
      return new Container(
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
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (BuildContext context) => new NewNote(),
                      )
                    );
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