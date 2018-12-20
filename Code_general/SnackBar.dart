// Sử dụng SnackBar để hiện thông tin tạm thời trong Flutter

import 'package:flutter/material.dart';
//Define "root widget"
void main() => runApp(new MyApp());//one-line function

class MyApp extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  _showSnackBar() {
    print("Show Snackbar here !");
    final snackBar = new SnackBar(
        content: new Text("This is a SnackBar"),
        duration: new Duration(seconds: 3),
        backgroundColor: Colors.green,
        action: new SnackBarAction(label: 'Ok', onPressed: (){
          print('press Ok on SnackBar');
        }),
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
  @override
  Widget build(BuildContext context) {
    //build function returns a "Widget"
    return new MaterialApp(
      title: "SnackBar example",
      home: new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text("An example of SnackBar"),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.info),
                onPressed: _showSnackBar)
          ],
        ),
      )
    );
  }
}
