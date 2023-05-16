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

// Utils
import 'package:dogo_final_app/utils/manipulate_string.dart';

class CardLocationWidget extends StatefulWidget {
  final Function() onRadiusButtonTap;
  final Function(GoogleMapController) onMapCreated;
  final Completer<GoogleMapController> controllerCompleter;
  final Set<Marker> markers;

  const CardLocationWidget({
    super.key,
    required this.onRadiusButtonTap,
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
      height: 270,
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
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey[300],
              ),
            if (mapIsLoaded) ...[
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
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.edit,
                        color: Colors.orange,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 65,
                right: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: InkWell(
                    onTap: widget.onRadiusButtonTap,
                    borderRadius: BorderRadius.circular(50),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.adjust,
                        color: Colors.orange,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Selector<DataProvider, dynamic>(
                      selector: (context, dataProvider) =>
                          dataProvider.dataModel.currentWeather,
                      builder: (context, currentWeather, child) {
                        return currentWeather != null
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/weather/${currentWeather['weather'][0]['icon'].toString()}.png",
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 4),
                                  RichText(
                                    text: TextSpan(
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: capitalize(
                                            text: currentWeather['weather'][0]
                                                    ['description']
                                                .toString(),
                                          ),
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const WidgetSpan(
                                          child: SizedBox(
                                            width: 4,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              "${currentWeather['main']['temp'].toString()}°C",
                                          style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 12,
                                            color: Colors.black38,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container();
                      },
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
                              : Container(
                                  width: double.infinity,
                                  height: 20.0,
                                  color: Colors.white,
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
