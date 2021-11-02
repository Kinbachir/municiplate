// ignore: file_names
import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:municipality_mobile/User/login_screen.dart';
import 'package:municipality_mobile/dashboard/dashboard.dart';
import 'package:municipality_mobile/dashboard/listeNews.dart';
import 'package:municipality_mobile/dashboard/profil.dart';
import 'package:municipality_mobile/dashboard/reservation.dart';
import 'package:municipality_mobile/reclamation/liste_rect.dart';
import 'package:municipality_mobile/reclamation/recla.dart';
import 'package:municipality_mobile/settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class useMenu extends StatefulWidget {
  @override
  _useMenuState createState() => _useMenuState();
}

class _useMenuState extends State<useMenu> {
  int currentPage = 1;

  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
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
                IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    }),
              ],
            ),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).backgroundColor),
                child: Center(
                  child: _getPage(currentPage),
                ),
              ),
            ),
            bottomNavigationBar: FancyBottomNavigation(
              inactiveIconColor: Theme.of(context).accentColor,
              tabs: [
                TabData(
                    iconData: Icons.list,
                    title: "الأخبار",
                    onclick: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => listenews()))),
                TabData(
                    iconData: Icons.list,
                    title: "قائمة المشاكل",
                    onclick: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => listeRect()))),
                TabData(
                    iconData: Icons.add,
                    title: "الملف الشخصي",
                    onclick: () {
                      final FancyBottomNavigationState fState =
                          bottomNavigationKey.currentState
                              as FancyBottomNavigationState;
                      fState.setPage(2);
                    }),
              ],
              barBackgroundColor: Colors.deepPurpleAccent,
              circleColor: Theme.of(context).backgroundColor,
              activeIconColor: Theme.of(context).accentColor,
              initialSelection: 1,
              key: bottomNavigationKey,
              onTabChangedListener: (position) {
                setState(() {
                  currentPage = position;
                });
              },
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  _openPopup(context);
                },
                label: const Text('حجز'),
                icon: const Icon(Icons.add),
                backgroundColor: Colors.deepPurpleAccent,
              ),
            )));
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return listenews();
      case 1:
        return dashboard();
      default:
        return ProfilePageDesign();
    }
  }

  void changeTheme(bool set, BuildContext context) {
    Provider.of<Settings>(context, listen: false).setDarkMode(set);
  }

  _openPopup(context) {
    String dropdownValue = "استخراج مضامين";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>[
                        'استخراج مضامين',
                        'التعريف بالإمضاء',
                        'المطابقة للاصل',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              RaisedButton(
                  color: Colors.deepPurpleAccent,
                  child: Text(
                    "تأكيد",
                    style: TextStyle(color: Theme.of(context).backgroundColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => reservation()));
                  })
            ],
          );
        });
  }
}
