// FLutter
import 'package:flutter/material.dart';
import 'dart:async';

// Provider
import 'package:dogo_final_app/provider/provider.dart';

// Utilities
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tuple/tuple.dart';

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

    return Selector<DataProvider, Tuple2<Position?, Placemark?>>(
      selector: (context, dataProvider) => Tuple2(
        dataProvider.dataModel.currentPosition,
        dataProvider.dataModel.currentAddress,
      ),
      builder: (context, tuple, child) {
        final currentPosition = tuple.item1;
        final currentAddress = tuple.item2;

        if (currentPosition == null || currentAddress == null) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: screenWidth * 0.9,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }

        final markers = {
          Marker(
            markerId: const MarkerId("Position actuelle"),
            position: LatLng(
              currentPosition.latitude,
              currentPosition.longitude,
            ),
          ),
        };

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
                  markers: markers,
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
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/change-location');
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(
                          Icons.edit,
                          color: Colors.orange,
                        ),
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
                          currentAddress.name ?? "Adresse inconnue",
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
