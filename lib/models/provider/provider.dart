import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class ProviderModel {
  Position? currentPosition;
  Placemark? currentAddress;
  String? filter;
  int? radius = 5;

  ProviderModel({
    required Position? currentPosition,
    required Placemark? currentAddress,
    required String? filter,
    required int? radius,
  });
}
