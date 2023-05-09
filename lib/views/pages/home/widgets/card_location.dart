// Flutter
import 'package:flutter/material.dart';
import 'dart:async';

// Provider
import 'package:provider/provider.dart';
import 'package:dogo_final_app/provider/provider.dart';

// Utilities
import 'package:shimmer/shimmer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CardLocationWidget extends StatelessWidget {
  final Function(GoogleMapController) onMapCreated;
  final Completer<GoogleMapController> controllerCompleter;

  const CardLocationWidget({
    super.key,
    required this.onMapCreated,
    required this.controllerCompleter,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        final currentPosition = dataProvider.dataModel.currentPosition;
        final currentAddress = dataProvider.dataModel.currentAddress;

        if (currentPosition == null) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: screenWidth * 0.9,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: const SizedBox(),
            ),
          );
        }

        final marker = Marker(
          markerId: const MarkerId("Position actuelle"),
          position: LatLng(
            currentPosition.latitude,
            currentPosition.longitude,
          ),
        );

        return Container(
          width: screenWidth * 0.9,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                GoogleMap(
                  markers: {marker},
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      currentPosition.latitude,
                      currentPosition.longitude,
                    ),
                    zoom: 15.0,
                  ),
                  onMapCreated: onMapCreated,
                  myLocationButtonEnabled: false,
                ),
                Container(
                  width: double.infinity,
                  height: 80,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Position actuelle",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentAddress?.name ?? "Adresse inconnue",
                          style: const TextStyle(
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
      },
    );
  }
}
