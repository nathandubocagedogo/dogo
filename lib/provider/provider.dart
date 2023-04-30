import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dogo_final_app/models/provider/provider_model.dart';

class DataProvider extends ChangeNotifier {
  ProviderModel dataModel = ProviderModel(currentPosition: null);

  Future<void> updateCurrentPosition(Position position) async {
    dataModel.currentPosition = position;
    notifyListeners();
  }
}
