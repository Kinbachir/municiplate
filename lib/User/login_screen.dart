import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:municipality_mobile/Menu/AdminManu.dart';
import 'package:municipality_mobile/Menu/UserMenu.dart' as menu;
import 'package:municipality_mobile/User/signup_screen.dart';
import 'package:municipality_mobile/home.dart';
import 'package:municipality_mobile/settings.dart' as setting;
import 'package:provider/provider.dart';
import 'package:municipality_mobile/User/user_model.dart' as userModel;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    Provider.of<setting.Settings>(context, listen: false).setDarkMode(set);
  }

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
          ),
          backgroundColor: Colors.deepPurpleAccent,
          actions: <Widget>[
            IconButton(
              icon: Icon(Provider.of<setting.Settings>(context).isDarkMode
                  ? Icons.brightness_high
                  : Icons.brightness_low),
              onPressed: () {
                changeTheme(
                    Provider.of<setting.Settings>(context, listen: false)
                            .isDarkMode
                        ? false
                        : true,
                    context);
              },
            ),
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: new Container(
            child: new SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    ClipPath(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.deepPurple[300],
                      ),
                      clipper: RoundedClipper(60),
                    ),
                    ClipPath(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.33,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.deepPurpleAccent,
                      ),
                      clipper: RoundedClipper(50),
                    ),
                    Positioned(
                        top: -110,
                        left: -110,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.30,
                          width: MediaQuery.of(context).size.height * 0.30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  (MediaQuery.of(context).size.height * 0.30) /
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
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.15 - 50),
                      height: MediaQuery.of(context).size.height * 0.33,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/images/logo.png",
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.height * 0.15,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "مرحبا",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 12, 20, 10),
                  child: Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          textInputAction: TextInputAction.next,
                          controller: email,
                          decoration: InputDecoration(
                            labelText: "بريد الالكتروني",
                            contentPadding: new EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.022,
                                horizontal: 15.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                          ),
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context).requestFocus(myFocusNode);
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          focusNode: myFocusNode,
                          obscureText: true,
                          controller: pass,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: "كلمة المرو",
                            contentPadding: new EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.022,
                                horizontal: 15.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Container(
                          child: GestureDetector(
                              onTap: () {
                                /*print("pressed");
                            _validateInputs();*/
                                SignIn();
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.065,
                                decoration: BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                child: Center(
                                  child: Text(
                                    "تسجيل الدخول",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 10, bottom: 15),
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignupScreen()));
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "مستخدم جديد?",
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "اشتراك",
                                      style: TextStyle(
                                          color: Colors.deepPurpleAccent,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )));
  }

  bool _value1 = false;
  bool _autoValidate = false;
  Future<void> SignIn() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.text, password: pass.text)
          .then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email.text)
            .get()
            .then((value) {
          userModel.User userCnnect =
              userModel.User.fromJson(value.docs.first.data());
          prefs.setString("idUser", value.docs.first.id);
          prefs.setString("role", userCnnect.role);
          if (userCnnect.role == "User") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => menu.useMenu()));
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => adminMenu()));
          }
        });
        return value;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

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
