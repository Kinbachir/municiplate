import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:municipality_mobile/User/login_screen.dart';
import 'package:municipality_mobile/dashboard/dashboard.dart';
import 'package:municipality_mobile/dashboard/listeNews.dart';
import 'package:municipality_mobile/reclamation/liste_rect.dart';
import 'package:municipality_mobile/reclamation/recla.dart';
import 'package:municipality_mobile/settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class adminMenu extends StatefulWidget {
  @override
  _adminMenuState createState() => _adminMenuState();
}

class _adminMenuState extends State<adminMenu> {
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
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
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
                  iconData: Icons.checklist,
                  title: "قائمة المشاكل",
                  onclick: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => listeRect()))),
              TabData(
                  iconData: Icons.list,
                  title: "الأخبار",
                  onclick: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => listenews()))),
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
        ));
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return dashboard();
      default:
        return listenews();
    }
  }

  void changeTheme(bool set, BuildContext context) {
    Provider.of<Settings>(context, listen: false).setDarkMode(set);
  }
}
