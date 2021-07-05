import 'package:cap_driver/screens/login.dart';
import 'package:cap_driver/screens/mainpage.dart';
import 'package:cap_driver/screens/registeration.dart';
import 'package:cap_driver/screens/vehicleinfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
            appId: '1:258088443921:ios:4404b8c7db6c4894f4d1b0',
            apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
            projectId: 'flutter-firebase-plugins',
            messagingSenderId: '258088443921',
            databaseURL: 'https://geetaxi-dad9c-default-rtdb.firebaseio.com',
          )
        : FirebaseOptions(
            appId: '1:258088443921:android:740e3531df862fccf4d1b0',
            apiKey: 'AIzaSyAlZs2dXoqS-I9PN1RDxsajKi9TGdDVw3s',
            messagingSenderId: '297855924061',
            projectId: 'flutter-firebase-plugins',
            databaseURL: 'https://geetaxi-dad9c-default-rtdb.firebaseio.com',
          ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User currentUser = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: (currentUser == null) ? RegistrationPage.id : MainPage.id,
      routes: {
        MainPage.id: (context) => MainPage(),
        RegistrationPage.id: (context) => RegistrationPage(),
        VehicleInfoPage.id: (context) => VehicleInfoPage(),
        LoginPage.id: (context) => LoginPage(),
      },
    );
  }
}
