import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

User currentFirebaseUser;

StreamSubscription<Position> homeTapPositionStream;

String mapKey = 'AIzaSyAlZs2dXoqS-I9PN1RDxsajKi9TGdDVw3s';

final CameraPosition googlePlex =
    CameraPosition(target: LatLng(30.104218, 31.376181), zoom: 18);

DatabaseReference tripRequestRef;
