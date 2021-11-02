import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:municipality_mobile/dashboard/booking_screen.dart';
import 'package:municipality_mobile/dashboard/news-model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class listenews extends StatefulWidget {
  listenews({Key? key}) : super(key: key);

  @override
  _listenewsState createState() => _listenewsState();
}

class _listenewsState extends State<listenews> {
  List<news> liste = <news>[];

  Future<List<news>> readUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final snapshot = await FirebaseFirestore.instance.collection('news').get();
    liste = snapshot.docs
        .map(
          (doc) => news(
            title: doc.data()['title'],
            image: doc.data()['image'],
            note: doc.data()['note'],
            date: doc.data()['date'],
          ),
        )
        .toList();
    print(liste);
    return snapshot.docs
        .map(
          (doc) => news(
            title: doc.data()['title'],
            image: doc.data()['image'],
            note: doc.data()['note'],
            date: doc.data()['date'],
          ),
        )
        .toList();
  }

  FirebaseStorage storage = FirebaseStorage.instance;
  Future<String> getUrl(String image) async {
    return await storage.ref(image).getDownloadURL();
  }

  Future<Map<String, dynamic>> _loadImages(String image) async {
    Map<String, dynamic> files;

    final result = await storage.ref(image);
    final String fileUrl = await result.getDownloadURL();
    final FullMetadata fileMeta = await result.getMetadata();
    files = {
      "url": fileUrl,
      "path": result.fullPath,
      "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
      "description": fileMeta.customMetadata?['description'] ?? 'No description'
    };

    return files;
  }

  Widget _makeCard(BuildContext context, int index, List<news> liste) {
    news item = liste[index];
    /**/
    return FutureBuilder(
        future: _loadImages(item.image ?? ""),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Card(
              color: Colors.white,
              child: InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  item.image = snapshot.data!['url'] ?? "";
                  prefs.setString("news", item.toString());
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Detatil()));
                },
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 80,
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(snapshot.data!['url'],
                                    height: 150),
                              ),
                              Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title ?? "",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20),
                                    Container(
                                      width: 150,
                                      child: Text(
                                        item.note ?? "",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.date ?? "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )
                                  ])
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).accentColor,
            ),
          );
        });
    /**/
  }

  Widget _myListView(BuildContext context, liste) {
    return ListView.builder(
        itemBuilder: (context, index) => _makeCard(context, index, liste),
        itemCount: liste.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true);
  }

  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.headline2!,
          textAlign: TextAlign.center,
          child: FutureBuilder<List<news>>(
            future: readUsers(), // a previously-obtained Future<String> or null
            builder:
                (BuildContext context, AsyncSnapshot<List<news>> snapshot) {
              List<Widget> children;
              print(snapshot);
              if (snapshot.hasData) {
                print(snapshot.hasData);
                return _myListView(context, snapshot.data);
              } else if (snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  )
                ];
              } else {
                children = const <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('في انتظار النتيجة...'),
                  )
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                ),
              );
            },
          ),
        ));
  }
}
