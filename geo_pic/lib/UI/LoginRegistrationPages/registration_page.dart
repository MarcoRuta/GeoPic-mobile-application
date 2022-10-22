import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geo_pic/model/app_user.dart';
import 'package:geo_pic/services/auth_service.dart';
import 'package:geo_pic/services/database_service.dart';
import 'package:line_icons/line_icons.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  BaseAuth baseAuth = Auth();

  late StreamSubscription<User?> _authStream;
  final registrationFormKey = GlobalKey<FormState>();
  final DataManagerRT _datamanager = DataManagerRT();

  String _userId = "";
  String _username = "";
  String _email = "";
  String _password = "";
  String _passwordConf = "";
  bool passClear = true;

  @override
  void dispose(){
    _authStream.cancel();
    super.dispose();
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
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: (){
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home_page', (Route<dynamic> route) => false);
      return Future(() => true);
    },
    child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Sign up'),
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
              child: Form(
                  key: registrationFormKey,
                  child: Column(
                    children: logoAndTitle() + formAndButtons(),
                  ))),
        )));
  }

  List<Widget> logoAndTitle() {
    return [
      Image.asset(
        'assets/images/geo_pic_logo.png',
        height: 350,
      ),
    ];
  }

  List<Widget> formAndButtons() {
    return [
      SizedBox(height: 10),
      Container(
        margin: const EdgeInsets.fromLTRB(25, 0, 25, 10),
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
        margin: const EdgeInsets.fromLTRB(25, 0, 25, 10),
        child: Center(
          child: TextFormField(
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              icon: Icon(LineIcons.user),
              labelText: 'Username',
            ),
            validator: (value) => value!.length > 20 || value.length==0
                ? 'Insert a username of max 20 characters'
                : null,
            onSaved: (value) => _username = value!,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.fromLTRB(25, 0, 25, 10),
        child: Center(
          child: TextFormField(
            obscureText: passClear,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(passClear ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                if(mounted){
                setState(() {
                passClear = !passClear;
                });
                };
                },
              ),
              border: UnderlineInputBorder(),
              filled: true,
              icon: Icon(LineIcons.lock),
              labelText: 'Password',
            ),
            validator: (value) =>
                value!.isEmpty ? 'password can\'t be empty' : null,
            onSaved: (value) => _password = value!,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.fromLTRB(25, 0, 25, 10),
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
                  };
                },
              ),
              border: const UnderlineInputBorder(),
              filled: true,
              icon: const Icon(LineIcons.lock),
              labelText: 'Confirm password',
            ),
            validator: (value) =>
                value!.isEmpty ? 'password can\'t be empty' : null,
            onSaved: (value) => _passwordConf = value!,
          ),
        ),
      ),
      Container(
          margin: const EdgeInsets.fromLTRB(25, 0, 25, 10),
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
                child: const Text('Sign Up!',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ))),
          ))
    ];
  }

  bool validateAndSave() {
    final form = registrationFormKey.currentState;
    if (form!.validate()) {
      form.save();
      if (_password == _passwordConf)
        return true;
      else {
        Fluttertoast.showToast(
            msg: "Passwords don't match!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.indigoAccent,
            textColor: Colors.white,
            fontSize: 16.0);
        return false;
      }
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {

      try {
        _userId = await baseAuth.signUp(_email, _password);
        AppUser user = AppUser(_userId, _username, _email);
        _datamanager.createUser(user);
      } on FirebaseException catch (e) {
        Fluttertoast.showToast(
            msg: e.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.indigoAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      }

    }
  }
}
