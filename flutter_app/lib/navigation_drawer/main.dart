import 'package:flutter/material.dart';
import 'package:flutter_app/navigation_drawer/screens/account.dart';
import 'package:flutter_app/navigation_drawer/screens/home.dart';
import 'package:flutter_app/navigation_drawer/screens/settings.dart';

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
