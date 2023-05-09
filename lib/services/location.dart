import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<Placemark> getAddressFromCoordinates(
      double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    return placemarks[0];
  }

  Future<String> loadMapStyle({required String file}) async {
    return await rootBundle.loadString(file);
  }
}
