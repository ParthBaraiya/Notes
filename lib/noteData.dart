import 'package:flutter/material.dart';
import 'package:notes/createNewNote.dart';

import "./appConst.dart";

class NoteData extends StatelessWidget {

  dynamic item;
  int index;

  NoteData();

  NoteData.addData(this.item,this.index);

  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: globalKey,
      appBar: new AppBar(
        title: new Text(item["title"]),
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
                  // globalKey.currentState.hideCurrentSnackBar();
                  // globalKey.currentState.showSnackBar(new SnackBar(
                  //   content: new Text("Editing..."),
                  //   duration: DefaultSneakBarDuration,
                  // ));

                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context){
                        return new NewNote.setOld(item,index);
                      },
                    )
                  );
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
              new Text(item["note"],
                style: new TextStyle(
                  color: acknowledgementTextColor,
                  fontSize: 20.0,
                ),
              ),
              new Padding(padding: EdgeInsets.only(bottom: 70.0),),
              new Text(
                "Last Edited On ${item["last_modified"]}",
                style: new TextStyle(
                  color: acknowledgementTextColor,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}