// Flutter Packages
import 'package:flutter/material.dart';

//App Packages
import './createNote.dart';
import "../globals/constants.dart";
import '../globals/notesData.dart';

class ShowData extends StatefulWidget {

  ShowData();

  @override
  _ShowDataState createState() => _ShowDataState();

}

class _ShowDataState extends State<ShowData> {

  final globalKey = GlobalKey<ScaffoldState>();


  Future<void> _navigateToCreateNote(BuildContext context) async{
    OldEditAcknowledgement.setTrue();
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CreateNote(),
      )
    );
    OldEditAcknowledgement.setFalse();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: globalKey,
        appBar: AppBar(
          backgroundColor: PredColor[int.parse(CurrentNote.color)],
          title: Text(CurrentNote.title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context,true);
            },
          ),
          actions: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: InkWell(
                  child: Text(
                    "Edit",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  onTap: (){
                    _navigateToCreateNote(context).catchError((e) => print(e));
                  },
                ),
              ),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: 1,
          itemBuilder: (context,index){
            return Container(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text(CurrentNote.note,
                      style: TextStyle(
                        color: acknowledgementTextColor,
                        fontSize: 20.0,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 70.0),),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Created On ${CurrentNote.created}",
                          style: TextStyle(
                            color: acknowledgementTextColor,
                            fontSize: 11,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 7.0),),
                        Text(
                          "Last Edited On ${CurrentNote.lastModified}",
                          style: TextStyle(
                            color: acknowledgementTextColor,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            );
          },
        ),
      ),
      onWillPop: () async {
        Navigator.pop(context,true);
        return false;
      },
    );
  }
}