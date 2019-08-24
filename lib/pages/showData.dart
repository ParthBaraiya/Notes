// Flutter Packages
import 'package:flutter/material.dart';

//App Packages
import './createNote.dart';
import "../globals/constants.dart";

class ShowData extends StatefulWidget {

  dynamic item;
  int index;

  ShowData();

  ShowData.addData({@required dynamic item,int index}){
    this.item = item;
    this.index = index;
  }

  @override
  _ShowDataState createState() => _ShowDataState();

}

class _ShowDataState extends State<ShowData> {

  final globalKey = GlobalKey<ScaffoldState>();


  Future<void> _navigateToCreateNote(BuildContext context) async{
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context){
          return CreateNote.setData(widget.item,widget.index);
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: globalKey,
        appBar: AppBar(
          title: Text(widget.item["title"]),
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
                    Text(widget.item["note"],
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
                          "Created On ${widget.item["created"]}",
                          style: TextStyle(
                            color: acknowledgementTextColor,
                            fontSize: 11,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 7.0),),
                        Text(
                          "Last Edited On ${widget.item["last_modified"]}",
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