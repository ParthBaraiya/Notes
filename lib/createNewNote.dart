//Dart Packages
import 'dart:convert';
import 'dart:io';
// import "dart:async";


//Flutter Packages
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
// import 'package:notes/bodyNotes.dart';
import 'package:notes/main.dart';

//App Packages
// import "./appConst.dart";
import "./jsonFetch.dart";

class NewNote extends StatefulWidget {

  dynamic item;
  bool isOld = false;
  int index;

  NewNote();

  NewNote.setOld(this.item,this.index){
    isOld = true;
  }

  @override
  _NewNoteState createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController(text: "");

  final titleNode = new FocusNode();
  final notesNode = new FocusNode();

  @override
  void dispose(){
      
      titleController.dispose();
      notesController.dispose();
      titleNode.dispose();
      notesNode.dispose();

      super.dispose();

  }

  Future<bool> _saveData({BuildContext context}) async{
    GetFilesAndFolder faf = new GetFilesAndFolder();

    File f = await faf.localfile;

    // print("1");

    String s = await f.readAsString();

    dynamic stored = [];

    if(s.length > 0){
      stored = jsonDecode(s);
    }

    // print("2");
    var date = new DateTime.now();

    // print("Done");

    // dynamic list;

    // var formatter = new DateFormat('dd-MM-yyyy');
    if(widget.isOld == true){
        stored[widget.index]["title"] = titleController.text;
        stored[widget.index]["note"] = notesController.text;
        stored[widget.index]["last_modified"] = date.day.toString()+"-"+date.month.toString()+"-"+date.year.toString();
    } else {
      dynamic list = {
        "id": stored.length,
        "title": titleController.text,
        "note": notesController.text,
        "last_modified": date.day.toString()+"-"+date.month.toString()+"-"+date.year.toString(),
        "created": date.day.toString()+"-"+date.month.toString()+"-"+date.year.toString(),
      };
      stored.add(list);
    }

    f = await f.writeAsString(jsonEncode(stored));

    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context){
          return new NotesData();
        },
      )
    );

    return true;

  } 

  Widget _bodyWidget(BuildContext context) {

    titleController.text = (widget.isOld == false)? "" : widget.item["title"];
    notesController.text = (widget.isOld == false)? "" : widget.item["note"];

    return new Container(
      padding: EdgeInsets.all(10.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new TextField(
            keyboardType: TextInputType.text,
            focusNode: titleNode,
            autofocus: true,
            controller: titleController,
            maxLength: 50,
            minLines: 1,
            readOnly: false,
            decoration: new InputDecoration(
              hintText: "title",
              contentPadding: EdgeInsets.all(10.0),
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(bottom: 20.0)
          ),
          new TextField(
            controller: notesController,
            focusNode: notesNode,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 50,
            readOnly: false,
            decoration: new InputDecoration(
              hintText: "Enter notes here...",
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(10.0),
              disabledBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
            ),
            // onTap: (){},
          ),
        ],
      ),
    );
  }

  final keyGlobal = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context){
    
    return Scaffold(
      key: keyGlobal,
      appBar: new AppBar(
        title: new Text(
          widget.isOld == true? "Edit Note":"Create Note",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(right: 12),
                child: new GestureDetector(
                  child: new Text(
                    "Save",
                    style: new TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  onTap: (){
                    // keyGlobal.currentState.hideSnackBar();
                    // keyGlobal.currentState.showSnackBar(new SnackBar(
                    //   content: new Text("Data Saved"),
                    // ));
              
                    _saveData(context: context).then((bool d) => print("Saved")).catchError((e)=>print(e));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: _bodyWidget(context),
    );
  }
}