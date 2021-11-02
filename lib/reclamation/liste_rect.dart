import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:municipality_mobile/reclamation/detail_rect.dart';
import 'package:municipality_mobile/reclamation/recla.dart';
import 'package:municipality_mobile/reclamation/reclamationModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:municipality_mobile/settings.dart' as setteings;

class listeRect extends StatefulWidget {
  listeRect({Key? key}) : super(key: key);

  @override
  _listeRectState createState() => _listeRectState();
}

class _listeRectState extends State<listeRect> {
  List<Reclamation> liste = <Reclamation>[];
  Future<void> getListe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("role") == "User") {
      QuerySnapshot result = FirebaseFirestore.instance
          .collection('declarations')
          .where('user', isEqualTo: prefs.getString("idUser"))
          .get() as QuerySnapshot<Object?>;
      // Get data from docs and convert map to List
      final allData = result.docs.map((doc) => doc.data()).toList();

      print(allData);
    } else {}
  }

  Future<List<Reclamation>>? readUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final snapshot = await FirebaseFirestore.instance
        .collection('declarations')
        .where('user', isEqualTo: prefs.getString("idUser"))
        .get();
    liste = snapshot.docs
        .map(
          (doc) => Reclamation(
            type: doc.data()['type'],
            image: doc.data()['image'],
            note: doc.data()['note'],
            gps: doc.data()['gps'],
            user: doc.data()['user'],
          ),
        )
        .toList();
    return snapshot.docs
        .map(
          (doc) => Reclamation(
            type: doc.data()['type'],
            image: doc.data()['image'],
            note: doc.data()['note'],
            gps: doc.data()['gps'],
            user: doc.data()['user'],
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

  Widget _makeCard(BuildContext context, int index, List<Reclamation> liste) {
    Reclamation item = liste[index];
    /**/
    return FutureBuilder(
        future: _loadImages(item.image!),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(64, 75, 96, .0)),
                child: ListTile(
                  title: Text(item.note!),
                  subtitle: Text(item.gps!),
                  trailing: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(snapshot.data!['url']),
                    backgroundColor: Colors.transparent,
                  ),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    item.image = snapshot.data!['url'] ?? "";
                    prefs.setString("recl", item.toString());
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DetatilRect()));
                    print('Sun');
                  },
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

  /*@override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl, child: _myListView(context));
  }*/
  void changeTheme(bool set, BuildContext context) {
    Provider.of<setteings.Settings>(context, listen: false).setDarkMode(set);
  }

  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.deepPurpleAccent,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Provider.of<setteings.Settings>(context).isDarkMode
                      ? Icons.brightness_high
                      : Icons.brightness_low),
                  onPressed: () {
                    changeTheme(
                        Provider.of<setteings.Settings>(context, listen: false)
                                .isDarkMode
                            ? false
                            : true,
                        context);
                  },
                ),
              ],
            ),
            body: DefaultTextStyle(
              style: Theme.of(context).textTheme.headline2!,
              textAlign: TextAlign.center,
              child: FutureBuilder<List<Reclamation>>(
                future:
                    readUsers(), // a previously-obtained Future<String> or null
                builder: (BuildContext context,
                    AsyncSnapshot<List<Reclamation>> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
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
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => reclamation()));
                },
                label: const Text('التبليغ على المشكل'),
                icon: const Icon(Icons.add),
                backgroundColor: Colors.deepPurpleAccent,
              ),
            )));
  }
}
