import 'package:cap_driver/globalvars.dart';
import 'package:cap_driver/screens/mainpage.dart';
import 'package:cap_driver/widgets/taxibutton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class VehicleInfoPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  static const String id = 'vehicleinfo';

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

  var carModelController = TextEditingController();
  var carColorController = TextEditingController();
  var vehicleNumberController = TextEditingController();

  void updateProfile(context) {
    String id = currentFirebaseUser.uid;
    DatabaseReference driverRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/$id/vehicle_details');

    Map map = {
      'car_color': carColorController.text,
      'car_model': carModelController.text,
      'vehicle_number': vehicleNumberController.text,
    };
    driverRef.set(map);
    Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Image.asset(
              'images/logo.png',
              height: 110,
              width: 110,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Text(
                    'Enter vehicle details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //car model
                  TextField(
                    controller: carModelController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Car model',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //car color
                  TextField(
                    controller: carColorController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Car color',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //vehicle number
                  TextField(
                    controller: vehicleNumberController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Vehicle number',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TaxiButton(
                    color: Colors.yellow[700],
                    text: 'PROCEED',
                    onPressed: () {
                      if (carModelController.text.length < 3) {
                        showSnackBar('Please Provide a valid car model');
                        return;
                      }
                      if (carColorController.text.length < 3) {
                        showSnackBar('Please Provide a valid car color');
                        return;
                      }
                      if (vehicleNumberController.text.length < 3) {
                        showSnackBar('Please Provide a valid vehicle number');
                        return;
                      }

                      updateProfile(context);
                    },
                  )
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
