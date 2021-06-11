import 'package:flutter/material.dart';
// import 'package:english_words/english_words.dart';
import 'package:russian_words/russian_words.dart';

class GlobalData {
  static final suggestions = <WordPair>[];
  static final saved = <WordPair>{};
  static bool isBGdownloaded = false;
  static final bgname = "bgnew.jpg";
  static String bgPath = '';
  static var bgImage;
  static final screenSize = [];
  static final biggerFont = TextStyle(fontSize: 18.0);
}