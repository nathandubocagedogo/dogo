import 'package:cloud_firestore/cloud_firestore.dart';

class Place {
  final dynamic id;
  final String name;
  final String city;
  final String address;
  final double latitude;
  final double longitude;
  final List<dynamic> pictures;
  final String type;
  final String description;

  Place(
      {required this.id,
      required this.name,
      required this.city,
      required this.address,
      required this.latitude,
      required this.longitude,
      required this.description,
      required this.type,
      required this.pictures});

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      id: map['id'] ?? "",
      name: map['name'] ?? "",
      city: map['city'] ?? "",
      address: map['address'] ?? "",
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      description: map['description'] ?? "",
      type: map['type'] ?? "",
      pictures: map['pictures'] ?? [],
    );
  }

  factory Place.fromDocument(DocumentSnapshot doc) {
    return Place(
      id: doc.id,
      name: doc.get('name') ?? "",
      city: doc.get('city') ?? "",
      address: doc.get('address') ?? "",
      latitude: doc.get('latitude') ?? 0.0,
      longitude: doc.get('longitude') ?? 0.0,
      description: doc.get('description') ?? "",
      type: doc.get('type') ?? "",
      pictures: doc.get('pictures') ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'address': address,
      'latitude': latitude,
      'description': description,
      'longitude': longitude,
      'type': type,
      'pictures': pictures,
    };
  }
}
