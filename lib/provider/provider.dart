import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dogo_final_app/models/provider/provider.dart';

class DataProvider extends ChangeNotifier {
  ProviderModel dataModel = ProviderModel(
    currentPosition: null,
    filter: null,
    radius: 0,
  );

  void updateCurrentPosition(Position position) async {
    dataModel.currentPosition = position;
    notifyListeners();
  }

  void updateFilter(String filter) {
    dataModel.filter = filter;
    notifyListeners();
  }

  void updateRadius(double radius) {
    dataModel.radius = radius;
    notifyListeners();
  }
}
