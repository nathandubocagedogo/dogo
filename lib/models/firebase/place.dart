class Place {
  final String name;
  final String city;
  final String address;
  final double latitude;
  final double longitude;
  final List<dynamic> pictures;
  final String type;

  Place(
      {required this.name,
      required this.city,
      required this.address,
      required this.latitude,
      required this.longitude,
      required this.type,
      required this.pictures});

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      name: map['name'] ?? "",
      city: map['city'] ?? "",
      address: map['address'] ?? "",
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      type: map['type'] ?? "",
      pictures: map['pictures'] ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'city': city,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'type': type,
      'pictures': pictures,
    };
  }
}
