import 'package:flutter/foundation.dart';
import 'package:dogo_final_app/models/store/data.dart';

class DataProvider extends ChangeNotifier {
  DataModel dataModel = DataModel(data: []);

  Future<void> fetchData(int pageIndex) async {
    List<String> apiData = await fetchDataFromApi(pageIndex);

    dataModel = DataModel(data: apiData);
    notifyListeners();
  }

  Future<List<String>> fetchDataFromApi(int pageIndex) async {
    await Future.delayed(const Duration(seconds: 2));

    switch (pageIndex) {
      case 0:
        return ['Data A1', 'Data A2', 'Data A3'];
      case 1:
        return ['Data B1', 'Data B2', 'Data B3'];
      case 2:
        return ['Data C1', 'Data C2', 'Data C3'];
      case 3:
        return ['Data D1', 'Data D2', 'Data D3'];
      default:
        return ['Data E1', 'Data E2', 'Data E3'];
    }
  }
}
