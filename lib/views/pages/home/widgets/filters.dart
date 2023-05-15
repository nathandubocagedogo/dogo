// Flutter
import 'package:flutter/material.dart';

// Provider
import 'package:provider/provider.dart';
import 'package:dogo_final_app/provider/provider.dart';

class FiltersWidget extends StatelessWidget {
  static List<String> filters = [
    'Parcs',
    'Balades',
    'Shop',
    'Vétérinaires',
    'Toiletteurs',
  ];

  const FiltersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
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
                return Row(children: [
                  ...filters.map((String filterValue) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: TextButton(
                        onPressed: () {
                          Provider.of<DataProvider>(context, listen: false)
                              .updateFilter(filterValue);
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          backgroundColor: filter == filterValue
                              ? Colors.orange
                              : Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          filterValue,
                          style: TextStyle(
                            color: filter == filterValue
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
