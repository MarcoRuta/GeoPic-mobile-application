import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geo_pic/UI/MainPages/connection_fail.dart';
import 'package:geo_pic/model/user_image.dart';
import 'package:geo_pic/services/auth_service.dart';
import 'package:geo_pic/services/database_service.dart';
import 'package:geo_pic/services/location_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'loading_page.dart';

class AddPhoto extends StatefulWidget {
  @override
  _AddPhotoState createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  bool loading = false;
  final uploadFormKey = new GlobalKey<FormState>();

  final BaseAuth _baseAuth = Auth();
  final DataManager _dataManager = DataManagerRT();

  File? _imageFile;
  final picker = ImagePicker();

  late String _description;
  late String _place;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingPage()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(''
                  'Add photo'),
            ),
            body:
            (Provider.of<InternetConnectionStatus>(context) == InternetConnectionStatus.disconnected) ? ConnectionFail() :
            Form(
                key: uploadFormKey,
                child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                          Colors.white,
                          Colors.blue,
                        ])),
                    child: SingleChildScrollView(
                        child: Column(
                      children: pictureBox() +
                          pictureButtons() +
                          uploadImageButton(context),
                    )))));
  }

  List<Widget> pictureBox() {
    return [
      const SizedBox(height: 30),
      SizedBox(
          child: _imageFile != null
              ? Image.file(_imageFile!)
              : Container(
                  height: 300,
                  child: Center(
                    child: Text('The picture will be linked to your position',
                        style: TextStyle()),
                  ))),
    ];
  }

  List<Widget> pictureButtons() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shadowColor: Colors.transparent,
              ),
              child: const Icon(
                LineIcons.image,
                size: 20,
              ),
              onPressed: pickImageGallery,
            ),
          ),
          const SizedBox(width: 100),
          ClipRRect(
            child: ElevatedButton(
              child: const Icon(
                LineIcons.camera,
                size: 20,
              ),
              onPressed: pickImageCamera,
            ),
          ),
        ],
      ),
      SizedBox(height: 20),
      Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: TextFormField(
          maxLines: 1,
          validator: (value) => value!.length == 0 && value.length < 30
              ? 'Insert a name of max 30 characters'
              : null,
          onSaved: (value) => _place = value!,
          inputFormatters: [
            LengthLimitingTextInputFormatter(
              100,
            ),
          ],
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            filled: false,
            labelText: 'Name',
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: TextFormField(
          maxLines: 2,
          validator: (value) => value!.length > 100 || value.length == 0
              ? 'Insert a description of max 100 characters'
              : null,
          onSaved: (value) => _description = value!,
          inputFormatters: [
            LengthLimitingTextInputFormatter(
              100,
            ),
          ],
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            filled: false,
            labelText: 'Description',
          ),
        ),
      ),
    ];
  }

  List<Widget> uploadImageButton(BuildContext context) {
    return [
      SizedBox(height: 40),
      Container(
        child: ElevatedButton(
          onPressed: validateAndSubmit,
          child: const Text(
            "Upload Image",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    ];
  }

  Future<void> uploadImage() async {
    if (_imageFile != null) {
      setState(() {
        loading = true;
      });

      if ((await LocationManager.checkLocationPermission() == false)) {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
            msg: "you have to activate the gps to be able to upload a photo",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.indigoAccent,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }

      String url = await _dataManager.uploadImageFile(
          context, _imageFile, _baseAuth.authInstance.currentUser!.uid);

      LocationData currentLocation = await LocationManager.getLocation();

      Map<dynamic, dynamic> info =
          await _dataManager.getUser(_baseAuth.authInstance.currentUser!.uid);
      String username = info["username"];

      _dataManager.createImage(UserImage(
        _baseAuth.authInstance.currentUser!.uid,
        username,
        url,
        _description,
        currentLocation.latitude ?? 0.0,
        currentLocation.longitude ?? 0.0,
        _place,
      ));
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
          msg: "Image saved!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.indigoAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushReplacementNamed(context, '/main_page');
    } else {
      Fluttertoast.showToast(
          msg: "Insert a pic"
              "!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.indigoAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future pickImageCamera() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 25);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future pickImageGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 25);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  bool validateAndSave() {
    final form = uploadFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      uploadImage();
    }
  }
}
