// Flutter
import 'package:flutter/material.dart';
import 'dart:async';

// Services
import 'package:dogo_final_app/services/places.dart';
import 'package:dogo_final_app/services/location.dart';

// Components
import 'package:dogo_final_app/views/pages/home/widgets/filters.dart';
import 'package:dogo_final_app/views/pages/home/widgets/nearby_places.dart';
import 'package:dogo_final_app/views/pages/home/widgets/heading.dart';
import 'package:dogo_final_app/views/pages/home/widgets/card_location.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';

// Provider
import 'package:dogo_final_app/provider/provider.dart';

// Utilities
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tuple/tuple.dart';

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

  late GoogleMapController controller;
  late bool dataLoaded = false;
  String? mapStyle;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await Future.wait([
      // initCurrentLocation(),
      // initFilter(),
    ]);

    mapStyle = await locationService.loadMapStyle(
      file: "assets/files/map-flat.json",
    );

    // setState(() {
    //   dataLoaded = true;
    // });
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

  void onMapCreated(GoogleMapController controller) {
    if (!controllerCompleter.isCompleted) {
      controllerCompleter.complete(controller);
    }

    controller.setMapStyle(mapStyle);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HeadingWidget(),
            const SizedBox(height: 30),
            CardLocationWidget(
              onMapCreated: onMapCreated,
              controllerCompleter: controllerCompleter,
              initCurrentLocation: initCurrentLocation,
            ),
          ],
        ),
      ),
    );
  }
}
