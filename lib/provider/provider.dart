// Flutter
import 'package:flutter/foundation.dart';

// Services
import 'package:dogo_final_app/services/location.dart';

// Models
import 'package:dogo_final_app/models/provider/provider.dart';
import 'package:flutter/material.dart';

// Utilities
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class DataProvider extends ChangeNotifier {
  LocationService locationService = LocationService();
  VoidCallback? onPositionChange;

  ProviderModel dataModel = ProviderModel(
    currentPosition: null,
    currentAddress: null,
    filter: null,
    radius: 0,
  );

  void updateCurrentPosition(Position position) async {
    dataModel.currentPosition = position;

    Placemark address = await locationService.getAddressFromCoordinates(
      position.latitude,
      position.longitude,
    );
    updateCurrentAddress(address);

    if (onPositionChange != null) {
      onPositionChange!();
    }
  }

  void updateCurrentAddress(Placemark address) async {
    dataModel.currentAddress = address;
    notifyListeners();
  }

  void updateFilter(String filter) {
    dataModel.filter = filter;
    notifyListeners();
  }

  void updateRadius(int radius) {
    dataModel.radius = radius;
    notifyListeners();
  }
}
