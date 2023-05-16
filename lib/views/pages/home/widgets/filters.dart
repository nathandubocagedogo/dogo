// Flutter
import 'package:flutter/material.dart';

// Provider
import 'package:dogo_final_app/provider/provider.dart';

// Utilities
import 'package:provider/provider.dart';

class FiltersWidget extends StatelessWidget {
  final String? type;

  static List<String> filters = [
    'Parcs',
    'Balades',
  ];

  const FiltersWidget({super.key, this.type});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(
        left: screenWidth * 0.05,
        right: screenWidth * 0.05,
      ),
      child: Column(
        children: [
          Selector<DataProvider, String>(
            selector: (context, dataProvider) =>
                dataProvider.dataModel.filter.toString(),
            builder: (context, filter, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: filters.map((String filterValue) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: TextButton(
                      onPressed: () {
                        Provider.of<DataProvider>(context, listen: false)
                            .updateFilter(filterValue);
                      },
                      style: type == 'map'
                          ? TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              backgroundColor: filter == filterValue
                                  ? Colors.orange
                                  : Colors.orange[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            )
                          : TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              backgroundColor: filter == filterValue
                                  ? Colors.orange
                                  : Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                      child: Text(
                        filterValue,
                        style: type == 'map'
                            ? const TextStyle(color: Colors.white)
                            : TextStyle(
                                color: filter == filterValue
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
