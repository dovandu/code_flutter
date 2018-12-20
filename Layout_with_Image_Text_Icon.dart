// folder images: tutorialChannel.png
// pubspec.yaml: 
// assets:
//     - images/tutorialChannel.png




import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

//Define "root widget"
void main() => runApp(new MyApp());//one-line function
//StatefulWidget
class RandomEnglishWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RandomEnglishWordsState();//return a state's object. Where is the state's class ?
  }
}
//State
class RandomEnglishWordsState extends State<RandomEnglishWords>{
  final _words = <WordPair>[];//Words displayed in ListView, 1 row contains 1 word
  final _checkedWords = new Set<WordPair>();//set contains "no duplicate items"
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //Now we replace this with a Scaffold widget which contains a ListView
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("List of English words"),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list),
              onPressed: _pushToSavedWordsScreen)
        ],
      ),
      body: new ListView.builder(itemBuilder: (context, index) {
        //This is an anonymous function
        //index = 0, 1, 2, 3,...
        //This function return each Row = "a Widget"
        if (index >= _words.length) {
          _words.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_words[index], index);//Where is _buildRow ?
      }),
    );
  }
  _pushToSavedWordsScreen() {
//    print("You pressed to the right Icon");
    //To navigate, you must have a "route"
    final pageRoute = new MaterialPageRoute(builder: (context) {
      //map function = Convert this list to another list(maybe different object's type)
      //_checkedWords(list of WordPair) => map => 
      // converted to a lazy list(Iterable) of ListTile
      final listTiles = _checkedWords.map( (wordPair) {
        return new ListTile(
          title: new Text(wordPair.asUpperCase,
            style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
        );
      });
      //Now return a widget, we choose "Scaffold"
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Checked words"),
        ),
        body: new ListView(children: listTiles.toList(),),//Lazy list(Iterable) => List
      );
    });
    Navigator.of(context).push(pageRoute);
  }
  Widget _buildRow(WordPair wordPair, int index) {
    //This widget is for each row
    final textColor = index % 2 == 0 ? Colors.red : Colors.blue;
    final isChecked = _checkedWords.contains(wordPair);
    return new ListTile(
      //leading = left, trailing = right. Is is correct ? Not yet
      leading: new Icon(
          isChecked ? Icons.check_box : Icons.check_box_outline_blank,
          color: textColor,
      ),
      title: new Text(
        wordPair.asUpperCase,
        style: new TextStyle(fontSize: 18.0, color: textColor),
      ),
      onTap: () {
        setState(() {
          //This is an anonymous function
          if (isChecked) {
            _checkedWords.remove(wordPair);//Remove item in a Set
          } else {
            _checkedWords.add(wordPair);//Add item to a Set
          }
        });
      },
    );
  }
}

class MyApp extends StatelessWidget {
  //Stateless = immutable = cannot change object's properties
  //Every UI components are widgets
  @override
  Widget build(BuildContext context) {
    //build function returns a "Widget"
    return new MaterialApp(
      title: "This is my first Flutter App",
      home: new RandomEnglishWords()
    );//Widget with "Material design"
  }
}
