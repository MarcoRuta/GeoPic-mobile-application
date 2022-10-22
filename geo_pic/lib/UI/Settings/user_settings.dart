import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geo_pic/UI/Settings/password_field.dart';
import 'package:geo_pic/ViewModels/userdata_model.dart';
import 'package:geo_pic/model/app_user.dart';
import 'package:geo_pic/services/auth_service.dart';
import 'package:geo_pic/services/database_service.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

enum PageState {
  ready,
  waiting,
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confPassController = TextEditingController();

  bool passClear = true;
  PageState status = PageState.waiting;
  late String username = '';
  late String e_mail = '';
  late String newPass = '';
  late String newPassConf = '';
  late String newUsername = '';

  DataManagerRT _datamanager = DataManagerRT();
  BaseAuth baseAuth = Auth();
  final pwFormKey = new GlobalKey<FormState>();

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Consumer<UserDataModel>(
          builder: (context, model, child) {
            return SettingsList(
              sections: [
                SettingsSection(
                  tiles: [
                    SettingsTile(
                      title: 'Change your username',
                      subtitle: model.username,
                      leading: Icon(LineIcons.userEdit),
                      onPressed: (BuildContext context) {
                        _changeUsDialog();
                      },
                    ),
                    SettingsTile(
                      title: 'Change your password',
                      leading: Icon(LineIcons.key),
                      onPressed: (BuildContext context) {
                        _changePwDialog();
                      },
                    ),
                    SettingsTile(
                      title: 'Delete your account',
                      leading: Icon(Icons.delete,
                      color: Colors.grey),
                      onPressed: (BuildContext context) {
                        _deleteAccountDialog();
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ));
  }

  Future<void> _changeUsDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change your username'),
          content: SingleChildScrollView(
            child: ListBody(
              children: _formUsChange(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                if (usernameController.text.length >= 1 && usernameController.text.length < 21) {
                  _changeUs(newUsername);
                  Navigator.of(context).pop();
                } else {
                  Fluttertoast.showToast(
                      msg: "The username must be between 1 and 20 characters",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.indigoAccent,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                usernameController.clear();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future<void> _changePwDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change your password'),
          content: SingleChildScrollView(
            child: Form(
              key: pwFormKey,
              child: ListBody(
                children: _formPwChange(),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                if (passController.text == confPassController.text) {

                  if(passController.text.length<6){
                    Fluttertoast.showToast(
                        msg: "Password should be at least 6 character",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 3,
                        backgroundColor: Colors.indigoAccent,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }

                  else {
                    _changePw(passController.text);
                    Navigator.of(context).pop();
                  }
                }
                else {
                  Fluttertoast.showToast(
                      msg: "Passwords are not equals",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.indigoAccent,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }},
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                passController.clear();
                confPassController.clear();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future<void> _deleteAccountDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete your account?\nAll your pics will be lost forever.'),
          actions: <Widget>[
            TextButton(
                child: const Text('Approve'),
                onPressed: () {
                  deleteAccount();
                  Navigator.of(context).pop();
                }
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  List<Widget> _formPwChange() {
    return [
      Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Center(
          child: PasswordField(
            controller: passController,
            validator: (value) => value!.isEmpty || value.length < 6 ?
                'the password must be at least 6 characters' : null,
            hintText: 'Insert your new password',
            labelText: 'New password',
            onFieldSubmitted: (String value) {
              setState(() {
                newPass = value;
              });
            },
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Center(
          child: PasswordField(
            controller: confPassController,
            validator: (value) =>
              value!.isEmpty || value.length < 6 ? 'the password must be at least 6 characters' : null,
            hintText: 'Insert your new password',
            labelText: 'Confirm password',
            onFieldSubmitted: (String value) {
              setState(() {
                newPassConf = value;
              });
            },
          ),
        ),
      ),
    ];
  }

  List<Widget> _formUsChange() {
    return [
      Container(
        margin: const EdgeInsets.fromLTRB(25, 0, 25, 10),
        child: Center(
          child: TextFormField(
            textCapitalization: TextCapitalization.words,
            controller: usernameController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              icon: Icon(LineIcons.user),
              labelText: 'Username',
            ),
          ),
        ),
      ),
    ];
  }

  Future<void> deleteAccount() async {
    String id =  await baseAuth.authInstance.currentUser!.uid;
    _datamanager.deleteAccountData(id);
    baseAuth.authInstance.currentUser!.delete();
  }

  Future<void> _changePw(newPassword) async {
    if(await baseAuth.changePassword(newPassword) == true){
      Fluttertoast.showToast(
          msg: 'Password successfully changed!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.indigoAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    passController.clear();
    confPassController.clear();
  }

  Future<void> _changeUs(newUsername) async {
    _datamanager.updateUser(AppUser(baseAuth.authInstance.currentUser!.uid,
        usernameController.text, baseAuth.authInstance.currentUser!.email!));
    usernameController.clear();
  }
}
