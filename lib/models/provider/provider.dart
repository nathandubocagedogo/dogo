import 'package:geolocator/geolocator.dart';

class ProviderModel {
  Position? currentPosition;
  Map<String, dynamic>? currentAddress;
  String? filter;
  double? radius = 100;

  ProviderModel({
    required Position? currentPosition,
    required Map<String, dynamic>? currentAddress,
    required String? filter,
    required double? radius,
  });
}
