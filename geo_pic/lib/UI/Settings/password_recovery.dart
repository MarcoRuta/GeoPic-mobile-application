import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geo_pic/services/auth_service.dart';

class PasswordRecovery extends StatelessWidget {
  BaseAuth _baseAuth = Auth();
  TextEditingController e_mailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Recover your password'),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                Colors.white,
                Colors.blue,
              ])),
          child: Column(
            children: text() + formAndButtons(context),
          ),
        ));
  }

  List<Widget> text() {
    return [
      SizedBox(height: 50),
      Container(
          margin: const EdgeInsets.all(30),
          child: Text(
            'Enter the email with which you registered with GeoPic.\n \n'
            'You will receive an email containing the instructions to recover your password!',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ))
    ];
  }

  List<Widget> formAndButtons(BuildContext context) {
    return [
      SizedBox(height: 10),
      Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Center(
          child: TextFormField(
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              icon: Icon(Icons.mail),
              labelText: 'E-mail',
            ),
            validator: (value) =>
                value!.isEmpty ? 'e_mail can\'t be empty' : null,
            controller: e_mailController,
          ),
        ),
      ),
      Container(
          margin: const EdgeInsets.all(0),
          width: 200,
          child: Container(
            child: ElevatedButton(
                onPressed: () => validateAndSubmit(context),
                style: ElevatedButton.styleFrom(
                    primary: Colors.white70,
                    shadowColor: Colors.transparent,
                    side: const BorderSide(
                      width: 1,
                      color: Colors.blue,
                    )),
                child: const Text('Send Email',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ))),
          ))
    ];
  }

  void validateAndSubmit(BuildContext context) async {
    if (await _baseAuth.passwordRecovery(e_mailController.text)) {
      Fluttertoast.showToast(
          msg: "Check your in-box!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.indigoAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
    }
  }
}
