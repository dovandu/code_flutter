import 'package:flutter/material.dart';
import 'package:flutter_app/drawer/account.dart';
import 'package:flutter_app/drawer/home.dart';
import 'package:flutter_app/drawer/settings.dart';
// drawer
void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new HomeScreen(), // route for home is '/' implicitly
    routes: <String, WidgetBuilder>{
      // define the routes
      SettingsScreen.routeName: (BuildContext context) => new SettingsScreen(),
      AccountScreen.routeName: (BuildContext context) => new AccountScreen(),
    },
  ));
}
