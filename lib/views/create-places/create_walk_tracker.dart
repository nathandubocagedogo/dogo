import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateWalkTracker extends StatefulWidget {
  const CreateWalkTracker({Key? key}) : super(key: key);

  @override
  State<CreateWalkTracker> createState() => _CreateWalkTrackerState();
}

class _CreateWalkTrackerState extends State<CreateWalkTracker> {
  GoogleMapController? mapController;
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
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
      _addPointToRoute(LatLng(position.latitude, position.longitude));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: LatLng(0, 0)),
      polylines: _polylines,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _addPointToRoute(LatLng position) {
    if (_routePoints.isEmpty) {
      _routePoints.add(position);
    } else {
      double distance = Geolocator.distanceBetween(
        _routePoints.last.latitude,
        _routePoints.last.longitude,
        position.latitude,
        position.longitude,
      );

      double minDistance = 5;

      if (distance >= minDistance) {
        _routePoints.add(position);
      }
    }

    _updateRoute();
  }

  void _updateRoute() {
    Polyline polyline = Polyline(
      polylineId: PolylineId('route1'),
      visible: true,
      points: _routePoints,
      color: Colors.blue,
    );

    _polylines.add(polyline);
  }
}
