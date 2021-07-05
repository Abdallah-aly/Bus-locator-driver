import 'dart:async';
import 'package:cap_driver/globalvars.dart';
import 'package:cap_driver/helpers/pushNotification.dart';
import 'package:cap_driver/widgets/availabilitybutton.dart';
import 'package:cap_driver/widgets/confirmsheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  var geolocator = Geolocator();
  var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 4);

  Position currentPosition;

  User currentUser = FirebaseAuth.instance.currentUser;

  String availabilityTitle = 'GO ONLINE';
  Color availabilitycolor = Colors.yellow[800];

  bool isAvailable = false;

  void getCurrentPosition() async {
    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(pos));
  }

  void getCurrentDriverInfo() async {
    // ignore: await_only_futures
    currentFirebaseUser = await FirebaseAuth.instance.currentUser;
    PushNotificationService pushNotificationService = PushNotificationService();
    pushNotificationService.initialize(context);
    pushNotificationService.getToken();
  }

  @override
  void initState() {
    super.initState();
    getCurrentDriverInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          padding: EdgeInsets.only(top: 500),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: googlePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            mapController = controller;
            getCurrentPosition();
          },
        ),
        //online button
        Container(
          height: 140,
          width: double.infinity,
          color: Colors.lightBlue[900],
        ),
        Positioned(
          top: 70,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AvailabilityButton(
                text: availabilityTitle,
                color: availabilitycolor,
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) => ConfirmSheet(
                            title: (!isAvailable) ? 'GO ONLINE' : 'GO OFFLINE',
                            subtitle: (!isAvailable)
                                ? 'You are about to become available to receive trip request'
                                : 'You will stop receiving ride requests',
                            onPress: () {
                              if (!isAvailable) {
                                goOnline();
                                getLocationUpdate();
                                Navigator.pop(context);
                                setState(() {
                                  availabilitycolor = Colors.redAccent[400];
                                  availabilityTitle = 'GO OFFLINE';
                                  isAvailable = true;
                                });
                              } else {
                                goOffline();
                                Navigator.pop(context);
                                setState(() {
                                  availabilitycolor = Colors.yellow[800];
                                  availabilityTitle = 'GO ONLINE';
                                  isAvailable = false;
                                });
                              }
                            },
                          ),
                      isDismissible: false);
                },
              )
            ],
          ),
        )
      ],
    );
  }

  void goOffline() {
    Geofire.removeLocation(currentUser.uid);
    tripRequestRef.onDisconnect();
    tripRequestRef.remove();
    tripRequestRef = null;
  }

  void goOnline() {
    Geofire.initialize('driversAvailable');
    Geofire.setLocation(
        currentUser.uid, currentPosition.latitude, currentPosition.longitude);
    tripRequestRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentUser.uid}/newtrip');
    tripRequestRef.set('waiting');
    tripRequestRef.onValue.listen((event) {});
  }

  void getLocationUpdate() {
    homeTapPositionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      currentPosition = position;
      if (isAvailable) {
        Geofire.setLocation(
            currentUser.uid, position.latitude, position.longitude);
      }
      LatLng pos = LatLng(position.latitude, position.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(pos));
    });
  }
}
