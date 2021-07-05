import 'package:cap_driver/datamodels/tripdetails.dart';
import 'package:cap_driver/widgets/Notificationdialog.dart';
import 'package:cap_driver/widgets/progressDialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cap_driver/globalvars.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationService {
  final FirebaseMessaging fcm = FirebaseMessaging();
  Future initialize(context) async {
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        fetchRideInfo(getRideID(message), context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        fetchRideInfo(getRideID(message), context);
      },
      onResume: (Map<String, dynamic> message) async {
        fetchRideInfo(getRideID(message), context);
      },
    );
  }

  // ignore: missing_return
  Future<String> getToken() async {
    String token = await fcm.getToken();
    print('token: $token');
    DatabaseReference tokenRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentFirebaseUser.uid}/tokrn');
    tokenRef.set(token);

    fcm.subscribeToTopic('alldrivers');
    fcm.subscribeToTopic('allusers');
  }

  String getRideID(Map<String, dynamic> message) {
    String rideID = '';
    rideID = message['data']['ride_id'];
    print('Ride ID: $rideID');
    return rideID;
  }

  void fetchRideInfo(String rideId, context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Fetching Data',
      ),
    );

    DatabaseReference rideRef =
        FirebaseDatabase.instance.reference().child('rideRequest/$rideId');
    rideRef.once().then((DataSnapshot snapshot) {
      Navigator.pop(context);
      if (snapshot.value != null) {
        double pickupLat =
            double.parse(snapshot.value['location']['latitude'].toString());
        double pickupLng =
            double.parse(snapshot.value['location']['longitude'].toString());
        String pickupAddress = snapshot.value['pickup_address'].toString();
        double destinationLat =
            double.parse(snapshot.value['destination']['latitude'].toString());
        double destinationLng =
            double.parse(snapshot.value['destination']['longitude'].toString());
        String destinationAddress =
            snapshot.value['destination_address'].toString();

        TripDetails tripDetails = TripDetails();
        tripDetails.rideID = rideId;
        tripDetails.pickupAddress = pickupAddress;
        tripDetails.destinationAddress = destinationAddress;
        tripDetails.pickup = LatLng(pickupLat, pickupLng);
        tripDetails.destination = LatLng(destinationLat, destinationLng);

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => NotificationDialog(
                  tripDetails: tripDetails,
                ));
      }
    });
  }
}
