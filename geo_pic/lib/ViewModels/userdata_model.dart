import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geo_pic/services/auth_service.dart';
import 'package:geo_pic/services/database_service.dart';

///ChangeNotifier,attraverso il metodo notifyListener informa tutti i consumer di UserDataModel
class UserDataModel extends ChangeNotifier{

  final DataManagerRT _dataManager = DataManagerRT();
  final Auth _auth = Auth();

  late StreamSubscription<Event> _userStream;

  late String _username = '';
  late String _email = '';

  String get username =>  _username;
  String get email =>  _email;

  UserDataModel(){
    _listenToUser();
  }

  void _listenToUser(){
    _userStream = _dataManager.users.child(_auth.authInstance.currentUser!.uid).onValue.listen((event) {
      Map _userdata = event.snapshot.value;
      _username = _userdata['username'];
      _email = _userdata['email'];
      notifyListeners();
    });
  }

  @override
  void dispose(){
    _userStream.cancel();
    super.dispose();
  }
}