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
  Set<Marker> marker = {};

  CameraPosition UpdatemyLocation = CameraPosition(
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

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GPS"),
      ),
      body: locationData == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: MapType.hybrid,
              markers: marker,
              onTap: (argument) {
                marker.add(Marker(
                    markerId: MarkerId("new$count"), position: argument));
                count++;
                setState(() {});
              },
              initialCameraPosition: currentLocation,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
    );
  }

  Future<void> updateMyLocation() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            zoom: 18,
            target:
                LatLng(locationData!.latitude!, locationData!.longitude!))));
  }

  Location location = Location();
  PermissionStatus? permissionStatus;
  bool isServiceEnable = false;
  LocationData? locationData;
  StreamSubscription<LocationData>? subscription;
  CameraPosition currentLocation = CameraPosition(
    target: LatLng(27, 2345676543),
    zoom: 14.4746,
  );

  void getCurrentLocation() async {
    bool permission = await ispermissionGranted();
    if (!permission) return;
    bool service = await isServiceeEnable();

    if (!service) return;
    location.getLocation();
    locationData = await location.getLocation();
    marker.add(Marker(
        markerId: MarkerId("myLocation"),
        position: LatLng(locationData!.latitude!, locationData!.longitude!)));
    currentLocation = CameraPosition(
      target: LatLng(locationData!.latitude!, locationData!.longitude!),
      zoom: 19.4746,
    );
    subscription = location.onLocationChanged.listen((event) {
      locationData = event;
      marker.add(Marker(
          markerId: MarkerId("myLocation"),
          position: LatLng(event.latitude!, event.longitude!)));
      updateMyLocation();
      setState(() {});
      location.changeSettings(accuracy: LocationAccuracy.high);
      print("lat:${locationData!.latitude},long:${locationData!.longitude}");
    });
    location.changeSettings(accuracy: LocationAccuracy.high);
    setState(() {});
  }

  Future<bool> isServiceeEnable() async {
    isServiceEnable = await location.serviceEnabled();
    if (!isServiceEnable) {
      isServiceEnable = await location.requestService();
    }
    return isServiceEnable;
  }

  Future<bool> ispermissionGranted() async {
    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      return permissionStatus == PermissionStatus.granted;
    }
    return permissionStatus == PermissionStatus.granted;
  }
}
