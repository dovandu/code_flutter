// ListView#2.Tạo một ListView kiểu ngang trong Flutter

import 'package:flutter/material.dart';

//Define "root widget"
void main() => runApp(new MyApp());//one-line function
class HorizonalList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new HorizonalListState();
  }
}
class HorizonalListState extends State<HorizonalList> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final screenSize=MediaQuery.of(context).size;
    return new Scaffold(
      body: new Container(
        child: new ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: <Widget>[
            new Container(
              width: screenSize.width,
              height: screenSize.height,
              color: Colors.red,
              child: new Center(
                child: new Text(
                  'Page 1',
                  style: new TextStyle(
                    fontSize: 40.0,
                    color: Colors.white
                  ),
                ),
              ),
            ),
            new Container(
              width: screenSize.width,
              height: screenSize.height,
              color: Colors.blue,
              child: new Center(
                child: new Text(
                  'Page 2',
                  style: new TextStyle(
                      fontSize: 40.0,
                      color: Colors.white
                  ),
                ),
              ),
            ),
            new Container(
              width: screenSize.width,
              height: screenSize.height,
              color: Colors.green,
              child: new Center(
                child: new Text(
                  'Page 3',
                  style: new TextStyle(
                      fontSize: 40.0,
                      color: Colors.white
                  ),
                ),
              ),
            ),
            new Container(
              width: screenSize.width,
              height: screenSize.height,
              color: Colors.pink,
              child: new Center(
                child: new Text(
                  'Page 4',
                  style: new TextStyle(
                      fontSize: 40.0,
                      color: Colors.white
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //build function returns a "Widget"
    final materialApp = new MaterialApp(
      title: '',
      // ignore: strong_mode_invalid_cast_new_expr
      home: new HorizonalList(),
    );
    return materialApp;
  }
}
