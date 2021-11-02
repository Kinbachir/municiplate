// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';
import 'dart:math';
import 'package:latlong2/latlong.dart' as lat;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:municipality_mobile/reclamation/zoombuttons_plugin_option.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:municipality_mobile/reclamation/image.dart';
import 'package:municipality_mobile/settings.dart';

class reclamation extends StatefulWidget {
  reclamation({Key? key}) : super(key: key);

  @override
  _reclamationState createState() => _reclamationState();
}

class _reclamationState extends State<reclamation> {
  Marker? _marker;
  List<Marker> allMarkers = [];
  late FocusNode focusNode1;
  late FocusNode focusNode2;
  late FocusNode focusNode3;
  TextEditingController gps = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;
  late Position _currentPosition;
  late String _currentAddress = "";
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      allMarkers.add(
        Marker(
          point:
              lat.LatLng(_currentPosition.latitude, _currentPosition.longitude),
          builder: (context) => const Icon(
            Icons.circle,
            color: Colors.red,
            size: 12.0,
          ),
        ),
      );
      print("markers " + allMarkers.length.toString());
      setState(() {});
      Placemark place = p[0];
      print(p.length);
      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
        gps.text = _currentAddress;
        print(_currentAddress);
        print(isLogin);
      });
    } catch (e) {
      print(e);
    }
  }

  _getCurrentLocation() async {
    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    if (mounted) {
      super.initState();
      focusNode1 = FocusNode();
      focusNode2 = FocusNode();
      focusNode3 = FocusNode();
      login();
      setState(() {});
      _getCurrentLocation();
    }
  }

  @override
  void setState(VoidCallback fn) {
    //_getCurrentLocation();
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    super.dispose();
  }

  int _sliderVal = 10 ~/ 10;
  bool isLogin = false;
  login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("idUser").toString() != 'null') {
      isLogin = true;
    }
  }

  PreferredSizeWidget? appBarValeur() {
    return AppBar(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    var dropdownValue = "إضاءة";
    TextEditingController note = TextEditingController();
    return Scaffold(
        appBar: appBarValeur(),
        backgroundColor: Theme.of(context).backgroundColor,
        body: new Container(
            child: new SingleChildScrollView(
                child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
                width: MediaQuery.of(context).size.width,
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
                        height: MediaQuery.of(context).size.height * 0.18,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.deepPurpleAccent,
                      ),
                      clipper: RoundedClipper(50),
                    ),
                    Positioned(
                        top: -50,
                        left: -30,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  (MediaQuery.of(context).size.height * 0.15) /
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
                        left: MediaQuery.of(context).size.width * 0.6,
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
                        top: -50,
                        left: 80,
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
                          Text(
                            "التبليغ على المشكل",
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
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.height * 0.80) - 22,
                margin: EdgeInsets.fromLTRB(20, 12, 20, 10),
                child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: <Widget>[
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.022,
                              horizontal: 15.0),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                        ),
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>['إضاءة', 'قمامة', 'حفرة']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'أدخل الملاحظة';
                          }
                        },
                        controller: note,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(
                            fontSize: 16, color: Theme.of(context).accentColor),
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: "ملاحظة",
                          contentPadding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.022,
                              horizontal: 15.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                        ),
                        onFieldSubmitted: (String value) {
                          FocusScope.of(context).requestFocus(focusNode1);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        enabled: false,
                        controller: gps,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            fontSize: 16, color: Theme.of(context).accentColor),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'موقعك',
                          contentPadding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.022,
                              horizontal: 15.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 300,
                        child: FlutterMap(
                          options: MapOptions(
                            center: lat.LatLng(36.7948008, 10.0031931),
                            zoom: 5.0,
                            plugins: [
                              ZoomButtonsPlugin(),
                            ],
                          ),
                          layers: [
                            ZoomButtonsPluginOption(
                              minZoom: 4,
                              maxZoom: 19,
                              mini: true,
                              padding: 10,
                              alignment: Alignment.bottomLeft,
                            ),
                            MarkerLayerOptions(
                                markers: allMarkers.sublist(
                                    0, min(allMarkers.length, _sliderVal))),
                          ],
                          children: <Widget>[
                            TileLayerWidget(
                              options: TileLayerOptions(
                                urlTemplate:
                                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                subdomains: ['a', 'b', 'c'],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: GestureDetector(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString("type", dropdownValue);
                              prefs.setString("note", note.text);
                              prefs.setString("gps", gps.text);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => imageRecl()));
                            },
                            child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    shape: BoxShape.circle),
                                child: Icon(Icons.arrow_back,
                                    color: Colors.white))),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ))));
  }

  void changeTheme(bool set, BuildContext context) {
    Provider.of<Settings>(context, listen: false).setDarkMode(set);
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
      return 'Enter Valid Email';
    else
      return '';
  }

  String validatePassword(String value) {
    if (value.length < 6)
      return 'Password must be atleast 6 digits';
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
