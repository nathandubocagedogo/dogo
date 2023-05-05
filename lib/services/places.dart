// Flutter
import 'dart:convert';
import 'dart:math';

// Utilities
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacesService {
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
}