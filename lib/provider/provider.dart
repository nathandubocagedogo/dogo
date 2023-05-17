// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// Services
import 'package:dogo_final_app/services/weather.dart';
import 'package:dogo_final_app/services/location.dart';

// Models
import 'package:dogo_final_app/models/provider/provider.dart';

// Utilities
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class DataProvider extends ChangeNotifier {
  LocationService locationService = LocationService();
  WeatherService weatherService = WeatherService();
  VoidCallback? onPositionChange;

  ProviderModel dataModel = ProviderModel(
    currentPosition: null,
    currentAddress: null,
    currentWeather: null,
    filter: null,
    radius: 0,
  );

  void updateCurrentPosition(Position position) async {
    dataModel.currentPosition = position;

    Future<Placemark> addressFuture = locationService.getAddressFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Future<dynamic> weatherFuture = weatherService.getCurrentWeather(
      position.latitude,
      position.longitude,
    );

    List responses = await Future.wait([addressFuture, weatherFuture]);

    Placemark address = responses[0];
    dynamic weather = responses[1];

    updateCurrentWeather(weather);
    updateCurrentAddress(address);

    if (onPositionChange != null) {
      onPositionChange!();
    }
  }

  void updateCurrentAddress(Placemark address) async {
    dataModel.currentAddress = address;
    notifyListeners();
  }

  void updateCurrentWeather(dynamic weather) {
    dataModel.currentWeather = weather;
    notifyListeners();
  }

  void updateFilter(String filter) {
    if (dataModel.filter == filter) {
      dataModel.filter = "";
    } else {
      dataModel.filter = filter;
    }

    notifyListeners();
  }

  void updateRadius(int radius) {
    dataModel.radius = radius;
    notifyListeners();
  }
}
