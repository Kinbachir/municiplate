import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:municipality_mobile/dashboard/news-model.dart';
import 'package:municipality_mobile/settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Detatil extends StatelessWidget {
  const Detatil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        String news = snapshot.data!.getString("news").toString();
        return ChangeNotifierProvider<Settings>.value(
            value: Settings(snapshot.data!), child: BookingScreen(news));
      },
    );
  }
}

class BookingScreen extends StatefulWidget {
  String index;

  BookingScreen(
    this.index,
  );

  @override
  _BookingScreenState createState() => _BookingScreenState(index);
}

class _BookingScreenState extends State<BookingScreen> {
  String? index;

  _BookingScreenState(String index) {
    this.index = index;
  }
  void changeTheme(bool set, BuildContext context) {
    Provider.of<Settings>(context, listen: false).setDarkMode(set);
  }

  news? newsModel;
  @override
  void initState() {
    newsModel = news.fromJson(jsonDecode(index!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.5;
    return Scaffold(
        appBar: AppBar(
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
        backgroundColor: Colors.deepPurpleAccent,
        body: new Container(
            child: new SingleChildScrollView(
                child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Stack(
                      children: <Widget>[
                        Container(
                            foregroundDecoration:
                                BoxDecoration(color: Colors.black26),
                            height: 400,
                            child: Image.network(
                              newsModel!.image.toString(),
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )),
                        SingleChildScrollView(
                          padding:
                              const EdgeInsets.only(top: 16.0, bottom: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 250),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  newsModel!.title.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(32.0),
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      "تفصيل".toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      newsModel!.note.toString(),
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14.0),
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )))));
  }
}
