import 'package:flutter/material.dart';
import 'package:notes/createNewNote.dart';

import "./appConst.dart";

class NoteData extends StatefulWidget {

  dynamic item;
  int index;

  NoteData();

  NoteData.addData(this.item,this.index);

  @override
  _NoteDataState createState() => _NoteDataState();

}

class _NoteDataState extends State<NoteData> {

  final globalKey = GlobalKey<ScaffoldState>();


  Future<void> _navigateToNewNotes(BuildContext context) async{
    final f = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context){
          return new NewNote.setOld(widget.item,widget.index);
        },
      )
    );

    print("f = $f");
    if(f != null){
      setState((){
        widget.item = f[widget.index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: globalKey,
      appBar: new AppBar(
        title: new Text(widget.item["title"]),
        actions: <Widget>[
          new Center(
            child: new Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: new InkWell(
                child: new Text(
                  "Edit",
                  style: new TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                onTap: (){
                  _navigateToNewNotes(context).catchError((e) => print(e));
                },
              ),
            ),
          ),
        ],
      ),
      body: new Container(
        child: new Padding(
          padding: EdgeInsets.all(20.0),
          child: new Column(
            children: <Widget>[
              new Text(widget.item["note"],
                style: new TextStyle(
                  color: acknowledgementTextColor,
                  fontSize: 20.0,
                ),
              ),
              new Padding(padding: EdgeInsets.only(bottom: 70.0),),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    "Created On ${widget.item["created"]}",
                    style: new TextStyle(
                      color: acknowledgementTextColor,
                      fontSize: 11,
                    ),
                  ),
                  new Padding(padding: EdgeInsets.only(bottom: 7.0),),
                  new Text(
                    "Last Edited On ${widget.item["last_modified"]}",
                    style: new TextStyle(
                      color: acknowledgementTextColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      )
    );
  }
}