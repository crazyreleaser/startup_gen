import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:startup_gen/globals.dart';

class favWords {
  final int? id;
  final String words;

  favWords({
    this.id,
    required this.words
  });
  favWords.fromMap(Map<String, dynamic> res)
   : id = res["id"],
     words = res["words"];
  Map<String, Object?> toMap() {
    return {'id': id, 'words': words};
  }
}

class database extends dbBase {//____________________________________________________singleton________________
  static final database _instance = database._internal();
  factory database() {
    return _instance;
  }
  database._internal() {
    initialText = "A new 'db' instance has been created";
    stateText = initialText;
    print(stateText);
  }
//____________________________________________________singleton________________
}

abstract class dbBase {
  //____________________________________________________singleton________________
  @protected
  String initialText = 'initial text in base class';
  @protected
  String stateText = 'state text in base class';
  String get currentText => stateText;
  void setStateText(String text) {
    stateText = text;
  }
  void resetText(){
    stateText = initialText;
  }
//____________________________________________________singleton________________

  Future<Database> openDB() async {
    print('DB open Function');
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'exam.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE favwords(id INTEGER PRIMARY KEY AUTOINCREMENT, words TEXT NOT NULL)",
          // "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,age INTEGER NOT NULL, country TEXT NOT NULL, email TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<int> addWords(favWords words) async {
    int result = 0;
    final Database db = await openDB();
    result = await db.insert('favwords', words.toMap());
    print('save db : ' + words.words);
    return result;
  }

  Future<List<favWords>> retrieveWords() async {
    final Database db = await openDB();
    final List<Map<String, Object?>> queryResult = await db.query('favwords');
    print('from db :');
    queryResult.map((e) => favWords.fromMap(e)).toList().forEach((element) {print(element.words);});
    queryResult.map((e) => favWords.fromMap(e)).toList().forEach((element) {GlobalData.saved.add(element.words);});
    return queryResult.map((e) => favWords.fromMap(e)).toList();
  }

  Future<int> deleteWords(String words) async {
    int result = 0;
    final db = await openDB();
    result  = await db.delete(
      'favwords',
      where: "words = ?",
      whereArgs: [words],
    );
    return result;
  }

}