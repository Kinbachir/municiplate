import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:municipality_mobile/settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class reservation extends StatefulWidget {
  reservation({Key? key}) : super(key: key);

  @override
  _reservationState createState() => _reservationState();
}

class _reservationState extends State<reservation> {
  void changeTheme(bool set, BuildContext context) {
    Provider.of<Settings>(context, listen: false).setDarkMode(set);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepPurpleAccent,
          actions: <Widget>[
            IconButton(
              icon: Icon(Provider.of<Settings>(context).isDarkMode
                  ? Icons.brightness_high
                  : Icons.brightness_low),
              onPressed: () {
                changeTheme(
                    Provider.of<Settings>(context, listen: false).isDarkMode
                        ? false
                        : true,
                    context);
              },
            ),
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Text(
                "استخراج مضامين",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                children: [
                  Card(
                    color: Colors.deepPurple,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        ListTile(
                          leading: Text("0",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                  color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.deepPurple,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        ListTile(
                          leading: Text("0",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                  color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.deepPurple,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        ListTile(
                          leading: Text("رقمك",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                  color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.deepPurple,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        ListTile(
                          leading: Text("رقم الحالي",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                  color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  // same card repeated
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text(
                    "وقت الحالي :",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    DateTime.now().year.toString() +
                        "-" +
                        DateTime.now().month.toString() +
                        "-" +
                        DateTime.now().day.toString() +
                        " " +
                        DateTime.now().hour.toString() +
                        ":" +
                        DateTime.now().minute.toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "وقت اغلاق :",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text(
                    DateTime.now().year.toString() +
                        "-" +
                        DateTime.now().month.toString() +
                        "-" +
                        DateTime.now().day.toString() +
                        " " +
                        DateTime.now().hour.toString() +
                        ":" +
                        DateTime.now().minute.toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton.extended(
            onPressed: () {},
            label: const Text('تحديث'),
            icon: const Icon(Icons.restart_alt),
            backgroundColor: Colors.deepPurpleAccent,
          ),
          const SizedBox(
            height: 5,
          ),
          FloatingActionButton.extended(
            onPressed: () {},
            label: const Text('اظهر'),
            icon: const Icon(Icons.add),
            backgroundColor: Colors.deepPurpleAccent,
          ),
        ]));
  }
}
