// Flutter
import 'package:dogo_final_app/views/pages/home/widgets/filters.dart';
import 'package:flutter/material.dart';

// Firebase
import 'package:cloud_firestore/cloud_firestore.dart';

// Services
import 'package:dogo_final_app/services/location.dart';

// Utilities
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Provider
import 'package:dogo_final_app/provider/provider.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  final LocationService locationService = LocationService();
  final CollectionReference placesCollection =
      FirebaseFirestore.instance.collection('places');

  GoogleMapController? controller;
  List<DocumentSnapshot> allPlaces = [];
  Set<Marker> markers = {};
  Set<String> markerIds = {};

  @override
  initState() {
    super.initState();
    fetchAllPlaces();
    Provider.of<DataProvider>(context, listen: false).addListener(() {
      String filter =
          Provider.of<DataProvider>(context, listen: false).dataModel.filter!;
      updateMarkers(filter);
    });
  }

  Future<void> fetchAllPlaces() async {
    QuerySnapshot placesSnapshot = await placesCollection.get();
    allPlaces = placesSnapshot.docs;
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
        String iconPath = 'assets/icons/default.png';

        if (doc['type'] == 'Parcs') {
          iconPath = 'assets/map/default.png';
        } else if (doc['type'] == 'Balades') {
          iconPath = 'assets/map/default.png';
        }

        BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(devicePixelRatio: 2.0),
          iconPath,
        );

        Marker marker = Marker(
          markerId: MarkerId(doc.id),
          position: placeLatLng,
          icon: icon,
          infoWindow: InfoWindow(title: doc['name']),
          onTap: () {},
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
          infoWindow: InfoWindow(title: doc['name']),
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
  }

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

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialPosition,
            onMapCreated: onMapCreated,
            onCameraMove: onCameraMove,
            markers: markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () async {
                await updateCurrentLocation();
              },
              child: const Icon(Icons.my_location),
            ),
          ),
          Positioned(
            bottom: 80,
            right: 16,
            child: Material(
              shape: const CircleBorder(),
              color: Colors.blue,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Choisissez une option'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              GestureDetector(
                                child: const Text("Créer un emplacement"),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/create-location',
                                  );
                                },
                              ),
                              const Padding(padding: EdgeInsets.all(8.0)),
                              GestureDetector(
                                child: const Text("Créer une balade"),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/create-walk',
                                  );
                                },
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
          const SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 50,
                child: FiltersWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FiltersBar extends StatelessWidget {
  const FiltersBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FilterButton(filter: 'Parcs'),
        FilterButton(filter: 'Balades'),
        FilterButton(filter: 'Shop'),
        FilterButton(filter: 'Vétérinaires'),
        FilterButton(filter: 'Toiletteurs'),
      ],
    );
  }
}

class FilterButton extends StatelessWidget {
  final String filter;

  const FilterButton({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Provider.of<DataProvider>(context, listen: false).dataModel.filter =
            filter;
      },
      child: Text(filter),
    );
  }
}
