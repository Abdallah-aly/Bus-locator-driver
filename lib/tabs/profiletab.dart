// import 'dart:js';

import 'package:cap_driver/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  Future<void> signOut(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, LoginPage.id, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // ignore: deprecated_member_use
      child: RaisedButton(
        child: Text('Log Out'),
        onPressed: () {
          signOut(context);
        },
        color: Colors.yellow[600],
      ),
    );
  }
}
