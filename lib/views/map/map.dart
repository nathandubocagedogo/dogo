import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  late GoogleMapController controller;

  final CameraPosition initialPosition = const CameraPosition(
    target: LatLng(48.8566, 2.3522),
    zoom: 11.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: initialPosition,
        onMapCreated: (GoogleMapController controller) {
          controller = controller;
        },
        mapType: MapType.normal,
      ),
    );
  }
}
