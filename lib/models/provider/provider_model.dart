import 'package:geolocator/geolocator.dart';

class ProviderModel {
  Position? currentPosition;
  String? filter;
  double? radius = 100;

  ProviderModel({
    required Position? currentPosition,
    required String? filter,
    required double? radius,
  });
}
