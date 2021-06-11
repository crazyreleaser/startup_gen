import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:russian_words/russian_words.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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

// class User {
//   final int? id;
//   final String name;
//   final int age;
//   final String country;
//   final String? email;
//
//   User(
//       { this.id,
//         required this.name,
//         required this.age,
//         required this.country,
//         this.email});
//
//   User.fromMap(Map<String, dynamic> res)
//       : id = res["id"],
//         name = res["name"],
//         age = res["age"],
//         country = res["country"],
//         email = res["email"];
//
//   Map<String, Object?> toMap() {
//     return {'id':id,'name': name, 'age': age, 'country': country, 'email': email};
//   }
// }

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

  Future<Database> initDB() async {
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
    final Database db = await initDB();
    result = await db.insert('favwords', words.toMap());
    print('save db : ' + words.words);
    return result;
  }

  Future<List<favWords>> retrieveWords() async {
    final Database db = await initDB();
    final List<Map<String, Object?>> queryResult = await db.query('favwords');
    print('from db :');
    queryResult.map((e) => favWords.fromMap(e)).toList().forEach((element) {print(element.words);});
    return queryResult.map((e) => favWords.fromMap(e)).toList();
  }

  Future<void> deleteWords(String words) async {
    final db = await initDB();
    await db.delete(
      'favwords',
      where: "words = ?",
      whereArgs: [words],
    );
  }

}