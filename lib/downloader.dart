
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:startup_gen/globals.dart';
import 'package:permission_handler/permission_handler.dart';

class Downloader {
  static Future<String> createPaths() async {
    if(GlobalData.bgPath == ''){                                                // для вызова только 1 раз при запуске
      if (Platform.isAndroid) {
        PermissionStatus _permissionStatus = await Permission.storage.status;
        if (_permissionStatus != PermissionStatus.granted) {
          PermissionStatus permissionStatus= await Permission.storage.request();
          _permissionStatus = permissionStatus;
          print('Permition status: '+ permissionStatus.toString());
        }
        final documentDirectory = await getApplicationDocumentsDirectory();
        GlobalData.bgPath = File(join(documentDirectory.path, GlobalData.bgname)).path;
        print ('Android Directory : ' + GlobalData.bgPath);
      } else {
        final documentDirectory = await getApplicationDocumentsDirectory();
        GlobalData.bgPath = File(join(documentDirectory.path, GlobalData.bgname)).path;
        print ('Ios Directory : ' + GlobalData.bgPath);
      }
      if(Downloader.checkBGexist()) {
        GlobalData.bgImage = FileImage(File(GlobalData.bgPath));
      } else {
        GlobalData.bgImage = AssetImage('assets/images/bg.jpg');
      };
    }
    return GlobalData.bgPath;
  }
  static Future<File> downloadImage(String width, String height) async {
    if(GlobalData.isBGdownloaded) {
      final file = File(GlobalData.bgPath);
      return file;
    } else {
      final response = await http.get(Uri.parse('https://picsum.photos/'+width+'/'+height+'.jpg'));
      final file = File(GlobalData.bgPath);
      file.writeAsBytesSync(response.bodyBytes);
      GlobalData.isBGdownloaded = true;
      return file;
    }
  }
  static checkBGexist()  {
    print ('Cheking ' + GlobalData.bgPath);
    return File(GlobalData.bgPath).existsSync();
  }
}


