import 'package:flutter/material.dart';
import 'package:startup_gen/DB.dart';

class GlobalData {
  static database db = database();
  static final suggestions = <String>[];
  static final saved = <String>{};
  static bool isBGdownloaded = false;
  static final bgname = "bgnew.jpg";
  static String bgPath = '';
  static var bgImage;
  static final screenSize = [];
  static final biggerFont = TextStyle(fontSize: 18.0);
}