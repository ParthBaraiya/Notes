//Dart Packages
import 'dart:convert';
import 'dart:io';

//Flutter Packages
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/pages/showData.dart';

//App Packages
import "../globals/jsonFetch.dart";



class CreateNote extends StatefulWidget {

  dynamic item;
  bool isOld = false;
  int index;

  CreateNote();

  CreateNote.setData(this.item,this.index){
    isOld = true;
  }

  @override
  _CreateNoteState createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final titleNode = FocusNode();
  final notesNode = FocusNode();

  dynamic newItem;

  @override
  void dispose(){
      
      titleController.dispose();
      notesController.dispose();
      titleNode.dispose();
      notesNode.dispose();

      super.dispose();

  }

  Future<List> _saveData({BuildContext context}) async{
    File f = await JSONFetch.localfile;
    
    String s = await f.readAsString().catchError((e){
      return "false";
    });

    if(s == "false"){
      return [false];
    }

    dynamic stored = [];
    
    if(s.length > 2){
      stored = jsonDecode(s);
    }

    var date = DateTime.now();
    int index;
    
    if(widget.isOld == true){
      print("Is Old");
      stored[widget.index]["title"] = titleController.text;
      stored[widget.index]["note"] = notesController.text;
      stored[widget.index]["last_modified"] = date.day.toString()+"-"+date.month.toString()+"-"+date.year.toString();  
      newItem = stored[widget.index];
      index = widget.index;
    } else {
      newItem = {
        "id": "${(stored.length == 0)? 1:int.parse(stored[stored.length-1]["id"])+1}",
        "title": titleController.text,
        "note": notesController.text,
        "last_modified": date.day.toString()+"-"+date.month.toString()+"-"+date.year.toString(),
        "created": date.day.toString()+"-"+date.month.toString()+"-"+date.year.toString(),
      };
      stored.add(newItem);
      index = stored.length -1;
    }
    
    f = await f.writeAsString(jsonEncode(stored)).catchError((e){
      return null;
    });
    
    if(f != null){
      return [true,newItem,index];
    } else {
      return [false];
    }

  } 

  Widget _bodyWidget(BuildContext context) {

    titleController.text = (widget.isOld == false)? "" : widget.item["title"];
    notesController.text = (widget.isOld == false)? "" : widget.item["note"];

    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.text,
            focusNode: titleNode,
            autofocus: true,
            controller: titleController,
            maxLength: 50,
            minLines: 1,
            readOnly: false,
            decoration: InputDecoration(
              hintText: "title",
              contentPadding: EdgeInsets.all(10.0),
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0)
          ),
          TextField(
            controller: notesController,
            focusNode: notesNode,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 50,
            readOnly: false,
            decoration: InputDecoration(
              hintText: "Enter notes here...",
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(10.0),
              disabledBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  final keyGlobal = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      child: Scaffold(
        key: keyGlobal,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context,false);
            },
          ),
          title: Text(
            widget.isOld == true? "Edit Note":"Create Note",
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 12),
                child: GestureDetector(
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  onTap: (){
                    if(titleController.text != ""){
                      if(notesController.text != ""){
                        _saveData(context: context).then((List saved) { 
                          
                          print("Saved");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => ShowData.addData(
                                item: saved[1],
                                index: saved[2]
                              ),
                            ),
                          );

                        }).catchError((e)=>print(e));
                      } else {
                        keyGlobal.currentState
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(
                          content: new Text("Please Enter Note"),
                        ));
                        notesNode.requestFocus();
                      }
                    } else {
                      keyGlobal.currentState
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: new Text("Please Enter Title"),
                      ));
                      titleNode.requestFocus();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
        ),
        body: _bodyWidget(context),
      ),
      onWillPop: () async {
        Navigator.pop(context,false);
        
        return false;
      },
    );
  }
}

// class NewNoteMethod{

// }