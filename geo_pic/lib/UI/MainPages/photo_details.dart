import 'package:flutter/material.dart';
import 'package:geo_pic/model/user_image.dart';
import 'package:geo_pic/services/location_service.dart';
import 'package:line_icons/line_icons.dart';
import 'package:transparent_image/transparent_image.dart';

class PhotoDetails extends StatefulWidget {
  final UserImage image;
  PhotoDetails(this.image);

  @override
  _PhotoDetailsState createState() => _PhotoDetailsState();
}

class _PhotoDetailsState extends State<PhotoDetails> {
  late String position = '';

  @override
  void initState() {
    super.initState();
    getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(title: Text('Photo')),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue[200],
        ),
        child: SingleChildScrollView(
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: widget.image.downloadUrl,
                ),
                ListTile(
                  leading: Icon(LineIcons.camera),
                  title: Text(widget.image.place),
                  subtitle: Text(
                    position,
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.image.description,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.image.username,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black.withOpacity(0.9)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getAddress() async {
    position = await LocationManager.GetAddressFromLatLong(
        widget.image.lat, widget.image.lon);
    setState(() {});
  }
}
