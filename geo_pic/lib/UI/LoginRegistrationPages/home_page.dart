import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:geo_pic/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<HomePage> {
  ///istanza dell' auth provider
  BaseAuth baseAuth = Auth();
  late StreamSubscription<User?> _authStream;

  @override
  void initState() {
    _authStream = baseAuth.authInstance.idTokenChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/main_page', (Route<dynamic> route) => false);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _authStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('GeoPic'),
        ),
        body: SingleChildScrollView(
            child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                      Colors.white,
                      Colors.blue,
                    ])),
                child: Column(
                  children: logoAndTitle() + formAndButtons(),
                ))));
  }

  List<Widget> logoAndTitle() {
    return [
      SizedBox(height: 0),
      Image.asset(
        'assets/images/geo_pic_logo.png',
      ),
      const Padding(
          padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Text(
            'GeoPic',
            style: TextStyle(
              fontSize: 65,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          )),
    ];
  }

  List<Widget> formAndButtons() {
    return [
      SizedBox(height: 10),
      Container(
        width: 200,
        child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
                primary: Colors.white70,
                shadowColor: Colors.transparent,
                side: const BorderSide(
                  width: 1,
                  color: Colors.blue,
                )),
            child: const Text('Login',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ))),
      ),
      Container(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/registration');
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: RichText(
                text: const TextSpan(
                  text: 'You are not registered yet? ',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Sign up!',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
