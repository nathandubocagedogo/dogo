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

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    setUpPolyline();
    initCurrentPosition();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setUpPolyline() {
    List<LatLng> polylineCoordinates = widget.place.routes
        .map((geopoint) => LatLng(geopoint.latitude, geopoint.longitude))
        .toList();

    Polyline polyline = Polyline(
      polylineId: const PolylineId("Route principale"),
      color: Colors.orange,
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

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.place.routes[0].latitude,
                widget.place.routes[0].longitude,
              ),
              zoom: 11,
            ),
            polylines: polylines,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
          ),
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  left: 16,
                  child: Material(
                    shape: const CircleBorder(),
                    color: Colors.orangeAccent,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () async {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
