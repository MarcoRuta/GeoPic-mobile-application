import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geo_pic/model/user_image.dart';
import 'package:geo_pic/services/auth_service.dart';
import 'package:geo_pic/services/database_service.dart';

///ChangeNotifier,attraverso il metodo notifyListener informa tutti i consumer di UserImage
class GalleryModel extends ChangeNotifier{

  final Auth _auth = Auth();
  final DataManagerRT _dataManager = DataManagerRT();

  late StreamSubscription<Event> _galleryStream;

  late List<UserImage> _gallery = [];

  List<UserImage> get gallery => _gallery;

  GalleryModel(){
    _listenToGallery();
  }

  void _listenToGallery(){
    _galleryStream = _dataManager.photos.child(_auth.authInstance.currentUser!.uid).onValue.listen((event) {
      if(event.snapshot.value != null){
      final allImages = Map<String,dynamic>.from(event.snapshot.value);
      _gallery = allImages.values.map((imageJson) =>
          UserImage.fromJson(Map<String,dynamic>.from(imageJson))).toList();
      notifyListeners();
      }
      else{
        _gallery = [];
        notifyListeners();
      }
    });
  }


  @override
  void dispose(){
    _galleryStream.cancel();
    super.dispose();
  }
}