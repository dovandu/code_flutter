// Layout#4. Sử dụng Stack layout để xếp chồng các widget và Container
//pubspec.yaml
/* assets:
      - images/image01.JPG
      - images/image02.JPG
      - images/image03.JPG
      - images/image04.JPG
      - images/image05.JPG
      - images/image06.JPG
      - images/image07.JPG
      - images/image08.JPG
      - images/image09.JPG
      - images/image10.JPG
      - images/image11.JPG
      - images/image12.JPG
      - images/image13.JPG
      - images/image14.JPG
      - images/image15.JPG
      - images/image16.JPG
      - images/image17.JPG
      - images/image18.JPG
      - images/image19.JPG
      - images/image20.JPG
      - images/image21.JPG
      - images/image22.JPG
      - images/image23.JPG
      - images/image24.JPG
      - images/image25.JPG
      - images/image26.JPG
      - images/image27.JPG
      - images/image28.JPG
*/
import 'package:flutter/material.dart';

//Define "root widget"
void main() => runApp(new MyApp());//one-line function
//Now use stateful Widget = Widget has properties which can be changed
class MainPage extends StatefulWidget {
  final String title;
  //Custom constructor, add property : title
  @override
  MainPage({this.title}) : super();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MainPageState();//Return a state object
  }
}
class MainPageState extends State<MainPage> {
  //State must have "build" => return Widget
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new GridView.extent(
        maxCrossAxisExtent: 150.0,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
        padding: const EdgeInsets.all(5.0),
        children: _buildGridTiles(29),//Where is this function ?
      ),
    );
  }
}
List<Widget> _buildGridTiles(numberOfTiles) {
  List<Stack> containers = new List<Stack>.generate(numberOfTiles,
  (int index) {
    //index = 0, 1, 2,...
    final imageName = index < 9 ?
              'images/image0${index + 1}.JPG' : 'images/image${index + 1}.JPG';
    return new Stack(
      alignment: const Alignment(0.0, 0.0),
      children: <Widget>[
        new Container(
          //Do you need to make Image as "Circle"
          child: new Image.asset(
              imageName,
              width: 150.0,
              height: 150.0,
              fit: BoxFit.fill
          ),
        ),
        //How to set background to Text ?
        //Let's move Text inside a Container,then set it's decoration
        new Container(
          padding: const EdgeInsets.all(5.0),
          decoration: new BoxDecoration(
            color: new Color.fromARGB(150, 71, 150, 236)
          ),
          child: new Text('${index}', style: new TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )),
        ),

      ],
    );
    /*
    return new Container(
      child: new Image.asset(
        imageName,
        fit: BoxFit.fill
      ),
    );
    */
  });
  return containers;
}
class MyApp extends StatelessWidget {
  //Stateless = immutable = cannot change object's properties
  //Every UI components are widgets
  @override
  Widget build(BuildContext context) {
    //Now we need multiple widgets into a parent = "Container" widget
    //build function returns a "Widget"
    return new MaterialApp(
      title: "",
      home: new MainPage(title: "GridView of Images")
    );
  }
}
