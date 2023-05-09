// Flutter
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// Utilities
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CardLocationWidget extends StatelessWidget {
  final Function(GoogleMapController) onMapCreated;
  final Function initCurrentLocation;
  final Completer<GoogleMapController> controllerCompleter;

  const CardLocationWidget({
    super.key,
    required this.onMapCreated,
    required this.initCurrentLocation,
    required this.controllerCompleter,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.9,
      height: 250,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(48.8566, 2.3522),
                zoom: 15.0,
              ),
              onMapCreated: onMapCreated,
              myLocationButtonEnabled: false,
            ),
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: () async {
                  Position position = await initCurrentLocation();
                  GoogleMapController controller =
                      await controllerCompleter.future;
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(
                          position.latitude,
                          position.longitude,
                        ),
                        zoom: 18.0,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 80,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Position actuelle",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "24 Rue de Canteleu, 59480 La Bassée",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
