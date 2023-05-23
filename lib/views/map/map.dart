// Flutter
import 'package:dogo_final_app/models/firebase/place.dart';
import 'package:flutter/material.dart';

// Components
import 'package:dogo_final_app/views/pages/home/widgets/filters.dart';

// Services
import 'package:dogo_final_app/services/location.dart';

// Utilities
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Provider
import 'package:dogo_final_app/provider/provider.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

// Widget le plus important dans lequel on peut effectuer une navigation et afficher des informations selon les filtres.
// On peut également créer des trajets et des emplacements.
class _GoogleMapViewState extends State<GoogleMapView> {
  final LocationService locationService = LocationService();
  final CollectionReference placesCollection =
      FirebaseFirestore.instance.collection('places');

  GoogleMapController? controller;

  List<DocumentSnapshot> allPlaces = [];
  Set<Marker> markers = {};
  Set<String> markerIds = {};

  bool isCardDisplayed = false;
  DocumentSnapshot? currentMarker;

  late VoidCallback listener;
  late DataProvider dataProvider;

  bool placesLoaded = false;

  @override
  void initState() {
    super.initState();

    // On récupère tous les emplacements et on vient les enregistrer dans une variable qu'on réutilise.
    // Je suis conscient que la base de données ne sera pas rempli donc ça ne posera pas de problème de performance.
    fetchAllPlaces();
    dataProvider = Provider.of<DataProvider>(context, listen: false);

    // J'écoute chaque changement de filtre pour mettre à jour les marqueurs sur la carte.
    listener = () {
      String filter = dataProvider.dataModel.filter!;
      updateMarkers(filter);
    };
    dataProvider.addListener(listener);
  }

  @override
  void dispose() {
    dataProvider.removeListener(listener);
    super.dispose();
  }

  Future<void> fetchAllPlaces() async {
    QuerySnapshot placesSnapshot = await placesCollection.get();
    allPlaces = placesSnapshot.docs;
    placesLoaded = true;
    setState(() {});
  }

  Future<void> onMapCreated(GoogleMapController mapController) async {
    mapController.setMapStyle(
      await locationService.loadMapStyle(
        file: "assets/files/map-details.json",
      ),
    );

    controller = mapController;
  }

  Future<void> onCameraMove(CameraPosition position) async {
    LatLngBounds visibleRegion = await controller!.getVisibleRegion();

    Set<Marker> newMarkers = {};
    Set<String> newMarkerIds = {};

    String filter =
        // ignore: use_build_context_synchronously
        Provider.of<DataProvider>(context, listen: false).dataModel.filter!;

    for (var doc in allPlaces) {
      if (filter.isNotEmpty && doc['type'] != filter) {
        continue;
      }

      double placeLatitude = doc['latitude'];
      double placeLongitude = doc['longitude'];
      LatLng placeLatLng = LatLng(placeLatitude, placeLongitude);

      if (visibleRegion.contains(placeLatLng)) {
        Marker marker = Marker(
          markerId: MarkerId(doc.id),
          position: placeLatLng,
          onTap: () {
            setState(() {
              isCardDisplayed = true;
              currentMarker = doc;
            });
          },
        );
        newMarkers.add(marker);
        newMarkerIds.add(doc.id);
      }
    }

    markers.addAll(newMarkers
        .where((marker) => !markerIds.contains(marker.markerId.value)));

    markers
        .removeWhere((marker) => !newMarkerIds.contains(marker.markerId.value));

    markerIds = newMarkerIds;

    setState(() {});
  }

  Future<void> updateMarkers(String filter) async {
    LatLngBounds visibleRegion = await controller!.getVisibleRegion();

    Set<Marker> newMarkers = {};
    Set<String> newMarkerIds = {};

    for (var doc in allPlaces) {
      if (filter.isNotEmpty && doc['type'] != filter) {
        continue;
      }

      double placeLatitude = doc['latitude'];
      double placeLongitude = doc['longitude'];
      LatLng placeLatLng = LatLng(placeLatitude, placeLongitude);

      if (visibleRegion.contains(placeLatLng)) {
        Marker marker = Marker(
            markerId: MarkerId(doc.id),
            position: placeLatLng,
            onTap: () {
              setState(() {
                isCardDisplayed = true;
                currentMarker = doc;
              });
            });
        newMarkers.add(marker);
        newMarkerIds.add(doc.id);
      }
    }

    markers.addAll(newMarkers
        .where((marker) => !markerIds.contains(marker.markerId.value)));

    markers
        .removeWhere((marker) => !newMarkerIds.contains(marker.markerId.value));

    markerIds = newMarkerIds;

    setState(() {});
  }

  // Modification de la localisation actuelle de l'utilisateur et enregistrement de la position dans le provider.
  Future<void> updateCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception("La localisation n'est pas activée.");
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // ignore: use_build_context_synchronously
      Provider.of<DataProvider>(context, listen: false)
          .updateCurrentPosition(position);

      controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14.0,
          ),
        ),
      );
    } catch (exception) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final dataProvider = Provider.of<DataProvider>(context);
    final currentPosition = dataProvider.dataModel.currentPosition;

    final CameraPosition initialPosition = currentPosition != null
        ? CameraPosition(
            target: LatLng(currentPosition.latitude, currentPosition.longitude),
            zoom: 11.0,
          )
        : const CameraPosition(
            target: LatLng(48.8566, 2.3522),
            zoom: 11.0,
          );

    return GestureDetector(
      onTap: () {
        setState(() {
          isCardDisplayed = false;
        });
      },
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: initialPosition,
              onMapCreated: onMapCreated,
              onCameraMove: onCameraMove,
              markers: placesLoaded ? markers : {},
              onTap: (LatLng latLng) => {
                setState(() {
                  isCardDisplayed = false;
                })
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
            SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    left: 16,
                    child: Material(
                      shape: const CircleBorder(),
                      color: Colors.orangeAccent,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () async => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    right: 0,
                    child: SizedBox(
                      height: 50,
                      child: FiltersWidget(type: 'map'),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 16,
                    child: FloatingActionButton(
                      backgroundColor: Colors.orange,
                      onPressed: () async => await updateCurrentLocation(),
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 64,
                    right: 16,
                    child: Material(
                      shape: const CircleBorder(),
                      color: Colors.orange,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Text(
                                        'Que souhaites-tu créer ? 🤔',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              child: Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 14,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: const Text(
                                                  "Un parc 🌳",
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/create-location',
                                                );
                                              },
                                            ),
                                            const SizedBox(height: 6),
                                            GestureDetector(
                                              child: Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 14,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: const Text(
                                                  "Un trajet avec la main 🖐️",
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/create-walk',
                                                );
                                              },
                                            ),
                                            const SizedBox(height: 6),
                                            GestureDetector(
                                              child: Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 14,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: const Text(
                                                  "Un trajet avec la position 📍",
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/create-walk-update',
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  if (isCardDisplayed)
                    Positioned(
                      bottom: 0,
                      left: screenWidth * 0.03,
                      right: screenWidth * 0.03,
                      child: InkWell(
                        onTap: () {
                          Place place = Place.fromDocument(currentMarker!);

                          Navigator.pushNamed(
                            context,
                            '/place-details',
                            arguments: {'place': place, 'heroTag': place.id},
                          );
                        },
                        child: Stack(
                          children: [
                            Hero(
                              tag: currentMarker!['id'],
                              child: Container(
                                width: screenWidth,
                                height: 230,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      currentMarker!['pictures'].isNotEmpty
                                          ? currentMarker!['pictures'][0]
                                          : "https://cdn.pixabay.com/photo/2016/08/11/23/48/mountains-1587287_1280.jpg",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              right: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(1),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 18,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentMarker!['name'],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${currentMarker!['city']} - ${currentMarker!['type']}",
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
