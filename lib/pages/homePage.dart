//Dart packages
import 'dart:io';
import "dart:convert";

//Flutter Packages
import "package:flutter/material.dart";

//App Packages
import "../globals/constants.dart";
import "./showData.dart";
import "../globals/jsonFetch.dart";
import './createNote.dart';


class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  dynamic notesList = [];

  @override
  void initState(){
    super.initState();

    JSONFetch.getDataFromJSON().then( (List data) {
      print("Data: $data");
      setState( (){
        print("Data-length: ${data.length}");
        if (data.length > 0){
          notesList = data;
        }
      });
    }).catchError((e){
      print(e);
    });
  }

  Future<bool> _addItem({dynamic item,int index}) async {

    File f = await JSONFetch.localfile;
    notesList.insert(index, item);
    f = await f.writeAsString(jsonEncode(notesList)).catchError((e){
      return null;
    });
    if(f == null){
      return false;
    } else {
      return true;
    }
  }

  Future<bool> _removeItem(int index) async {

    File f = await JSONFetch.localfile;
    notesList.removeAt(index);
    f = await f.writeAsString(jsonEncode(notesList)).catchError((e){
      return null;
    });
    if(f == null){
      return false;
    } else {
      return true;
    }

  }

  Future<void> _navigateToShowData(int index,BuildContext context) async{
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context)=> ShowData.addData(
          item: notesList[index],
          index: index,
        ),
      )
    );

    print("NoteData-Result: $result");


    JSONFetch.getDataFromJSON().then( (List data) {
      print("Data: $data");
      print("Data-length: ${data.length}");
      setState( (){
        if (data.length > 0){
          notesList = data;
        }
      });
    }).catchError((e){
      print(e);
    });
  }
  
  void _noteDismiss(int index,BuildContext context){
    var item = notesList[index];

    print("index= $index");

    _removeItem(index).then((bool saved){
      print(saved);
      if (saved == true){
        setState(() {});
        Scaffold.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(
            "Note Removed",
            style: TextStyle(
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
              ).then((bool saved){
                if (saved == true){
                  setState(() {});
                } else {
                  Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text("Note can not be inserted"),
                  ));
                }
              }).catchError((e)=>print(e));
            },
          ),
        ));
      } else {
        Scaffold.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text("Note can not be removed"),
        ));
      }
    }).catchError((e) => print(e));
  }

  Future<void> _refreshNotes() async {

    await Future.delayed(Duration(seconds: 2));

    JSONFetch.getDataFromJSON().then( (List data) {
      print("FileData: $data");
      setState( (){
        print("Data: ${data.length}");
        if (data.length > 0){
          notesList = data;
        }
      });
    }).catchError((e){
      print(e);
    });
  }

  _navigateToCreateNote(BuildContext context) async{
    
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateNote()
      ),
    );

    print("NewNote-Result: $result");

    JSONFetch.getDataFromJSON().then( (List data) {
      print("Data: $data");
      setState( (){
        print("Data-length: ${data.length}");
        if (data.length > 0){
          notesList = data;
        }
      });
    }).catchError((e){
      print(e);
    });
  }

  // Sample template of a single note which is used to create a list of notes
  Widget notesTemplete(BuildContext context,int index){
    return Dismissible(
      key: Key(notesList[index]["id"]), 
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 4.0,),
          Container(
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(const Radius.circular(10.0)),
              color: Colors.white, 
              boxShadow: [BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
              ),],
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(15.0),
                      child: CircleAvatar(
                        child: Text(
                          "${notesList[index]["title"]==""? "0":notesList[index]["title"][0]}".toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${notesList[index]["title"]}",
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 7.0),),
                          Text(
                            "${notesList[index]["note"]}",
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            maxLines: 1,
                            style: TextStyle(
                              color: acknowledgementTextColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  // print("Tapped");
                  _navigateToShowData(index,context).catchError((e) => print(e));
                },
              ),
            ),
          ),
          SizedBox(height: 4.0,),
        ],
      ),
      onDismissed: (direction){
        _noteDismiss(index,context);
      },
    );
  }

  // Wrap data into RefreshIndicator
  Widget _notesData(BuildContext context) {

    Widget w;

    if(notesList.length > 0){
      w = ListView.builder(
          itemCount: notesList.length,
          itemBuilder: (context,int index){
            return notesTemplete(context, index);
          },
        );
    } else {
      w = ListView.builder(
        itemCount: 1,
        itemBuilder: (context,int index){
          return Padding(
            padding: EdgeInsets.only(top: 30),
            child: Center(
              child: Text(
                "No Notes Found.",
                style: TextStyle(
                  color: acknowledgementTextColor,
                  fontSize: 20.0,
                ),
              ),
            ),
          );
        },
      );
    }
    
    return RefreshIndicator(
      onRefresh: _refreshNotes,
      child: w,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              size: 30,
              color: defaultIconColor,
            ),
            padding: EdgeInsets.only(right: 10),
            onPressed: (){
              _navigateToCreateNote(context);
            },
          )
        ],
      ),
      body: _notesData(context),
    );
  }
}