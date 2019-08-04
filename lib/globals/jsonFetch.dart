//Dart Packages
import 'dart:convert';
import "dart:io";

//Path Provider Packages
import "package:path_provider/path_provider.dart";

//App Packages
import './constants.dart';


class JSONFetch {

  static Future<String> get localpath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  static Future<File> get localfile async {
    final path = await localpath;
    File f = File("$path/$fileName");
    if(f.existsSync() == false){
      f = await f.create();
    }
    return f;
  }

  static Future<List> getDataFromJSON() async{

    File f = await localfile;
    String data = await f.readAsString();
    return jsonDecode(data);
    
  }
}