import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:municipality_mobile/Menu/AdminManu.dart';
import 'package:municipality_mobile/home.dart';
import 'package:municipality_mobile/settings.dart';
import 'package:municipality_mobile/themes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:municipality_mobile/Menu/UserMenu.dart' as menu;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Here we are asynchronously passing an instance of SharedPreferences
    /// to our Settings ChangeNotifier class and that in turn helps us
    /// determine the basic app settings to be applied whenever the app is
    /// launched.
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        return ChangeNotifierProvider<Settings>.value(
          value: Settings(snapshot.data!),
          child: FutureBuilder(
            // Initialize FlutterFire
            future: Firebase.initializeApp(),
            builder: (context, snapshot) {
              // Otherwise, show something whilst waiting for initialization to complete
              return _MyApp();
            },
          ),
        );
      },
    );
  }
}

class _MyApp extends StatelessWidget {
  Future<Widget>? getWidget() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString("role");
    if (role == "User") {
      return menu.useMenu();
    } else if (role == "Admin") {
      return adminMenu();
    } else {
      return Home();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<Settings>(context).isDarkMode
          ? setDarkTheme
          : setLightTheme,
      home: Scaffold(
          body: Directionality(
        textDirection: TextDirection.rtl,
        child: FutureBuilder<Widget>(
          // Initialize FlutterFire
          future: getWidget(),
          builder: (context, AsyncSnapshot<Widget> snapshot) {
            // Otherwise, show something whilst waiting for initialization to complete
            return snapshot.data!;
          },
        ),
      )),
    );
  }

  void changeTheme(bool set, BuildContext context) {
    Provider.of<Settings>(context, listen: false).setDarkMode(set);
  }
}
