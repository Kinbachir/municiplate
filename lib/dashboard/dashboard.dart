import 'package:flutter/material.dart';
import 'package:municipality_mobile/User/login_screen.dart';

import 'package:flutter/material.dart';
import 'package:municipality_mobile/Menu/AdminManu.dart';
import 'package:municipality_mobile/Menu/UserMenu.dart';
import 'package:municipality_mobile/User/signup_screen.dart';
import 'package:municipality_mobile/reclamation/liste_rect.dart';
import 'package:municipality_mobile/settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class dashboard extends StatefulWidget {
  @override
  _dashboardState createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  late FocusNode myFocusNode;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  void changeTheme(bool set, BuildContext context) {
    Provider.of<Settings>(context, listen: false).setDarkMode(set);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: new Container(
            child: new SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    ClipPath(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.20,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.deepPurple[300],
                      ),
                      clipper: RoundedClipper(60),
                    ),
                    ClipPath(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.17,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.deepPurpleAccent,
                      ),
                      clipper: RoundedClipper(50),
                    ),
                    Positioned(
                        top: -70,
                        left: -110,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.20,
                          width: MediaQuery.of(context).size.height * 0.20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  (MediaQuery.of(context).size.height * 0.20) /
                                      2),
                              color: Colors.deepPurple[300]!.withOpacity(0.3)),
                          child: Center(
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.deepPurpleAccent),
                            ),
                          ),
                        )),
                    Positioned(
                        top: -100,
                        left: 100,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.36,
                          width: MediaQuery.of(context).size.height * 0.36,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  (MediaQuery.of(context).size.height * 0.36) /
                                      2),
                              color: Colors.deepPurple[300]!.withOpacity(0.3)),
                          child: Center(
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.deepPurpleAccent),
                            ),
                          ),
                        )),
                    Positioned(
                        top: -50,
                        left: 60,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  (MediaQuery.of(context).size.height * 0.15) /
                                      2),
                              color: Colors.deepPurple[300]!.withOpacity(0.3)),
                        )),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 50),
                  child: Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: GridView.count(
                        crossAxisCount: 3,
                        children: List.generate(choices.length, (index) {
                          return Center(
                            child: SelectCard(choice: choices[index]),
                          );
                        })),
                  ),
                ),
              )
            ],
          ),
        )));
  }

  bool _value1 = false;
  bool _autoValidate = false;

  void _value1Changed(bool value) => setState(() => _value1 = value);

  void _validateInputs() {
    if (_formKey.currentState!.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState!.save();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(value))
      return 'أدخل بريد إلكتروني صالح';
    else
      return '';
  }

  String validatePassword(String value) {
    if (value.length < 6)
      return 'يجب أن تتكون كلمة المرور من 6 أرقام على الأقل';
    else
      return '';
  }
}

class RoundedClipper extends CustomClipper<Path> {
  var differenceInHeights = 0;

  RoundedClipper(int differenceInHeights) {
    this.differenceInHeights = differenceInHeights;
  }

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - differenceInHeights);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class Choice {
  const Choice({required this.title, required this.icon});
  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'تشكيات عامة', icon: Icons.light),
  const Choice(
      title: 'المناطق الخضراء و البستنة', icon: Icons.restore_from_trash),
  const Choice(title: 'المخالفات الاقتصادية', icon: Icons.circle),
  const Choice(title: 'التراتيب العمرانية', icon: Icons.light),
  const Choice(title: 'الصحة و البيئة', icon: Icons.restore_from_trash),
  const Choice(title: 'الطرقات', icon: Icons.circle),
  const Choice(title: 'الإنارة العمومية', icon: Icons.light),
  const Choice(
      title: 'النظافة و مقاومة الحشرات', icon: Icons.restore_from_trash),
];

class SelectCard extends StatelessWidget {
  const SelectCard({Key? key, required this.choice}) : super(key: key);
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.deepPurpleAccent,
        child: InkWell(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("type", choice.title);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => listeRect()));
            },
            child: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(choice.title,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white)),
                  ]),
            )));
  }
}
