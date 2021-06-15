import 'package:flutter/material.dart';
import 'package:russian_words/russian_words.dart';
import 'package:startup_gen/globals.dart';
import 'package:startup_gen/downloader.dart';
import 'package:flutter/widgets.dart';                                          // for database
import 'package:startup_gen/DB.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    GlobalData.db.openDB().whenComplete(() {
      print('DB initialized');
    });
    GlobalData.db.retrieveWords();
  }
    Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'Startup Name Generator',
      home: RandomWords(),
      theme: ThemeData (
        primaryColor: Colors.green,
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
    Widget build(BuildContext context) {
      // final bgImage;
      double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;
      print (width.toInt().toString() + 'x' + height.toInt().toString());
      Downloader.downloadImage(width.toInt().toString(),height.toInt().toString());
      return FutureBuilder<String>(
          future: Downloader.createPaths(),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              // return Text(snapshot.data);
              print ('Main widget');
              return Scaffold(
                appBar: AppBar(
                  title: Text('Startup Name Generator'),
                  actions: [
                    IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
                  ],
                ),
                body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: GlobalData.bgImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: _buildSuggestions(),
                ),
              );
            } else {
              print ('Circle Progress');
              return CircularProgressIndicator();
            }
          }
      );
    }
    void _pushSaved() {                                                         // переход на другой экран
      Navigator.push(
          this.context,
          MaterialPageRoute(builder: (context) => FavWordPairs()),
      ).then((value) => setState(() {}));                                       // setState обновляет контент после возвращения на этот экран
                                      // Navigator.push(context,
                                      //   MaterialPageRoute<void>(
                                      //     // NEW lines from here...
                                      //     builder: (BuildContext context) {
                                      //       final tiles = _saved.map(
                                      //             (WordPair pair) {
                                      //           return ListTile(
                                      //             title: Text(
                                      //               pair.asPascalCase,
                                      //               style: _biggerFont,
                                      //             ),
                                      //           );
                                      //         },
                                      //       );
                                      //       final divided = tiles.isNotEmpty
                                      //           ? ListTile.divideTiles(context: context, tiles: tiles).toList()
                                      //           : <Widget>[];
                                      //       return Scaffold(
                                      //         appBar: AppBar(
                                      //           title: Text('Saved Suggestions'),
                                      //         ),
                                      //         body: ListView(children: divided),
                                      //       );
                                      //     }, // ...to here.
                                      //   ),
                                      // );
    }
    Widget _buildSuggestions() {
      return ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            if (i.isOdd) return Divider();
            final index = i ~/ 2;
            if (index >= GlobalData.suggestions.length) {
              generateWordPairs().take(10).forEach((element) {GlobalData.suggestions.add(element.asPascalCase.toString());});
            }
            return _buildRow(index, GlobalData.suggestions[index]);
          });
    }
    Widget _buildRow(index, String pair) {
      final alreadySaved = GlobalData.saved.contains(pair);
      return Opacity(
        opacity: 1,
        child: ListTile(
          title: Text(
            index.toString() +' '+ pair,
            style: GlobalData.biggerFont,
          ),
          trailing: Icon(
            alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null,
          ),
          onTap: () {
            alreadySaved ? print('Delete $pair') : print('Save $pair');
            setState(() {
              if (alreadySaved) {
                GlobalData.saved.remove(pair);
                GlobalData.db.deleteWords(pair);
              } else {
                GlobalData.saved.add(pair);
                GlobalData.db.addWords(favWords(words: pair));
                GlobalData.db.retrieveWords();
              }
            });
          },
        ),
      );
    }
}

class FavWordPairs extends StatefulWidget {
  @override
  _FavWordState createState() => _FavWordState();
}
class _FavWordState extends State<FavWordPairs> {
  @override
  Widget build(BuildContext context) {
    final tiles = GlobalData.saved.map(
          (String pair) {
        return ListTile(
          title: Text(
            pair,
            style: GlobalData.biggerFont,
          ),
          trailing: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
          onTap: () {
            print('Delete $pair');
            setState(() {
              GlobalData.saved.remove(pair);
              GlobalData.db.deleteWords(pair);
            });
          },
        );
      },
    );
    final divided = tiles.isNotEmpty
        ? ListTile.divideTiles(context: context, tiles: tiles).toList()
        : <Widget>[];
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Suggestions'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: GlobalData.bgImage,
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(children: divided),
      ),
    );
  }
}
