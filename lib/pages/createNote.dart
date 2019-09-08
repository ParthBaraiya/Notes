//Dart Packages

//Flutter Packages
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/globals/constants.dart';
import 'package:notes/globals/notesData.dart';
import 'package:notes/pages/showData.dart';

//App Packages
import '../globals/notesData.dart';



class CreateNote extends StatefulWidget {

  @override
  _CreateNoteState createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final titleNode = FocusNode();
  final notesNode = FocusNode();

  int selectedColor = 0;

  @override
  void initState(){
    super.initState();

    titleController.text = (!(OldEditAcknowledgement.getAck()))? "" : CurrentNote.title;
    notesController.text = (!(OldEditAcknowledgement.getAck()))? "" : CurrentNote.note;
    selectedColor = (OldEditAcknowledgement.getAck() == true)?int.parse(CurrentNote.color):0;
  }

  @override
  void dispose(){
      
      titleController.dispose();
      notesController.dispose();
      titleNode.dispose();
      notesNode.dispose();

      super.dispose();

  }

  Future<List> _saveData({BuildContext context}) async{

    var date = DateTime.now();
    int index;
    
    if(OldEditAcknowledgement.getAck()){
      print("Is Old");
      NotesList.changeBlock(CurrentNote.index, "title", titleController.text);
      NotesList.changeBlock(CurrentNote.index,"note",notesController.text);
      NotesList.changeBlock(CurrentNote.index, "last_modified",date.day.toString()+"-"+date.month.toString()+"-"+date.year.toString());  
      NotesList.changeBlock(CurrentNote.index, "color", "$selectedColor");
      index = CurrentNote.index;
      CurrentNote.setNote(NotesList.getNoteAt(index), index);
    } else {
      dynamic newItem = {
        "id": "${(NotesList.getLength() == 0)? 1:int.parse(NotesList.getNoteAt(0)["id"])+1}",
        "title": titleController.text,
        "note": notesController.text,
        "last_modified": date.day.toString()+"-"+date.month.toString()+"-"+date.year.toString(),
        "created": date.day.toString()+"-"+date.month.toString()+"-"+date.year.toString(),
        "color": "$selectedColor"
      };
      NotesList.addNote(0, newItem);
      CurrentNote.setNote(newItem, 0);
    }
    
    bool ack;

    await NotesList.saveList().then((bool b){
      ack = b;
    });
    
    return [ack,index];

  } 

  Widget _bodyWidget(BuildContext context) {

    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context,index){
        return Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.text,
                enableInteractiveSelection: true,
                focusNode: titleNode,
                // autofocus: true,
                controller: titleController,
                maxLength: 50,
                minLines: 1,
                readOnly: false,
                onChanged: (String s){
                  CurrentNote.title = s;
                },
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

                onChanged: (String s){
                  CurrentNote.note = s;
                },
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
    );
  }

  final keyGlobal = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      child: Scaffold(
        key: keyGlobal,
        appBar: AppBar(
          backgroundColor: PredColor[selectedColor],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              OldEditAcknowledgement.setFalse();
              Navigator.pop(context,false);
            },
          ),
          title: Text(
            (OldEditAcknowledgement.getAck())? "Edit Note":"Create Note",
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
                          OldEditAcknowledgement.setFalse();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => ShowData(),
                            ),
                          );
                        }).catchError((e)=>print(e));
                      } else {
                        keyGlobal.currentState
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(
                          content: Text("Please Enter Note"),
                        ));
                      }
                    } else {
                      keyGlobal.currentState
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: Text("Please Enter Title"),
                      ));
                    }
                  },
                ),
              ),
            ],
          ),
        ],
        ),
        body: _bodyWidget(context),
        bottomNavigationBar: BottomNavigationBar(
          items: _colorBar(context),
          currentIndex: selectedColor,
          type: BottomNavigationBarType.shifting,
          onTap: (int index){
            setState(() {
              selectedColor = index;              
            });
          },
        ),
      ),
      onWillPop: () async {
        // print("poped");
        Navigator.pop(context,false); 
        return false;
      },
    );
  }
  List<BottomNavigationBarItem> _colorBar(BuildContext context){
    List<BottomNavigationBarItem> l = [];
    for(int i=0;i<PredColor.length;i++){
      l.add(BottomNavigationBarItem(
        icon: Icon(
          Icons.check_circle,
            color: PredColor[i],
            size: 30.0,
          ),
        title: Text(""),
      ));
    }
    return l;
  }
}