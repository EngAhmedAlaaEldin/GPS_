import 'package:flutter/material.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GPS")),
    );
  }
}

Location location = Location();
PermissionStatus? permissionStatus;
bool isServiceEnable = false;
LocationData? locationData;

void getCurrentLocation() async {
  bool permission = await ispermissionGranted();
  if (!permission) return;
  bool service = await isServiceeEnable();

  if (!service) return;
  location.getLocation();
  locationData = await location.getLocation();
  print("------------------------------------------------------------------------");
  print("lat:${locationData!.latitude},long:${locationData!.longitude}");
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
