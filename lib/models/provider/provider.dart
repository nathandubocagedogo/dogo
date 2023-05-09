import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class ProviderModel {
  Position? currentPosition;
  Placemark? currentAddress;
  dynamic currentUser;
  String? filter;
  double? radius = 100;

  ProviderModel({
    required Position? currentPosition,
    required Placemark? currentAddress,
    required dynamic currentUser,
    required String? filter,
    required double? radius,
  });
}
