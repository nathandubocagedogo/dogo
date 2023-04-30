// Flutter
import 'package:flutter/material.dart';

// Utilities
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Provider
import 'package:provider/provider.dart';
import 'package:dogo_final_app/provider/provider.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  late GoogleMapController controller;
  Map<String, Marker> markers = <String, Marker>{};

  Future<void> updateCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception("Location permission denied");
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // ignore: use_build_context_synchronously
      Provider.of<DataProvider>(context, listen: false)
          .updateCurrentPosition(position);

      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14.0,
          ),
        ),
      );
    } catch (exception) {}
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final currentPosition = dataProvider.dataModel.currentPosition;

    final CameraPosition initialPosition = currentPosition != null
        ? CameraPosition(
            target: LatLng(currentPosition.latitude, currentPosition.longitude),
            zoom: 11.0,
          )
        : const CameraPosition(
            target: LatLng(48.8566, 2.3522),
            zoom: 11.0,
          );

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialPosition,
            onMapCreated: (GoogleMapController googleMapController) {
              controller = googleMapController;
            },
            markers: Set<Marker>.of(markers.values),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () async {
                await updateCurrentLocation();
              },
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
