import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final wordPair = new WordPair.random();

    // return new MaterialApp(
    //   title: 'Welcome to Flutter',
    //   home: new Scaffold(
    //     appBar: new AppBar(
    //       title: new Text('Welcome to Flutter'),
    //     ),
    //     body: new Center(
    //       // child: new Text('Hello World'),
    //       // child: new Text(wordPair.asPascalCase),
    //       child: new RandomWords(),
    //     ),
    //   ),
    // );
    return new MaterialApp(
      title: 'Startup Name Genertor',
      theme: new ThemeData(
        primaryColor: Colors.red,
      ),
      home: new RandomWords(),
    );
  }
}


// 创建一个 有状态的wordRandomState widget
// 创建一个 无限滚动ListView

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

// 创建一个 无限滚动ListView 也是在
class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];

  final _saved = new Set<WordPair>();

  final _biggerFont = const TextStyle(fontSize: 18.0);
  void __pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map(
            (pair) => new ListTile(
             title: new Text(
               pair.asPascalCase,
               style: _biggerFont,
               ), 
            )
          );
          final divided = ListTile
            .divideTiles(
              context: context,
              tiles: tiles
            )
            .toList();
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided), 
          );
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    // final wordPair = new WordPair.random();
    // return new Text(wordPair.asPascalCase);
    return new Scaffold(
     appBar: new AppBar(
       title: new Text('Starup Name Generator'),
       actions: <Widget>[
         new IconButton(icon: new Icon(Icons.list), onPressed: __pushSaved,)
       ],
     ), 
     body: _buildSuggestions()
    );
  }
  
  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      }
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,        
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}

