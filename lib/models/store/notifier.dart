import 'package:flutter/foundation.dart';
import 'package:dogo_final_app/models/store/data.dart';

class DataProvider extends ChangeNotifier {
  DataModel _dataModel = DataModel(data: []);

  DataModel get dataModel => _dataModel;

  // Remplacez la signature de cette fonction par celle de votre appel API
  Future<void> fetchData(int pageIndex) async {
    // Chargez les données de l'API ici
    // List<dynamic> apiData = await loadApiDataForPage(pageIndex);

    // Mettez à jour le modèle et informez les widgets à l'écoute
    // _dataModel = DataModel(data: apiData);
    // notifyListeners();
  }
}
