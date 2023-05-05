import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dogo_final_app/provider/provider.dart';

class Filters extends StatelessWidget {
  static List<String> filters = [
    'Parcs',
    'Balades',
    'Concours',
    'Rencontre',
    'Shop',
    'Vétérinaire',
    'Toiletteur',
    'Autre'
  ];

  const Filters({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<DataProvider, String>(
      selector: (context, dataProvider) =>
          dataProvider.dataModel.filter.toString(),
      builder: (context, filter, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters.map((String filterValue) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: TextButton(
                  onPressed: () {
                    Provider.of<DataProvider>(context, listen: false)
                        .updateFilter(filterValue);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:
                        filter == filterValue ? Colors.blue : Colors.indigo,
                  ),
                  child: Text(
                    filterValue,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
