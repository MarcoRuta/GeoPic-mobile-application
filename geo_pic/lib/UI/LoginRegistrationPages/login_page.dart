import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geo_pic/services/auth_service.dart';
import 'package:line_icons/line_icons.dart';

class LoginPage extends StatefulWidget {
  LoginPage();
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  BaseAuth baseAuth = Auth();
  late StreamSubscription<User?> _authStream;

  final loginFormKey = new GlobalKey<FormState>();
  late String _email;
  late String _password;
  bool passClear = true;

  bool validateAndSave() {
    final form = loginFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      String userId = await baseAuth.signIn(_email, _password);
      print('Signed id: $userId');
    }
  }

  @override
  void initState() {

    _authStream = baseAuth.authInstance.idTokenChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        Navigator.pop(context);
        Navigator.pushNamed(context, "/main_page");
      }
    });
    super.initState();
  }

  @override
  void dispose(){
    _authStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
    WillPopScope(onWillPop: (){
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home_page', (Route<dynamic> route) => false);
      return Future(() => true);
    },
    child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Sign in'),
        ),
        body: Form(
            key: loginFormKey,
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
                  children: logoAndTitle() + formAndButtons(),
                ))))));
  }

  List<Widget> logoAndTitle() {
    return [
      Image.asset(
        'assets/images/geo_pic_logo.png',
        scale: 3,
      ),
      const SizedBox(
        height: 40,
      )
    ];
  }

  List<Widget> formAndButtons() {
    return [
      Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Center(
          child: TextFormField(
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              icon: Icon(LineIcons.at),
              labelText: 'E-mail',
            ),
            validator: (value) =>
                value!.isEmpty ? 'e_mail can\'t be empty' : null,
            onSaved: (value) => _email = value!,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Center(
          child: TextFormField(
            obscureText: passClear,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(passClear ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  if(mounted) {
                    setState(() {
                      passClear = !passClear;
                    });
                  }
                },
              ),
              border: UnderlineInputBorder(),
              filled: true,
              icon: Icon(LineIcons.key),
              labelText: 'Password',
            ),
            validator: (value) =>
                value!.isEmpty ? 'password can\'t be empty' : null,
            onSaved: (value) => _password = value!,
          ),
        ),
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/password_recovery');
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: RichText(
          text: const TextSpan(
            text: 'Forgot your password?',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.blue,
            ),
          ),
        ),
      ),
      Container(
          margin: const EdgeInsets.all(0),
          width: 500,
          child: Center(
            child: Container(
              width: 200,
              child: ElevatedButton(
                  onPressed: validateAndSubmit,
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
          )),
      const SizedBox(height: 350),
    ];
  }
}
