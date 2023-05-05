// Flutter
import 'package:dogo_final_app/services/places.dart';
import 'package:flutter/material.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';

// Provider
import 'package:dogo_final_app/provider/provider.dart';
import 'package:provider/provider.dart';

// Utilities
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final PlacesService placesService = PlacesService();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
    // return Selector<DataProvider, Position?>(
    //   selector: (context, dataProvider) =>
    //       dataProvider.dataModel.currentPosition,
    //   builder: (context, currentPosition, child) {
    //     return FutureBuilder<List<Map<String, dynamic>>>(
    //       future: currentPosition != null
    //           ? placesService.fetchAllNearbyPlaces(
    //               LatLng(currentPosition.latitude, currentPosition.longitude),
    //               100,
    //             )
    //           : Future.value([]),
    //       builder: (
    //         BuildContext context,
    //         AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
    //       ) {
    //         if (snapshot.connectionState == ConnectionState.waiting) {
    //           return const Center(child: CircularProgressIndicator());
    //         } else if (snapshot.hasError) {
    //           return Center(child: Text('Erreur : ${snapshot.error}'));
    //         } else {
    //           List<Map<String, dynamic>> nearbyPlaces = snapshot.data!;
    //           // ignore: avoid_print
    //           print(nearbyPlaces);
    //           return const Scaffold();
    //         }
    //       },
    //     );
    //   },
    // );
  }
}
