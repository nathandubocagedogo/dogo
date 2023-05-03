// Flutter
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';

// Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Provider
import 'package:dogo_final_app/provider/provider.dart';
import 'package:provider/provider.dart';

// Utilities
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchNearbyPlaces(
    LatLng center,
    double radius,
  ) async {
    final String apiKey = dotenv.get('GOOGLE_API_KEY');
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${center.latitude},${center.longitude}&radius=$radius&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['results']);
    } else {
      throw Exception('Erreur lors de l\'appel à l\'API Google Places');
    }
  }

  Future<List<Map<String, dynamic>>> fetchNearbyDatabasePlaces(
    LatLng center,
    double radius,
  ) async {
    final double latitudeDelta = radius / 111.32;
    final double longitudeDelta =
        radius / (111.32 * cos(center.latitude * pi / 180));

    QuerySnapshot<Map<String, dynamic>> latitudeFilteredSnapshot =
        await firestore
            .collection('places')
            .where('latitude',
                isGreaterThanOrEqualTo: center.latitude - latitudeDelta,
                isLessThanOrEqualTo: center.latitude + latitudeDelta)
            .get();

    QuerySnapshot<Map<String, dynamic>> longitudeFilteredSnapshot =
        await firestore
            .collection('places')
            .where('longitude',
                isGreaterThanOrEqualTo: center.longitude - longitudeDelta,
                isLessThanOrEqualTo: center.longitude + longitudeDelta)
            .get();

    Set<String> latitudeFilteredIds =
        latitudeFilteredSnapshot.docs.map((doc) => doc.id).toSet();
    Set<String> longitudeFilteredIds =
        longitudeFilteredSnapshot.docs.map((doc) => doc.id).toSet();

    Set<String> filteredIds =
        latitudeFilteredIds.intersection(longitudeFilteredIds);

    List<Map<String, dynamic>> places = [];

    for (var doc in latitudeFilteredSnapshot.docs) {
      if (filteredIds.contains(doc.id)) {
        if (doc['name'] != null &&
            doc['vicinity'] != null &&
            doc['latitude'] != null &&
            doc['longitude'] != null) {
          places.add({
            'name': doc['name'],
            'vicinity': doc['vicinity'],
            'latitude': doc['latitude'],
            'longitude': doc['longitude'],
          });
        }
      }
    }

    return places;
  }

  Future<List<Map<String, dynamic>>> fetchAllNearbyPlaces(
    LatLng center,
    double radius,
  ) async {
    List<Map<String, dynamic>> placesFromGoogle =
        await fetchNearbyPlaces(center, radius);
    List<Map<String, dynamic>> placesFromDatabase =
        await fetchNearbyDatabasePlaces(center, radius);
    List<Map<String, dynamic>> allPlaces = [];
    allPlaces.addAll(placesFromGoogle);
    allPlaces.addAll(placesFromDatabase);

    return allPlaces;
  }

  @override
  Widget build(BuildContext context) {
    return Selector<DataProvider, Position?>(
      selector: (context, dataProvider) =>
          dataProvider.dataModel.currentPosition,
      builder: (context, currentPosition, child) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: currentPosition != null
              ? fetchAllNearbyPlaces(
                  LatLng(currentPosition.latitude, currentPosition.longitude),
                  100,
                )
              : Future.value([]),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur : ${snapshot.error}'));
            } else {
              List<Map<String, dynamic>> nearbyPlaces = snapshot.data!;
              // ignore: avoid_print
              print(nearbyPlaces);
              return const Scaffold();
            }
          },
        );
      },
    );
  }
}
