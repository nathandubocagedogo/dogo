// Flutter
import 'package:flutter/material.dart';

// Services
import 'package:dogo_final_app/services/places.dart';

// Components
import 'package:dogo_final_app/components/buttons/button_back.dart';

// Utilities
import 'package:provider/provider.dart';

class ChangeLocationView extends StatefulWidget {
  const ChangeLocationView({super.key});

  @override
  State<ChangeLocationView> createState() => _ChangeLocationViewState();
}

class _ChangeLocationViewState extends State<ChangeLocationView> {
  final PlacesService placesService = PlacesService();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const ButtonBack(),
          title: const Text("Changer de localisation"),
        ),
        body: SafeArea(
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              }

              // À chaque fois que l'utilisateur tape une lettre, on va chercher les suggestions de lieux dans l'API Google Places
              return context
                  .read<PlacesService>()
                  .getPlacesSuggestions(query: textEditingValue.text);
            },
            onSelected: (String selected) async {
              FocusScope.of(context).unfocus();
              final String? placeId =
                  context.read<PlacesService>().placeIdMap[selected];
              // On vient récupérer les coordonnées du lieu sélectionné par l'utilisateur pour les stocker dans le Provider
              placesService.getCoordinatesFromPlace(placeId!, context);
            },
            fieldViewBuilder: (
              BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted,
            ) {
              textEditingController = textEditingController;
              return Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05,
                  top: 10,
                  bottom: 20,
                ),
                child: TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: "Entrez une ville ou un lieu",
                    suffixIcon: Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        iconTheme: const IconThemeData(
                          color: Colors.black54,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          placesService.setCurrentLocation(context);
                        },
                        child: const Icon(
                          (Icons.my_location),
                        ),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 16.0,
                    ),
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                  onSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                ),
              );
            },
            optionsViewBuilder: (
              BuildContext context,
              AutocompleteOnSelected<String> onSelected,
              Iterable<String> options,
            ) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4.0,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: options.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                    itemBuilder: (BuildContext context, int index) {
                      String option = options.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          onSelected(option);
                        },
                        child: ListTile(
                          title: Text(
                            option,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
