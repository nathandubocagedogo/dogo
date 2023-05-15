// Flutter
import 'package:flutter/material.dart';

// Models
import 'package:dogo_final_app/models/firebase/place.dart';

// Utilities
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MakeActivityView extends StatefulWidget {
  final Place place;

  const MakeActivityView({super.key, required this.place});

  @override
  State<MakeActivityView> createState() => _MakeActivityViewState();
}

class _MakeActivityViewState extends State<MakeActivityView> {
  GoogleMapController? mapController;
  Marker? userMarker;
  Stream<Position>? positionStream;

  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    createPolylines();
    startLocationUpdates();
  }

  void createPolylines() {
    List<LatLng> points = widget.place.routes
        .map((geoPoint) => LatLng(geoPoint.latitude, geoPoint.longitude))
        .toList();

    Polyline polyline = Polyline(
      polylineId: const PolylineId('Route principale'),
      visible: true,
      points: points,
      color: Colors.orange,
    );

    setState(() {
      polylines.add(polyline);
    });
  }

  void startLocationUpdates() {
    positionStream = Geolocator.getPositionStream();
    positionStream?.listen((Position position) {
      updateUserMarker(position);
    });
  }

  void updateUserMarker(Position position) {
    LatLng userPosition = LatLng(position.latitude, position.longitude);

    setState(() {
      userMarker = Marker(
        markerId: const MarkerId('Position de l\'utilisateur'),
        position: userPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
    });

    mapController?.animateCamera(
      CameraUpdate.newLatLng(userPosition),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: onMapCreated,
        initialCameraPosition: const CameraPosition(target: LatLng(0, 0)),
        polylines: polylines,
      ),
    );
  }
}
