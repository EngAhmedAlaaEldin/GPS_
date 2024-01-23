import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  void deactivate() {
    subscription?.cancel();
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GPS"), ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),

    );
  }
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

}


Location location = Location();
PermissionStatus? permissionStatus;
bool isServiceEnable = false;
LocationData? locationData;
StreamSubscription<LocationData>? subscription;

void getCurrentLocation() async {
  bool permission = await ispermissionGranted();
  if (!permission) return;
  bool service = await isServiceeEnable();

  if (!service) return;
  location.getLocation();
  locationData = await location.getLocation();
  subscription = location.onLocationChanged.listen((event) {
    locationData = event;
    location.changeSettings(accuracy: LocationAccuracy.high);
    print("lat:${locationData!.latitude},long:${locationData!.longitude}");
  });
}

Future<bool> isServiceeEnable() async {
  isServiceEnable = await location.serviceEnabled();
  if (!isServiceEnable) {
    isServiceEnable = await location.requestService();
  }
  return isServiceEnable;
}
///lllllllllllllllllllllllllllllllllllllllllllllllllllllll
Future<bool> ispermissionGranted() async {
  permissionStatus = await location.hasPermission();
  if (permissionStatus == PermissionStatus.denied) {
    permissionStatus = await location.requestPermission();
    return permissionStatus == PermissionStatus.granted;
  }
  return permissionStatus == PermissionStatus.granted;
}

