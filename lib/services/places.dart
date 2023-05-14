// Flutter
import 'dart:convert';
import 'dart:math';

// Provider
import 'package:dogo_final_app/provider/provider.dart';

// Utilities
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Firebase
import 'package:cloud_firestore/cloud_firestore.dart';

// Models
import 'package:dogo_final_app/models/firebase/place.dart';

class PlacesService {
  final String apiKey = dotenv.get('GOOGLE_API_KEY');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, String> placeIdMap = {};

  Future<List<Map<String, dynamic>>> fetchNearbyDatabasePlaces(
    LatLng position,
    double radius,
    String? filter,
  ) async {
    final double latitudeDelta = radius / 111.32;
    final double longitudeDelta =
        radius / (111.32 * cos(position.latitude * pi / 180));

    QuerySnapshot<Map<String, dynamic>> latitudeFilteredSnapshot =
        await firestore
            .collection('places')
            .where('latitude',
                isGreaterThanOrEqualTo: position.latitude - latitudeDelta,
                isLessThanOrEqualTo: position.latitude + latitudeDelta)
            .get();

    QuerySnapshot<Map<String, dynamic>> longitudeFilteredSnapshot =
        await firestore
            .collection('places')
            .where('longitude',
                isGreaterThanOrEqualTo: position.longitude - longitudeDelta,
                isLessThanOrEqualTo: position.longitude + longitudeDelta)
            .get();

    Set<String> latitudeFilteredIds =
        latitudeFilteredSnapshot.docs.map((doc) => doc.id).toSet();
    Set<String> longitudeFilteredIds =
        longitudeFilteredSnapshot.docs.map((doc) => doc.id).toSet();
    Set<String> typeFilteredIds = {};

    if (filter != null && filter.isNotEmpty) {
      QuerySnapshot<Map<String, dynamic>> typeFilteredSnapshot = await firestore
          .collection('places')
          .where('type', isEqualTo: filter)
          .get();

      typeFilteredIds = typeFilteredSnapshot.docs.map((doc) => doc.id).toSet();
    }

    Set<String> filteredIds =
        latitudeFilteredIds.intersection(longitudeFilteredIds);

    if (typeFilteredIds.isNotEmpty) {
      filteredIds = filteredIds.intersection(typeFilteredIds);
    }

    List<Map<String, dynamic>> places = [];

    for (var doc in latitudeFilteredSnapshot.docs) {
      if (filteredIds.contains(doc.id)) {
        if (doc['id'] != null &&
            doc['name'] != null &&
            doc['description'] != null &&
            doc['pictures'] != null &&
            doc['city'] != null &&
            doc['address'] != null &&
            doc['type'] != null &&
            doc['latitude'] != null &&
            doc['longitude'] != null) {
          places.add({
            'id': doc['id'],
            'name': doc['name'],
            'latitude': doc['latitude'],
            'description': doc['description'],
            'longitude': doc['longitude'],
            'city': doc['city'],
            'address': doc['address'],
            'type': doc['type'],
            'pictures': doc['pictures'],
          });
        }
      }
    }

    return places;
  }

  Future<List<Place>> fetchNearbyPlaces(
    LatLng position,
    double radius,
    String filter,
  ) async {
    List<Map<String, dynamic>> results =
        await fetchNearbyDatabasePlaces(position, radius, filter);

    return results.map((map) => Place.fromMap(map)).toList();
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
    String placeId,
    BuildContext context,
  ) async {
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

  Future<void> setCurrentLocation(BuildContext context) async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception("La localisation n'est pas activée.");
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // ignore: use_build_context_synchronously
      Provider.of<DataProvider>(context, listen: false)
          .updateCurrentPosition(position);

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (exception) {
      rethrow;
    }
  }
}
