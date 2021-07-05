import 'package:cap_driver/brand_colors.dart';
import 'package:cap_driver/datamodels/tripdetails.dart';
import 'package:cap_driver/globalvars.dart';
import 'package:cap_driver/screens/newtrippage.dart';
import 'package:cap_driver/widgets/TaxiOutlineButton.dart';
import 'package:cap_driver/widgets/progressDialog.dart';
import 'package:cap_driver/widgets/taxibutton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class NotificationDialog extends StatelessWidget {
  final TripDetails tripDetails;
  NotificationDialog({this.tripDetails});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30,
            ),
            Image.asset(
              'images/taxi.png',
              width: 100,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'NEW TRIP REQUEST',
              style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 18),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'images/pickicon.png',
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            tripDetails.pickupAddress,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'images/desticon.png',
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            tripDetails.destinationAddress,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: TaxiOutlineButton(
                              color: BrandColors.colorLightGray,
                              title: 'DECLINE',
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Container(
                          child: TaxiButton(
                            color: BrandColors.colorGreen,
                            text: 'ACCEPT',
                            onPressed: () async {
                              checkAvailbility(context);
                            },
                          ),
                        ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkAvailbility(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ProgressDialog(
              status: 'Accepting request',
            ));

    DatabaseReference newRideRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentFirebaseUser.uid}/newTrip');
    newRideRef.once().then((DataSnapshot snapshot) {
      Navigator.pop(context);
      Navigator.pop(context);
      String thisRideID = "";
      if (snapshot.value != null) {
        thisRideID = snapshot.value.toString();
      } else {
        print('ride is not found');
      }

      if (thisRideID == tripDetails.rideID) {
        newRideRef.set('accepted');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewTripPage(
                    tripDetails: tripDetails,
                  )),
        );
      } else if (thisRideID == 'cancelled') {
        Toast.show("Ride has been cancelled", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else if (thisRideID == 'timeout') {
        Toast.show("Ride has time out", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Ride is not found", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
  }
}
