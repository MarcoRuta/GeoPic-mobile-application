import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GeoPic')),
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: SpinKitRotatingCircle(color: Colors.blue),
        ),
      ),
    );
  }
}
