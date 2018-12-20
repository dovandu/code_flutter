// ListView#3.Tạo một ListView căn bản với Text và ảnh

```dart

// flower.dart

class Flower {
  final String flowerName;
  final String description;
  final String imageURL;
  //Constructor
  const Flower({
    this.flowerName,
    this.description,
    this.imageURL
  });
}

// main.dart

import 'package:flutter/material.dart';
import 'listViewExample.dart';
//Define "root widget"
void main() => runApp(new MyApp());//one-line function

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //build function returns a "Widget"
    final materialApp = new MaterialApp(
      title: '',
      // ignore: strong_mode_invalid_cast_new_expr
      home: new ListViewExample(),
    );
    return materialApp;
  }
}

// listViewExample.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'data.dart';
class ListViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ListViewExampleState();
  }
}
class ListViewExampleState extends State<ListViewExample> {
  List<Container> _buildListItemsFromFlowers(){
    int index = 0;
    return flowers.map((flower){
      var container = Container(
        decoration: index % 2 == 0?
        new BoxDecoration(color: const Color(0xFFb0e0e6)):
        new BoxDecoration(
            color: const Color(0xFF7ec0ee)
        ),
        child: new Row(
          children: <Widget>[
            new Container(
              margin: new EdgeInsets.all(10.0),
              child: new CachedNetworkImage(
                imageUrl: flower.imageURL,
                width: 70.0,
                height: 70.0,
                fit: BoxFit.cover,
              ),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: new Text(
                    flower.flowerName,
                    style: new TextStyle(
                        fontWeight:  FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.black
                    ),
                  ),
                ),
                new Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: new Text(
                    flower.description,
                    style: new TextStyle(
                        fontWeight:  FontWeight.normal,
                        fontSize: 10.0,
                        color: Colors.black
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );
      index = index + 1;
      return container;
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new ListView(
      children: _buildListItemsFromFlowers(),
    );
  }
}

// data.dart

import 'flower.dart';
var flowers = [
  new Flower(
      flowerName: 'Rosa rubiginosa',
      description: 'The Swedish botanist Carl Linnaeus',
      imageURL: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e6/Rosa_rubiginosa_1.jpg/440px-Rosa_rubiginosa_1.jpg'
  ),
  new Flower(
      flowerName: 'Botany',
      description: 'The leaves are borne alternately on the stem',
      imageURL: 'https://upload.wikimedia.org/wikipedia/commons/a/ac/Rose_hip_02_ies.jpg'
  ),
  new Flower(
      flowerName: 'Rose leaflets',
      description: 'Subgenus, sometimes incorrectly called Eurosa',
      imageURL: 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Roseleaves3800px.JPG'
  ),
  new Flower(
      flowerName: 'Amber Flush',
      description: 'Rose perfumes are made from rose oil',
      imageURL: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/Rose_Amber_Flush_20070601.jpg/440px-Rose_Amber_Flush_20070601.jpg'
  ),
  new Flower(
      flowerName: 'Rosa gallica',
      description: 'Rosa gallica Evêque, painted by Redouté',
      imageURL: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Redoute_-_Rosa_gallica_purpuro-violacea_magna.jpg/440px-Redoute_-_Rosa_gallica_purpuro-violacea_magna.jpg'
  ),
  new Flower(
      flowerName: 'Easter Lily',
      description: 'Reproductive parts of Easter Lily.',
      imageURL: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Lillium_Stamens.jpg/440px-Lillium_Stamens.jpg'
  ),
  new Flower(
      flowerName: 'calla lily',
      description: 'The familiar calla lily is not a single flower.',
      imageURL: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/White_and_yellow_flower.JPG/440px-White_and_yellow_flower.JPG'
  ),
  new Flower(
      flowerName: 'Crateva religiosa',
      description: 'this Crateva religiosa flower has both stamens',
      imageURL: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/Crateva_religiosa.jpg/440px-Crateva_religiosa.jpg'
  ),
  new Flower(
      flowerName: 'Amborella trichopoda',
      description: 'Amborella trichopoda may have features',
      imageURL: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/Amborella_trichopoda_%283065968016%29_fragment.jpg/440px-Amborella_trichopoda_%283065968016%29_fragment.jpg'
  ),
  new Flower(
      flowerName: 'Lilies',
      description: 'Lilies are often used to denote life or resurrection',
      imageURL: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Liliumbulbiferumflowertop.jpg/440px-Liliumbulbiferumflowertop.jpg'
  ),
  new Flower(
      flowerName: 'Bee orchid',
      description: 'A Bee orchid has evolved over many generations',
      imageURL: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Ophrys_apifera_flower1.jpg/340px-Ophrys_apifera_flower1.jpg'
  ),

];




```


