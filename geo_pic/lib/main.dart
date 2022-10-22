import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'UI/LoginRegistrationPages/home_page.dart';
import 'UI/LoginRegistrationPages/login_page.dart';
import 'UI/LoginRegistrationPages/registration_page.dart';
import 'UI/MainPages/add_photo.dart';
import 'UI/MainPages/main_page.dart';
import 'UI/MainPages/personal_gallery.dart';
import 'UI/Settings/password_recovery.dart';
import 'UI/Settings/user_settings.dart';
import 'ViewModels/gallery_model.dart';
import 'ViewModels/marker_model.dart';
import 'ViewModels/userdata_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<InternetConnectionStatus>(
        create: (_) => InternetConnectionChecker().onStatusChange,
    initialData:  InternetConnectionStatus.connected,
    child: MaterialApp(
      routes: {
        '/home_page': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/registration': (context) => RegistrationPage(),
        '/password_recovery': (context) => PasswordRecovery(),
        '/add_photo': (context) => AddPhoto(),

        ///MainPage è wrappata in un ChangeNotifierProvider<MarkerModel> e in un ChangeNotifierProvider<UserDataModel>
        '/main_page': (context) => ChangeNotifierProvider<MarkerModel>(
              create: (_) => MarkerModel(),
              child: ChangeNotifierProvider<UserDataModel>(
                create: (_) => UserDataModel(),
                child: MainPage(),
              ),
            ),

        ///PersonalGallery è wrappata in un ChangeNotifierProvider<GalleryModel>
        '/personal_gallery': (context) => ChangeNotifierProvider<GalleryModel>(
            create: (_) => GalleryModel(), child: PersonalGallery()),

        ///UserSetting è wrappata in un ChangeNotifierProvider<UserDataModel>
        '/user_settings': (context) => ChangeNotifierProvider<UserDataModel>(
            create: (_) => UserDataModel(), child: Settings()),
      },
      title: 'GeoPic',
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    ));
  }
}
