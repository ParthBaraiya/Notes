import "dart:io";

import "package:path_provider/path_provider.dart";
import './appConst.dart';


class GetFilesAndFolder {

  Future<String> get localpath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get localfile async {
    final path = await localpath;
    File f = File("$path/$fileName");
    if(f.existsSync() == false){
      f = await f.create();
    }
    return f;
  }
}