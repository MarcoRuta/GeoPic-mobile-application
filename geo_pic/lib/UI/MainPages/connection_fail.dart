import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConnectionFail extends StatelessWidget {
  const ConnectionFail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 100, 0, 100),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
            Colors.blue,
            Colors.white,
          ])),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off,
            size: 250,
            color: Colors.blue),
            Text('No internet connection!',
              style: TextStyle(
                  fontWeight: FontWeight.bold
                  ,fontSize: 30,
                  )
            ),
            Text('Turn up your data for being able to use geoPic!',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                  ,fontSize: 15,
                )
            ),
          ],
        )
      ),
    );
  }
}
