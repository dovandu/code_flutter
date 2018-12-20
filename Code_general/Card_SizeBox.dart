//Layout#5. Layout giao diện Flutter Card và SizedBox


import 'package:flutter/material.dart';

//Define "root widget"
void main() => runApp(new MyApp());//one-line function
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //build function returns a "Widget"
    var card = new Card(
      child: new Column(
        children: <Widget>[
          new ListTile(
            leading: new Icon(Icons.account_box, color: Colors.blue,size: 26.0,),
            title: new Text("Nguyen Duc Hoang"
            ,style: new TextStyle(fontWeight: FontWeight.w400),),
            subtitle: new Text("Software developer"),
          ),
          new Divider(color: Colors.blue,indent: 16.0,),
          new ListTile(
            leading: new Icon(Icons.email, color: Colors.blue, size: 26.0,),
            title: new Text("sunlight4d@gmail.com"
              ,style: new TextStyle(fontWeight: FontWeight.w400),),
          ),
          new ListTile(
            leading: new Icon(Icons.phone, color: Colors.blue, size: 26.0,),
            title: new Text("+84-123.456.789"
              ,style: new TextStyle(fontWeight: FontWeight.w400),),
          )
        ],
      ),
    );
    final sizedBox = new Container(
      margin: new EdgeInsets.only(left: 10.0, right: 10.0),
      child: new SizedBox(
        height: 220.0,
        child: card,
      ),
    );
    final center = new Center(
      child: sizedBox,
    );
    return new MaterialApp(
      title: "",
//      home: new Text("Add Google fonts to Flutter App")
      home: new Scaffold(appBar: new AppBar(
        title: new Text("Card example")
      ),
        body: center,
      )
    );
  }
}
