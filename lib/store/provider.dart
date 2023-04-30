import 'package:flutter/foundation.dart';
import 'package:dogo_final_app/models/provider/data_model.dart';

class DataProvider extends ChangeNotifier {
  DataModel dataModel = DataModel(coordinatesData: [], newsData: []);

  Future<void> fetchCoordinatesData() async {
    // Charger les données GPS de l'API ici
    // List<dynamic> apiGpsData = await loadGpsApiData();

    // Mettez à jour le modèle et informez les widgets à l'écoute
    // _dataModel = DataModel(gpsData: apiGpsData, newsData: _dataModel.newsData);
    // notifyListeners();
  }

  Future<void> fetchNewsData() async {
    // Charger les données des actualités de l'API ici
    // List<dynamic> apiNewsData = await loadNewsApiData();

    // Mettez à jour le modèle et informez les widgets à l'écoute
    // _dataModel = DataModel(gpsData: _dataModel.gpsData, newsData: apiNewsData);
    // notifyListeners();
  }
}
