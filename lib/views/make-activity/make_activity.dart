// Flutter
import 'package:flutter/material.dart';
import 'dart:async';

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
  late GoogleMapController mapController;
  late Position currentPosition;
  StreamSubscription<Position>? positionStreamSubscription;

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    setUpPolyline();
    initCurrentPosition().then((_) => startLocationTracking());
  }

  @override
  void dispose() {
    super.dispose();
    stopLocationTracking();
  }

  void setUpPolyline() {
    List<LatLng> polylineCoordinates = widget.place.routes
        .map((geopoint) => LatLng(geopoint.latitude, geopoint.longitude))
        .toList();

    Polyline polyline = Polyline(
      polylineId: const PolylineId("Route principale"),
      color: Colors.red,
      points: polylineCoordinates,
    );

    polylines.add(polyline);
  }

  Future<void> initCurrentPosition() async {
    currentPosition = await Geolocator.getCurrentPosition();

    setState(() {
      markers.add(
        Marker(
          markerId: const MarkerId("Ma position"),
          position: LatLng(currentPosition.latitude, currentPosition.longitude),
          infoWindow: const InfoWindow(title: "Ma position"),
        ),
      );
    });
  }

  void startLocationTracking() {
    positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      double distanceInMeters = Geolocator.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          position.latitude,
          position.longitude);

      if (distanceInMeters > 4) {
        setState(() {
          currentPosition = position;

          markers.removeWhere(
              (marker) => marker.markerId.value == "currentLocation");

          markers.add(
            Marker(
              markerId: const MarkerId("Ma position"),
              position: LatLng(position.latitude, position.longitude),
              infoWindow: const InfoWindow(title: "Ma position"),
            ),
          );
        });
      }
    });
  }

  void stopLocationTracking() {
    positionStreamSubscription?.cancel();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          widget.place.routes[0].latitude,
          widget.place.routes[0].longitude,
        ),
        zoom: 11,
      ),
      markers: markers,
      polylines: polylines,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
    );
  }
}
