import 'package:cap_driver/screens/mainpage.dart';
import 'package:cap_driver/screens/registeration.dart';
import 'package:cap_driver/widgets/progressDialog.dart';
import 'package:cap_driver/widgets/taxibutton.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title) {
    final snackbar = SnackBar(
        content: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15.0),
    ));
    // ignore: deprecated_member_use
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void login() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Logging you in',
      ),
    );

    UserCredential user;
    try {
      user = await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        showSnackBar('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showSnackBar('Wrong password, Please provide the right one.');
      }
    }
    if (user != null) {
      DatabaseReference userRef = FirebaseDatabase.instance
          .reference()
          .child('drivers/${user.user.uid}');
      userRef.once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainPage.id, (route) => false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Image(
                        image: AssetImage('images/logo.png'),
                        alignment: Alignment.center,
                        height: 150.0,
                        width: 150.0,
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Text(
                        'Sign in as Driver',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 25.0, fontFamily: 'Brand-Bold'),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'E-mail address',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(height: 60),
                      TaxiButton(
                        text: "Login",
                        color: Colors.yellow[700],
                        onPressed: () async {
                          //check connectivity
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            showSnackBar('You are Offline');
                            return;
                          }
                          if (!emailController.text.contains('@')) {
                            showSnackBar('Something wrong with the email');
                          }
                          if (passwordController.text.length == 0) {
                            showSnackBar('Please add your password');
                          }
                          if (passwordController.text.length < 6) {
                            showSnackBar('Please add your Right password');
                          }
                          login();
                        },
                      ),
                      SizedBox(height: 20),
                      // ignore: deprecated_member_use
                      FlatButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, RegistrationPage.id, (route) => false);
                        },
                        child: Text(
                          'Don\'t have an account? Sign up',
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            ClipPath(
              clipper: WaveClipperTwo(flip: true, reverse: true),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 149,
                    color: Colors.yellow[700],
                    child: Center(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
