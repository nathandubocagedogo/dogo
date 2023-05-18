// Utilities
import 'package:cloud_firestore/cloud_firestore.dart';

class Place {
  final String id;
  final String name;
  final String city;
  final String address;
  final double latitude;
  final double longitude;
  final List<dynamic> pictures;
  final String type;
  final String duration;
  final String description;
  final String warning;
  final String difficulty;
  final List<GeoPoint> routes;

  Place(
      {required this.id,
      required this.name,
      required this.city,
      required this.address,
      required this.duration,
      required this.latitude,
      required this.difficulty,
      required this.longitude,
      required this.description,
      required this.type,
      required this.pictures,
      required this.routes,
      required this.warning});

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      id: map['id'] ?? "",
      name: map['name'] ?? "",
      city: map['city'] ?? "",
      address: map['address'] ?? "",
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      difficulty: map['difficulty'] ?? "",
      description: map['description'] ?? "",
      duration: map['duration'] ?? "",
      type: map['type'] ?? "",
      pictures: map['pictures'] ?? [],
      warning: map['warning'] ?? "",
      routes: (map['routes'] as List<dynamic>)
          .map((route) => GeoPoint(
                route.latitude as double? ?? 0.0,
                route.longitude as double? ?? 0.0,
              ))
          .toList(),
    );
  }

  factory Place.fromDocument(DocumentSnapshot doc) {
    return Place(
      id: doc.id,
      name: doc.get('name') ?? "",
      difficulty: doc.get('difficulty') ?? "",
      duration: doc.get('duration') ?? "",
      city: doc.get('city') ?? "",
      address: doc.get('address') ?? "",
      latitude: doc.get('latitude') ?? 0.0,
      longitude: doc.get('longitude') ?? 0.0,
      description: doc.get('description') ?? "",
      type: doc.get('type') ?? "",
      pictures: doc.get('pictures') ?? [],
      warning: doc.get('warning') ?? "",
      routes: (doc.get('routes') as List<dynamic>)
          .map((route) => GeoPoint(
                route.latitude as double? ?? 0.0,
                route.longitude as double? ?? 0.0,
              ))
          .toList(),
    );
  }
}
