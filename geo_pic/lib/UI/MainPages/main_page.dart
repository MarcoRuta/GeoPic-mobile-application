import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geo_pic/UI/MainPages/connection_fail.dart';
import 'package:geo_pic/UI/MainPages/photo_details.dart';
import 'package:geo_pic/ViewModels/marker_model.dart';
import 'package:geo_pic/ViewModels/userdata_model.dart';
import 'package:geo_pic/services/auth_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'loading_page.dart';

class MainPage extends StatefulWidget {
  MainPage();

  @override
  _mainPageState createState() => _mainPageState();
}

class _mainPageState extends State<MainPage> {
  bool loading = false;

  late String _mapStyle;
  late Set<Marker> _markers = {};
  late StreamSubscription<User?> _authStream;
  late StreamController imageStreamController = StreamController();

  BaseAuth baseAuth = Auth();

  @override
  void dispose() {
    _authStream.cancel();
    imageStreamController.close();
    MarkerModel().dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _authStream = baseAuth.authInstance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/home_page', (Route<dynamic> route) => false);
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // userInfo();

    final drawerItems = ListView(
      children: drawerHeader() + drawerButtons(),
    );

    return loading
        ? LoadingPage()
        : WillPopScope(
            onWillPop: () {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Want to quit GeoPic?'),
                    content: SingleChildScrollView(
                      child: ListBody(),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Yes'),
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                      ),
                      TextButton(
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                },
              );
              return Future(() => true);
            },
            child: Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                      onPressed: () {
                        Fluttertoast.showToast(
                            msg:
                                'Red marks are other users\'pictures\n Blue marks are your own pictures',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 8,
                            backgroundColor: Colors.indigoAccent,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                      icon: Icon(Icons.info_outline))
                ],
                backgroundColor: Colors.blue,
                title: const Text('GeoPic'),
              ),
              body:
                  ///Consumer di UserImagesModel, viene notificato ogni volta che il modello cambia
                  ///in modo da poter eseguire rebuild
                  Consumer<MarkerModel>(builder: (context, model, child) {
                if (model.images != null) {
                  _markers = Set<Marker>();
                  model.images.forEach((element) {
                    Marker marker = Marker(
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          (baseAuth.authInstance.currentUser!.uid ==
                                  element.Userid)
                              ? BitmapDescriptor.hueAzure
                              : BitmapDescriptor.hueRed),
                      markerId: MarkerId(element.Userid +
                          element.downloadUrl +
                          Random.secure().toString()),
                      position: LatLng(element.lat, element.lon),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PhotoDetails(element),
                          ),
                        );
                      },
                    );
                    _markers.add(marker);
                  });
                  return (Provider.of<InternetConnectionStatus>(context) == InternetConnectionStatus.disconnected) ? ConnectionFail() :
                  GoogleMap(
                      markers: _markers,
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                      onCameraMove: (position) {
                        if (mounted) {
                          setState;
                        }
                      });
                }
                return LoadingPage();
              }),
              drawer: Drawer(
                child: drawerItems,
              ),
            ));
  }

  List<Widget> drawerHeader() {
    return [
      Consumer<UserDataModel>(builder: (context, model, child) {
        return UserAccountsDrawerHeader(
          accountName: Text(model.username),
          accountEmail: Text(model.email),
          currentAccountPictureSize: Size.square(90),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Image.asset(
              'assets/images/geo_pic_logo.png',
            ),
          ),
        );
      }),
    ];
  }

  List<Widget> drawerButtons() {
    return [
      Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, "/add_photo");
          },
          style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              shadowColor: Colors.transparent,
              side: const BorderSide(
                width: 1,
                color: Colors.grey,
              )),
          child: Stack(
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    LineIcons.camera,
                    color: Colors.grey,
                  )),
              SizedBox(width: 60),
              Center(
                  child: Text(
                'Add photo',
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
            ],
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, "/personal_gallery");
          },
          style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              shadowColor: Colors.transparent,
              side: const BorderSide(
                width: 1,
                color: Colors.grey,
              )),
          child: Stack(
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    LineIcons.image,
                    color: Colors.grey,
                  )),
              Center(
                  child: Text(
                'Personal gallery',
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
            ],
          ),
        ),
      ),
      SizedBox(height: 390),
      Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/user_settings');
          },
          style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              shadowColor: Colors.transparent,
              side: const BorderSide(
                width: 1,
                color: Colors.grey,
              )),
          child: Stack(
            children: <Widget>[
              Center(
                child: Text(
                  'Settings',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.settings_sharp,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ElevatedButton(
            onPressed: baseAuth.signOut,
            style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shadowColor: Colors.transparent,
                side: const BorderSide(
                  width: 1,
                  color: Colors.black,
                )),
            child: Stack(
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    )),
                SizedBox(width: 70),
                Center(
                    child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
              ],
            )),
      ),
    ];
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(41.560027, 14.667530),
    zoom: 5,
  );
}
