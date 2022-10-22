import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geo_pic/model/user_image.dart';
import 'package:geo_pic/services/database_service.dart';

///ChangeNotifier,attraverso il metodo notifyListener informa tutti i consumer di UserImage
class MarkerModel extends ChangeNotifier{

  DataManagerRT _dataManager = DataManagerRT();

  late StreamSubscription<Event> _imageStream;

  late List<UserImage> _images = [];

  List<UserImage> get images =>  _images;

  MarkerModel(){
    _listenToImages();
  }

  void _listenToImages(){
    _imageStream = _dataManager.photos.onValue.listen((event) {
      _images = [];
      Map _allUsersImages = event.snapshot.value;
      _allUsersImages.forEach((key, value) {
        final allImages = Map<String,dynamic>.from(value);
         _images.addAll(allImages.values.map((imageJson) =>
         UserImage.fromJson(Map<String,dynamic>.from(imageJson))).toList());
         notifyListeners();
      });
    });
  }

  @override
  void dispose(){
    _imageStream.cancel();
    super.dispose();
  }
}