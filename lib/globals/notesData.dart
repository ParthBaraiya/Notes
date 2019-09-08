//Dart Package
import 'dart:convert';
import 'dart:io';

//App Package
import 'package:notes/globals/jsonFetch.dart';

class OldEditAcknowledgement{
  static bool _isEditing = false;
  static void setTrue(){
    _isEditing = true;
  }
  static void setFalse(){
    _isEditing = false;
  }
  static bool getAck(){
    return _isEditing;
  }
}

class CurrentNote{
  static String id;
  static String title;
  static String note;
  static String lastModified;
  static String created;
  static String color = "0";
  static int index;

  CurrentNote.setNote(Map item,int noteIndex){
    id = item["id"];
    title = item["title"];
    note = item["note"];
    lastModified = item["last_modified"];
    created = item["created"];
    color = item["color"];
    index = noteIndex;
  }
}


class NotesList{
  static List _notesList = [];
  static int getLength(){
    return _notesList.length;
  }

  static void setList(List list){
    _notesList = list;
  }

  static Map getNoteAt(int index){
    return _notesList[index];
  }
  static List getList(){
    return _notesList;
  }
  static void addNote(int index,Map map){
    _notesList.insert(index,map);
  }
  static void removeNote(int index){
    _notesList.removeAt(index);
  }

  static addBlock(int index,String name,String value){
    _notesList[index][name] = value;
  }

  static void changeBlock(int index,String type,String value){
    if(
      type == "id" || 
      type == "title" || 
      type == "note" || 
      type== "last_modified" || 
      type == "created" || 
      type == "color") {

      _notesList[index][type] = value;
    
    }
  }

  static Future<bool> saveList() async {
    File f = await JSONFetch.localfile;

    f = await f.writeAsString(jsonEncode(NotesList.getList())).catchError((e){
      return null;
    });

    if(f == null) return false;
    else return true;
  }

}