// Flutter
import 'package:flutter/material.dart';

// Utilities
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateWalkUpdateView extends StatefulWidget {
  const CreateWalkUpdateView({Key? key}) : super(key: key);

  @override
  State<CreateWalkUpdateView> createState() => _CreateWalkUpdateViewState();
}

class _CreateWalkUpdateViewState extends State<CreateWalkUpdateView> {
  GoogleMapController? mapController;

  Set<Polyline> polylines = {};
  List<LatLng> routePoints = [];

  @override
  void initState() {
    super.initState();
    initLocation();
  }

  Future<void> initLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    Geolocator.getPositionStream().listen((Position position) {
      addPointToRoute(LatLng(position.latitude, position.longitude));
    });
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void addPointToRoute(LatLng position) {
    if (routePoints.isEmpty) {
      routePoints.add(position);
    } else {
      double distance = Geolocator.distanceBetween(
        routePoints.last.latitude,
        routePoints.last.longitude,
        position.latitude,
        position.longitude,
      );

      double minDistance = 5;

      if (distance >= minDistance) {
        routePoints.add(position);
      }
    }

    updateRoute();
  }

  void updateRoute() {
    Polyline polyline = Polyline(
      polylineId: const PolylineId('Route principale'),
      visible: true,
      points: routePoints,
      color: Colors.orange,
    );

    polylines.add(polyline);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: const CameraPosition(target: LatLng(0, 0)),
      polylines: polylines,
    );
  }
}
