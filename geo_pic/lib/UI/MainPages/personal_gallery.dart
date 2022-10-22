import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geo_pic/UI/MainPages/photo_details.dart';
import 'package:geo_pic/ViewModels/gallery_model.dart';
import 'package:geo_pic/services/auth_service.dart';
import 'package:geo_pic/services/database_service.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'connection_fail.dart';

class PersonalGallery extends StatelessWidget {
  PersonalGallery({Key? key}) : super(key: key);

  final BaseAuth auth = Auth();
  final DataManagerRT _dataManager = DataManagerRT();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your gallery'),
        actions: [
          IconButton(
              onPressed: () {
                Fluttertoast.showToast(
                    msg:
                        'Single tap for picture details\n Long tap to delete the picture',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 8,
                    backgroundColor: Colors.indigoAccent,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
              icon: Icon(Icons.info_outline))
        ],
      ),
      body: (Provider.of<InternetConnectionStatus>(context) == InternetConnectionStatus.disconnected) ? ConnectionFail() :
      Consumer<GalleryModel>(builder: (context, model, child) {
        if (model.gallery.isEmpty) {
          return Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                    Colors.white,
                    Colors.blue,
                  ])),
              child: const Center(
                child: Text('you haven\'t uploaded any photos yet!'),
              ));
        }

        List<Widget> photoFrames = [];
        for (var element in model.gallery) {
          photoFrames.add(
            GestureDetector(
              onLongPress: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Do you want to delete the pic named: \n"' +
                          element.place +
                          '"'),
                      content: SingleChildScrollView(
                        child: ListBody(),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () {
                            deletePic(element.downloadUrl, element.Userid);
                            Navigator.of(context).pop();
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
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PhotoDetails(element)),
                );
              },
              child: Container(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    width: double.infinity,
                    child: FadeInImage.memoryNetwork(
                      fit: BoxFit.cover,
                      placeholder: kTransparentImage,
                      image: element.downloadUrl,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.0),
                ),
              ),
            ),
          );
        }
        return Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                  Colors.white,
                  Colors.blue,
                ])),
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              children: photoFrames,
            ));
      }),
    );
  }

  void deletePic(String downloadUrl, String uid) {
    _dataManager.deleteImageFile(downloadUrl);
    _dataManager.deleteImage(downloadUrl, uid);
  }
}
