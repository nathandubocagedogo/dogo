// Flutter
import 'package:flutter/material.dart';

// Utilities
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateLocationMapView extends StatefulWidget {
  const CreateLocationMapView({super.key});

  @override
  State<CreateLocationMapView> createState() => _CreateLocationMapViewState();
}

class _CreateLocationMapViewState extends State<CreateLocationMapView> {
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
          draggable: true,
          onDragEnd: (newPosition) => updateMarker(newPosition),
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
