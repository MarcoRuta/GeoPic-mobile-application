import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geo_pic/model/app_user.dart';
import 'package:geo_pic/model/user_image.dart';
import 'package:path/path.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

///Implementazione astratta del datamanager
abstract class DataManager {
  Future<String> uploadImageFile(
      BuildContext context, File? fileName, String userId);

  Future<void> deleteImageFile(String downloadUrl);

  Future<void> createImage(UserImage image);

  Future<void> deleteImage(String id, String idu);

  Future<void> createUser(AppUser user);

  Future<Map<dynamic, dynamic>> getUser(String id);

  bool updateUser(AppUser user);

  Future<bool> deleteUser(String id);
}

///implementazione del data manager
class DataManagerRT implements DataManager {
  ///reference alla collezione 'users' su Firebase realtime database
  final users = FirebaseDatabase(
          databaseURL:
              'https://geopic-f1080-default-rtdb.europe-west1.firebasedatabase.app/')
      .reference()
      .child('users');

  ///reference alla collezione 'photos' su Firebase realtime database
  final photos = FirebaseDatabase(
          databaseURL:
              'https://geopic-f1080-default-rtdb.europe-west1.firebasedatabase.app/')
      .reference()
      .child('photos');

  ///reference alla collezione 'sharedPhotos' su Firebase storage
  final imagesFiles = FirebaseStorage.instance.ref().child('SharedPhotos');

  ///CREATE USER
  ///Metodo che consente di salvare i dati di un AppUser
  ///@param: l'AppUser di cui si vogliono salvare i dati
  ///nel caso di eccezioni viene segnalato attraverso un Toast cosa ha sollevato tale eccezione
  @override
  Future<void> createUser(AppUser user) async {
    await users
        .child(user.idU)
        .set({'username': user.username, 'email': user.e_mail}).catchError((e) {
      Fluttertoast.showToast(
          msg: e.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.indigoAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  ///DELETE USER
  ///Metodo che consente di eliminare i dati i un AppUser
  ///@param l' id dell'utente da rimuovere
  ///nel caso di eccezioni viene segnalato attraverso un Toast cosa ha sollevato tale eccezione
  @override
  Future<bool> deleteUser(String _id) async {
    await users.child(_id).remove().catchError((e) {
      Fluttertoast.showToast(
          msg: e.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.indigoAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    });
    return true;
  }

  ///GET USER
  ///Metodo che consente di recuperare i dati di un AppUser
  ///@param l'id dell'utente che si vuole cercare
  ///@return i dati dell'utente ricercato
  ///nel caso di eccezioni viene segnalato attraverso un Toast cosa ha sollevato tale eccezione
  @override
  Future<Map<dynamic, dynamic>> getUser(String _id) async {
    return await users.child(_id).once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      return values;
    }).catchError((e) {
      Fluttertoast.showToast(
          msg: e.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.indigoAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  ///UPDATE USER
  ///Metodo che consente di aggiornare i dati di un AppUser
  ///@param AppUser, i nuovi dati relativi all'utente
  ///@return true se la modifica è andata a buon fine altrimenti false
  @override
  bool updateUser(AppUser user) {
    users.child(user.idU).update(
        {"username": user.username, "email": user.e_mail}).catchError((e) {
      Fluttertoast.showToast(
          msg: e.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.indigoAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    });
    return true;
  }

  ///CREATE IMAGE FILE
  ///Metodo che consente di caricare una foto su firebase storage
  ///@parameters: context, il file da caricare, l'id dell' utente che lo sta caricando
  ///@return: l'url di download del file
  @override
  Future<String> uploadImageFile(
      BuildContext context, File? _file, String userId) async {
    String _fileName = basename(_file!.path);

    Reference _path = imagesFiles.child(_fileName);

    String _downloadUrl = '';

    UploadTask task = _path.putFile(_file);

    try {
      TaskSnapshot snapshot = await task;
      print('Uploaded ${snapshot.bytesTransferred} bytes.');
      _downloadUrl = await _path.getDownloadURL().then((value) => value);
      return _downloadUrl;
    } on FirebaseException catch (e) {
      print(task.snapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
      return _downloadUrl;
    }
  }

  Future<void> deleteImageFile(String url) async {
    Reference ref = FirebaseStorage.instance.refFromURL(url);
    await ref.delete().catchError((e) {
      Fluttertoast.showToast(
          msg: e.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.indigoAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  ///CREATE USERIMAGE
  ///Metodo che consente di salvare i dati di un immagine caricata da utente
  ///@param: l'immagine di cui si volgiono caricare i dati
  ///nel caso di eccezioni viene segnalato attraverso un Toast cosa ha sollevato tale eccezione
  @override
  Future<void> createImage(UserImage image) async {
    await photos
        .child(image.Userid)
        .child(
            image.Userid + (DateTime.now().millisecondsSinceEpoch.toString()))
        .set(image.toJson());
  }

  @override
  Future<void> deleteImage(String url, String idu) async {
    await photos.child(idu).once().then((value) {
      Map nextImage = value.value;
      nextImage.forEach((key, value) {
        if (value['downloadUrl'] == url) {
          photos.child(idu).child(key).remove().catchError((e) {
            Fluttertoast.showToast(
                msg: e.message.toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.indigoAccent,
                textColor: Colors.white,
                fontSize: 16.0);
          });
        }
      });
    });
  }

  @override
  Future<void> deleteAccountData(String id) async {

    await photos.child(id).get().then((value){
      final allImages = Map<String,dynamic>.from(value.value);
      List<UserImage> images = allImages.values.map((imageJson) =>
          UserImage.fromJson(Map<String,dynamic>.from(imageJson))).toList();
      images.forEach((element) {
        deleteImageFile(element.downloadUrl);
      });
    });

    await photos.child(id).remove();
    await users.child(id).remove();
  }

}
