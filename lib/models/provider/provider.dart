import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class ProviderModel {
  Position? currentPosition;
  Placemark? currentAddress;
  dynamic currentWeather;
  String? filter;
  int? radius = 5;

  ProviderModel({
    required Position? currentPosition,
    required Placemark? currentAddress,
    required dynamic currentWeather,
    required String? filter,
    required int? radius,
  });
}
