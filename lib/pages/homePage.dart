//Dart packages

//Flutter Packages
import "package:flutter/material.dart";
import 'package:notes/globals/notesData.dart';

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

  @override
  void initState() {
    super.initState();

    JSONFetch.getDataFromJSON().then( (List data) async {
      if (data.length > 0){
        NotesList.setList(data);
        if(NotesList.getNoteAt(0).length == 5){
          for (int i=0;i<NotesList.getLength();i++) {
            NotesList.changeBlock(i, "color", "0");
          }
          await NotesList.saveList();
        }
      }
      setState((){});
    }).catchError((e){
      print(e);
    });
  }

  Future<bool> _addItem({dynamic item,int index}) async {

    NotesList.addNote(index, item);
    return NotesList.saveList();
  }

  Future<bool> _removeItem(int index) async {

    NotesList.removeNote(index);
    return NotesList.saveList();
  }

  Future<void> _navigateToShowData(int index,BuildContext context) async{
    CurrentNote.setNote(NotesList.getNoteAt(index), index);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context)=> ShowData(),
      )
    );
    setState((){});
  }
  
  void _noteDismiss(int index,BuildContext context){
    var item = NotesList.getNoteAt(index);

    print("index= $index");

    _removeItem(index).then((bool saved){
      // print(saved);
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

  _navigateToCreateNote(BuildContext context) async{
    
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateNote()
      ),
    );
    OldEditAcknowledgement.setFalse();
    setState( (){});
  }

  // Sample template of a single note which is used to create a list of notes
  Widget notesTemplete(BuildContext context,int index){
    Map currentNote = NotesList.getNoteAt(index);

    return Dismissible(
      key: Key(currentNote["id"]), 
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Container(
        color: PredColor[int.parse(currentNote["color"])],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // SizedBox(height: 4.0,),
            Container(
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
                            "${currentNote["title"]==""? "0":currentNote["title"][0]}".toUpperCase(),
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
                              "${currentNote["title"]}",
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
                              "${currentNote["note"]}",
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
                    _navigateToShowData(index,context).catchError((e) => print(e));
                  },
                ),
              ),
            ),
            // SizedBox(height: 2.0,),
            Divider(),
          ],
        ),
      ),
    onDismissed: (direction){
        _noteDismiss(index,context);
      },
    );
  }

  Widget _notesData(BuildContext context) {
    
    if(NotesList.getLength() > 0){
      return ListView.builder(
          itemCount: NotesList.getLength(),
          // reverse: true,
          itemBuilder: (context,int index){
            return notesTemplete(context, index);
          },
        );
    } else {
      return ListView.builder(
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        scrollDirection: Axis.vertical,
        headerSliverBuilder: (context, isTrue){
          return [
            SliverAppBar(
              expandedHeight: 100,
              floating: true,
              pinned: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  iconSize: 30.0,
                  padding: EdgeInsets.only(right: 10),
                  onPressed: (){
                    _navigateToCreateNote(context);
                  },
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text("Notes"),
                titlePadding: EdgeInsets.only(left: 20,bottom: 20),
              ),
            ),
          ];
        },
        body: _notesData(context),
      ),
    );
  }
}