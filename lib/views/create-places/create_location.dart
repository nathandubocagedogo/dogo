// Flutter
import 'package:flutter/material.dart';

// Utilities
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateLocationView extends StatefulWidget {
  const CreateLocationView({super.key});

  @override
  State<CreateLocationView> createState() => _CreateLocationViewState();
}

class _CreateLocationViewState extends State<CreateLocationView> {
  GoogleMapController? mapController;
  LatLng? lastMapPosition;

  Set<Marker> markers = {};

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void updateMarker(LatLng position) {
    setState(() {
      markers.clear();
      markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
        ),
      );
      lastMapPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: const CameraPosition(
        target: LatLng(0, 0),
      ),
      markers: markers,
      onTap: updateMarker,
    );
  }
}
