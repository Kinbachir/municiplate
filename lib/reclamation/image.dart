import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:municipality_mobile/reclamation/reclamationModel.dart';
import 'package:municipality_mobile/settings.dart' as settings;
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:shared_preferences/shared_preferences.dart';

class imageRecl extends StatefulWidget {
  imageRecl({Key? key}) : super(key: key);

  @override
  _imageReclState createState() => _imageReclState();
}

var pickedFile;
typedef void OnPickImageCallback(
    double? maxWidth, double? maxHeight, int? quality);

class _imageReclState extends State<imageRecl> {
  List<XFile>? _imageFileList;

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  var _imageGet;
  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = Path.basename(_imageGet!.path);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('uploads')
        .child('/$fileName');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': fileName});
    FirebaseStorage storage = FirebaseStorage.instance;
    await storage
        .ref(fileName)
        .putFile(File(_imageGet!.path), metadata)
        .then((p0) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      CollectionReference declarations =
          FirebaseFirestore.instance.collection('declarations');
      String user = "vide";
      if (prefs.getString('idUser') != null && prefs.getString('idUser') != "")
        user = prefs.getString('idUser').toString();
      declarations.add(Reclamation(
              type: prefs.getString('type').toString(),
              gps: prefs.getString('gps').toString(),
              note: prefs.getString('note').toString(),
              image: p0.ref.fullPath,
              user: user)
          .toJson());
    });
  }

  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();
  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return onPick(null, null, null);
  }

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    await _displayPickImageDialog(context!,
        (double? maxWidth, double? maxHeight, int? quality) async {
      try {
        final pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,
        );
        setState(() {
          _imageFile = pickedFile;
          _imageGet = pickedFile;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    });
  }

  Widget _handlePreview() {
    return Column(
      children: [
        _previewImages(),
        SizedBox(
          height: 30,
        ),
        GestureDetector(
            onTap: () {
              uploadImageToFirebase(context);
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.065,
              decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Center(
                child: Text(
                  "تسجيل المشكل",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            )),
      ],
    );
  }

  String? _retrieveDataError;
  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      return Semantics(
          child: ListView.builder(
            shrinkWrap: true,
            key: UniqueKey(),
            itemBuilder: (context, index) {
              return Semantics(
                label: 'image_picker_example_picked_image',
                child: kIsWeb
                    ? Image.network(_imageFileList![index].path,
                        height: MediaQuery.of(context).size.height * 0.7,
                        fit: BoxFit.fill)
                    : Image.file(File(_imageFileList![index].path),
                        height: MediaQuery.of(context).size.height * 0.7,
                        fit: BoxFit.fill),
              );
            },
            itemCount: _imageFileList!.length,
          ),
          label: 'image_picker_example_picked_images');
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
        pickedFile = response.file;
        _imageFileList = response.files;
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  void changeTheme(bool set, BuildContext context) {
    Provider.of<settings.Settings>(context, listen: false).setDarkMode(set);
  }

  bool initialized = false;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Provider.of<settings.Settings>(context).isDarkMode
                ? Icons.brightness_high
                : Icons.brightness_low),
            onPressed: () {
              changeTheme(
                  Provider.of<settings.Settings>(context, listen: false)
                          .isDarkMode
                      ? false
                      : true,
                  context);
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
          child: Column(children: [
        Center(
          child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
              ? FutureBuilder<void>(
                  future: retrieveLostData(),
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Text(
                          'You have not yet picked an image.',
                          textAlign: TextAlign.center,
                        );
                      case ConnectionState.done:
                        return _handlePreview();
                      default:
                        if (snapshot.hasError) {
                          return Text(
                            'Pick image/video error: ${snapshot.error}}',
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return const Text(
                            'You have not yet picked an image.',
                            textAlign: TextAlign.center,
                          );
                        }
                    }
                  },
                )
              : _handlePreview(),
        ),
      ])),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Semantics(
            label: 'image_picker_example_from_gallery',
            child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(ImageSource.gallery, context: context);
              },
              heroTag: 'image0',
              tooltip: 'Pick Image from gallery',
              child: const Icon(Icons.photo),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(ImageSource.camera, context: context);
              },
              heroTag: 'image2',
              tooltip: 'Take a Photo',
              child: const Icon(Icons.camera_alt),
            ),
          ),
        ],
      ),
    );
  }

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Semantics(
            label: 'image_picker_example_from_gallery',
            child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(ImageSource.gallery, context: context);
              },
              heroTag: 'image0',
              tooltip: 'Pick Image from gallery',
              child: const Icon(Icons.photo),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(ImageSource.camera, context: context);
              },
              heroTag: 'image2',
              tooltip: 'Take a Photo',
              child: const Icon(Icons.camera_alt),
            ),
          ),
        ],
      ),
    );
  }*/
}
