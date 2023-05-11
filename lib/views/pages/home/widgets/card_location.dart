// Flutter
import 'package:flutter/material.dart';
import 'dart:async';

// Provider
import 'package:dogo_final_app/provider/provider.dart';

// Utilities
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';

class CardLocationWidget extends StatefulWidget {
  final Function(GoogleMapController) onMapCreated;
  final Completer<GoogleMapController> controllerCompleter;
  final Set<Marker> markers;

  const CardLocationWidget({
    super.key,
    required this.onMapCreated,
    required this.controllerCompleter,
    required this.markers,
  });

  @override
  State<CardLocationWidget> createState() => _CardLocationWidgetState();
}

class _CardLocationWidgetState extends State<CardLocationWidget> {
  bool mapIsLoaded = false;

  void onMapCreated(GoogleMapController controller) {
    widget.onMapCreated(controller);
    setState(() {
      mapIsLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.9,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Selector<DataProvider, Position?>(
              selector: (context, dataProvider) =>
                  dataProvider.dataModel.currentPosition,
              builder: (context, currentPosition, child) {
                return currentPosition != null
                    ? GoogleMap(
                        markers: widget.markers,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            currentPosition.latitude,
                            currentPosition.longitude,
                          ),
                          zoom: 15.0,
                        ),
                        onMapCreated: onMapCreated,
                        myLocationButtonEnabled: false,
                      )
                    : Container();
              },
            ),
            if (!mapIsLoaded)
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                ),
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
                padding: const EdgeInsets.symmetric(horizontal: 24),
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
                    Selector<DataProvider, Placemark?>(
                      selector: (context, dataProvider) =>
                          dataProvider.dataModel.currentAddress,
                      builder: (context, currentAddress, child) {
                        return currentAddress != null
                            ? Text(
                                '${currentAddress.street}, ${currentAddress.locality}',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              )
                            : Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: double.infinity,
                                  height: 20.0,
                                  color: Colors.white,
                                ),
                              );
                      },
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
