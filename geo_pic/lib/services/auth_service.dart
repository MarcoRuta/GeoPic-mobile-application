import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///Interfaccia del manager autenticazioni///
abstract class BaseAuth {
  FirebaseAuth authInstance = FirebaseAuth.instance;
  Future<String> signIn(String _email, String _password);
  Future<String> signUp(String _email, String _password);
  Future<void> deleteAccount();
  Future<void> signOut();
  Future<String> userId();
  Future<bool> passwordRecovery(String email);
  Future<bool> changePassword(String password);
}

///Implementazione del manager autenticazioni*/
class Auth implements BaseAuth {
  @override
  late FirebaseAuth authInstance = FirebaseAuth.instance;

  ///Metodo che restituisce l'uid dell'utente attualmente loggato
  @override
  Future<String> userId() async {
    return authInstance.currentUser!.uid;
  }

  ///Metodo che consente all'utente di accedere con username e password
  ///@params: _email, _password dell'utente
  ///@return: l'uid dell'utente se si è loggato correttamente
  ///nel caso di eccezioni viene segnalato attraverso un Toast cosa ha sollevato tale eccezione
  @override
  Future<String> signIn(String _email, String _password) async {
    UserCredential userCredential = await authInstance
        .signInWithEmailAndPassword(
      email: _email,
      password: _password,
    )
        .catchError((e) {
      Fluttertoast.showToast(
          msg: e.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.indigoAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    });
    return userCredential.user!.uid;
  }

  ///Metodo che consente all'utente di registrarsi con username e password
  ///@params: _email, _password dell'utente
  ///@return: l'uid dell'utente se si è loggato correttamente
  ///nel caso di eccezioni viene segnalato attraverso un Toast cosa ha sollevato tale eccezione
  @override
  Future<String> signUp(String _email, String _password) async {
    UserCredential userCredential = await authInstance
        .createUserWithEmailAndPassword(
      email: _email,
      password: _password,
    )
        .catchError((e) {
      Fluttertoast.showToast(
          msg: e.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.indigoAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    });
    Fluttertoast.showToast(
        msg: "logging..",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.indigoAccent,
        textColor: Colors.white,
        fontSize: 16.0);

    return userCredential.user!.uid;
  }

  ///Metodo che consente all'utente di eseguire il logout
  ///nel caso di eccezioni viene segnalato attraverso un Toast cosa ha sollevato tale eccezione
  @override
  Future<void> signOut() async {
    authInstance.signOut().catchError((e) {
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

  ///Metodo che consente all'utente di recuperare la propria password attraverso la propria e_mail
  ///@params: _email dell'utente
  ///@return: true se l'email è stata inviata correttamente, false altrimenti
  ///nel caso di eccezioni viene segnalato attraverso un Toast cosa ha sollevato tale eccezione
  @override
  Future<bool> passwordRecovery(String email) async {
    authInstance.sendPasswordResetEmail(email: email).catchError((e) {
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

  ///Metodo che consente all'utente di modificare la propria password
  ///@params: password la nuova password dell'utente
  ///@return: true se la password è stata cambiata correttamente, false altrimenti
  ///nel caso di eccezioni viene segnalato attraverso un Toast cosa ha sollevato tale eccezione
  @override
  Future<bool> changePassword(String password) async {
    authInstance.currentUser!.updatePassword(password).catchError((e) {
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

  @override
  Future<void> deleteAccount() async {
    authInstance.currentUser!.delete().catchError((e) {
      Fluttertoast.showToast(
          msg: 'Password successfully changed!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.indigoAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }
}
