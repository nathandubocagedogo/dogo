// Flutter
import 'package:dogo_final_app/models/firebase/place.dart';
import 'package:dogo_final_app/views/pages/home/widgets/results_heading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// Services
import 'package:dogo_final_app/services/places.dart';
import 'package:dogo_final_app/services/location.dart';

// Components
import 'package:dogo_final_app/views/pages/home/widgets/nearby_places_shimmer.dart';
import 'package:dogo_final_app/views/pages/home/widgets/filters.dart';
import 'package:dogo_final_app/views/pages/home/widgets/heading_user.dart';
import 'package:dogo_final_app/views/pages/home/widgets/card_location.dart';
import 'package:dogo_final_app/views/pages/home/widgets/nearby_places.dart';
import 'package:dogo_final_app/views/pages/home/widgets/category_heading.dart';
import 'package:dogo_final_app/components/buttons/button_rounded_text.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';

// Provider
import 'package:dogo_final_app/provider/provider.dart';

// Utilities
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class HomePageView extends StatefulWidget {
  final Function(int) onPageChange;

  const HomePageView({
    super.key,
    required this.onPageChange,
  });

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView>
    with AutomaticKeepAliveClientMixin {
  final PlacesService placesService = PlacesService();
  final LocationService locationService = LocationService();
  final User? user = FirebaseAuth.instance.currentUser;
  final Completer<GoogleMapController> controllerCompleter =
      Completer<GoogleMapController>();

  Set<Marker> markers = {};
  static List<int> radiusOptions = [5, 10, 25, 50, 100];

  late GoogleMapController controller;
  late bool dataLoaded = false;
  late String? mapStyle;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await Future.wait([
      initCurrentLocation(),
      initFilter(),
    ]);

    // ignore: use_build_context_synchronously
    Provider.of<DataProvider>(context, listen: false).onPositionChange =
        onPositionChanged;

    setState(() {
      dataLoaded = true;
    });
  }

  Future<Position> initCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception("La localisation n'est pas activée.");
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        Provider.of<DataProvider>(context, listen: false)
            .updateCurrentPosition(position);
      }

      return position;
    } catch (exception) {
      rethrow;
    }
  }

  Future<void> initFilter() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DataProvider>(context, listen: false).updateFilter("");
    });
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    mapStyle = await locationService.loadMapStyle(
      file: "assets/files/map-flat.json",
    );

    if (!controllerCompleter.isCompleted) {
      controllerCompleter.complete(controller);
    }

    controller.setMapStyle(mapStyle);
  }

  void onPositionChanged() {
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);
    Position currentPosition = dataProvider.dataModel.currentPosition!;
    updateCameraPosition(currentPosition);

    Marker marker = Marker(
      markerId: const MarkerId('Position actuelle'),
      position: LatLng(currentPosition.latitude, currentPosition.longitude),
    );

    setState(() {
      markers = {marker};
    });
  }

  Future<void> updateCameraPosition(Position position) async {
    if (controllerCompleter.isCompleted) {
      GoogleMapController mapController = await controllerCompleter.future;
      CameraUpdate cameraUpdate = CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude),
      );
      mapController.animateCamera(cameraUpdate);
    }
  }

  Future<void> showRadiusBottomSheet() async {
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);
    int? currentRadius = dataProvider.dataModel.radius!.toInt();
    int selectedRadiusIndex = radiusOptions.indexOf(currentRadius);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 320,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: Column(
            children: [
              const Text(
                "Sélectionner un rayon",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Faites défiler pour choisir un rayon en kilomètres pour votre recherche.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                      initialItem: selectedRadiusIndex),
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) {
                    selectedRadiusIndex = index;
                  },
                  children: List<Widget>.generate(
                    radiusOptions.length,
                    (int index) {
                      return Text(radiusOptions[index].toString());
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ButtonRoundedText(
                content: "Enregistrer",
                callback: () {
                  dataProvider.updateRadius(radiusOptions[selectedRadiusIndex]);
                  Navigator.pop(context);
                },
                backgroundColor: Colors.orange,
                textColor: Colors.white,
                elevation: 1,
              )
            ],
          ),
        );
      },
    );
  }

  Future<List<Place>> fetchPlaces(
    String? filter,
    Position position,
    int? radius,
  ) async {
    return await placesService.fetchNearbyPlaces(
        LatLng(position.latitude, position.longitude),
        radius?.toDouble() ?? 5,
        filter ?? "");
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              HeadingUserWidget(
                onAvatarTap: () {
                  widget.onPageChange(3);
                },
              ),
              const SizedBox(height: 30),
              CardLocationWidget(
                onMapCreated: onMapCreated,
                controllerCompleter: controllerCompleter,
                markers: markers,
                onRadiusButtonTap: showRadiusBottomSheet,
              ),
              const SizedBox(height: 20),
              const CategoryHeadingWidget(),
              const SizedBox(height: 20),
              const FiltersWidget(),
              const SizedBox(height: 20),
              const ResultsHeadingWidget(),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: Selector<DataProvider, Tuple3<String?, Position?, int?>>(
                  selector: (context, dataProvider) => Tuple3(
                    dataProvider.dataModel.filter,
                    dataProvider.dataModel.currentPosition,
                    dataProvider.dataModel.radius,
                  ),
                  builder: (context, tuple, child) {
                    String? filter = tuple.item1;
                    Position? currentPosition = tuple.item2;
                    int? radius = tuple.item3;

                    if (dataLoaded) {
                      return FutureBuilder<List<Place>>(
                        future: fetchPlaces(filter, currentPosition!, radius),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<List<Place>> snapshot,
                        ) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return NearbyPlacesShimmerWidget(
                              screenWidth: screenWidth,
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Erreur : ${snapshot.error}'),
                            );
                          } else {
                            return NearbyPlacesWidget(
                              places: snapshot.data!,
                              screenWidth: screenWidth,
                            );
                          }
                        },
                      );
                    } else {
                      return NearbyPlacesShimmerWidget(
                        screenWidth: screenWidth,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
