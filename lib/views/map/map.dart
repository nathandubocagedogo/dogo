import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  MapType currentMapType = MapType.normal;
  late GoogleMapController controller;

  final CameraPosition initialPosition = const CameraPosition(
    target: LatLng(48.8566, 2.3522),
    zoom: 11.0,
  );

  void onMapTypeButtonPressed() {
    setState(() {
      currentMapType =
          currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialPosition,
            onMapCreated: (GoogleMapController controller) {
              controller = controller;
            },
            mapType: currentMapType,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: [
                  FloatingActionButton(
                    onPressed: onMapTypeButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    child: const Icon(Icons.map, size: 36.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
