// Flutter
import 'package:flutter/material.dart';
import 'dart:async';

// Services
import 'package:dogo_final_app/services/places.dart';
import 'package:dogo_final_app/services/location.dart';

// Components
import 'package:dogo_final_app/views/pages/home/widgets/filters.dart';
import 'package:dogo_final_app/views/pages/home/widgets/heading_user.dart';
import 'package:dogo_final_app/views/pages/home/widgets/card_location.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';

// Provider
import 'package:dogo_final_app/provider/provider.dart';

// Utilities
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView>
    with AutomaticKeepAliveClientMixin {
  final PlacesService placesService = PlacesService();
  final LocationService locationService = LocationService();
  final User? user = FirebaseAuth.instance.currentUser;
  final Completer<GoogleMapController> controllerCompleter =
      Completer<GoogleMapController>();

  Set<Marker> markers = {};

  late GoogleMapController controller;
  late bool dataLoaded = false;
  late String? mapStyle;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await Future.wait([
      initCurrentLocation(),
      initFilter(),
    ]);

    // ignore: use_build_context_synchronously
    Provider.of<DataProvider>(context, listen: false).onPositionChange =
        onPositionChanged;

    setState(() {
      dataLoaded = true;
    });
  }

  Future<Position> initCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception("La localisation n'est pas activée.");
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        Provider.of<DataProvider>(context, listen: false)
            .updateCurrentPosition(position);
      }

      return position;
    } catch (exception) {
      rethrow;
    }
  }

  Future<void> initFilter() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DataProvider>(context, listen: false).updateFilter("");
    });
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    mapStyle = await locationService.loadMapStyle(
      file: "assets/files/map-flat.json",
    );

    if (!controllerCompleter.isCompleted) {
      controllerCompleter.complete(controller);
    }

    controller.setMapStyle(mapStyle);
  }

  void onPositionChanged() {
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);
    Position currentPosition = dataProvider.dataModel.currentPosition!;
    updateCameraPosition(currentPosition);

    Marker marker = Marker(
      markerId: const MarkerId('Position actuelle'),
      position: LatLng(currentPosition.latitude, currentPosition.longitude),
    );

    setState(() {
      markers = {marker};
    });
  }

  Future<void> updateCameraPosition(Position position) async {
    if (controllerCompleter.isCompleted) {
      GoogleMapController mapController = await controllerCompleter.future;
      CameraUpdate cameraUpdate = CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude),
      );
      mapController.animateCamera(cameraUpdate);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HeadingUserWidget(),
              const SizedBox(height: 30),
              CardLocationWidget(
                onMapCreated: onMapCreated,
                controllerCompleter: controllerCompleter,
                markers: markers,
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: screenWidth * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Catégories",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/map");
                            },
                            child: const Text(
                              "Voir la carte",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.orange,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: EdgeInsets.only(
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                  ),
                  child: const FiltersWidget(),
                ),
              ),

              // SizedBox(
              //   child:
              //       Selector<DataProvider, Tuple3<String?, Position?, double?>>(
              //     selector: (context, dataProvider) => Tuple3(
              //       dataProvider.dataModel.filter,
              //       dataProvider.dataModel.currentPosition,
              //       dataProvider.dataModel.radius,
              //     ),
              //     builder: (context, tuple, child) {
              //       String? filter = tuple.item1;
              //       Position? currentPosition = tuple.item2;
              //       double? radius = tuple.item3;

              //       if (!dataLoaded) {
              //         return const Center(child: CircularProgressIndicator());
              //       } else {
              //         return NearbyPlacesWidget(
              //           position: LatLng(
              //             currentPosition!.latitude,
              //             currentPosition.longitude,
              //           ),
              //           filter: filter,
              //           radius: radius,
              //         );
              //       }
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
