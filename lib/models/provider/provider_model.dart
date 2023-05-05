import 'package:geolocator/geolocator.dart';

class ProviderModel {
  Position? currentPosition;
  String? filter;

  ProviderModel({required Position? currentPosition, required String? filter});
}
