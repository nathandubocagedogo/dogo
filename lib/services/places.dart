// Flutter
import 'dart:convert';
import 'dart:math';

// Utilities
import 'package:dogo_final_app/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class PlacesService {
  final String apiKey = dotenv.get('GOOGLE_API_KEY');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, String> placeIdMap = {};

  Future<List<Map<String, dynamic>>> fetchNearbyPlaces(
    LatLng center,
    double radius,
  ) async {
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
    List<List<Map<String, dynamic>>> results = await Future.wait([
      fetchNearbyPlaces(center, radius),
      // fetchNearbyDatabasePlaces(center, radius),
    ]);

    List<Map<String, dynamic>> allPlaces = [];
    allPlaces.addAll(results[0]);
    // allPlaces.addAll(results[1]);

    return allPlaces;
  }

  Future<List<String>> getPlacesSuggestions({required String query}) async {
    if (query.isEmpty) {
      return [];
    }

    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apiKey&sessiontoken=1234567890&types=(cities)";

    final response = await http.get(Uri.parse(url));
    final jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      List<String> suggestions = [];
      placeIdMap.clear();
      for (var prediction in jsonResponse['predictions']) {
        final description = prediction['description'].toString();
        final placeId = prediction['place_id'].toString();
        placeIdMap[description] = placeId;
        suggestions.add(description);
      }
      return suggestions;
    } else {
      return [];
    }
  }

  Position latitudeLongitudeToPosition(LatLng latLng) {
    return Position(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }

  Future<void> getCoordinatesFromPlace(
      String? placeId, BuildContext context) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&fields=geometry";

    final response = await http.get(Uri.parse(url));
    final jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      final double latitude =
          jsonResponse['result']['geometry']['location']['lat'];
      final double longitude =
          jsonResponse['result']['geometry']['location']['lng'];
      final Position position =
          latitudeLongitudeToPosition(LatLng(latitude, longitude));

      // ignore: use_build_context_synchronously
      Provider.of<DataProvider>(context, listen: false)
          .updateCurrentPosition(position);

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }
}
