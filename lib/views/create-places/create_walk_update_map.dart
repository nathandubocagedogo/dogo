// Flutter
import 'package:flutter/material.dart';
import 'dart:async';

// Services
import 'package:dogo_final_app/services/storage.dart';
import 'package:dogo_final_app/services/places.dart';

// Provider
import 'package:dogo_final_app/provider/provider.dart';
import 'package:dogo_final_app/provider/form_provider.dart';

// Utilities
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CreateWalkUpdateMapView extends StatefulWidget {
  const CreateWalkUpdateMapView({Key? key}) : super(key: key);

  @override
  State<CreateWalkUpdateMapView> createState() =>
      _CreateWalkUpdateMapViewState();
}

class _CreateWalkUpdateMapViewState extends State<CreateWalkUpdateMapView> {
  final PlacesService placesService = PlacesService();
  final StorageService storageService = StorageService();

  CollectionReference places = FirebaseFirestore.instance.collection('places');
  FirebaseStorage storage = FirebaseStorage.instance;
  ValueNotifier<bool> isCreatingWalk = ValueNotifier<bool>(false);

  GoogleMapController? mapController;
  Stream<Position>? positionStream;
  StreamSubscription<Position>? positionStreamSubscription;

  Set<Polyline> polylines = {};
  List<LatLng> routePoints = [];

  late FormProvider formProvider;

  @override
  void initState() {
    super.initState();
    initLocation();
    formProvider = Provider.of<FormProvider>(context, listen: false);
  }

  @override
  void dispose() {
    if (positionStreamSubscription != null) {
      positionStreamSubscription!.cancel();
      positionStreamSubscription = null;
    }
    super.dispose();
  }

  Future<void> initLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    positionStream = Geolocator.getPositionStream();
    positionStreamSubscription = positionStream?.listen((Position position) {
      addPointToRoute(LatLng(position.latitude, position.longitude));
    });
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Pour éviter de faire un tracé régulièrement et avoir une masse de point, on va tracer un point tous les 5 mètres
  void addPointToRoute(LatLng position) {
    if (routePoints.isEmpty) {
      routePoints.add(position);
    } else {
      double distance = Geolocator.distanceBetween(
        routePoints.last.latitude,
        routePoints.last.longitude,
        position.latitude,
        position.longitude,
      );

      double minDistance = 5;

      if (distance >= minDistance) {
        routePoints.add(position);
      }
    }

    updateRoute();
  }

  void updateRoute() {
    setState(() {
      Polyline polyline = Polyline(
        polylineId: const PolylineId('Route principale'),
        visible: true,
        points: routePoints,
        color: Colors.orange,
      );

      polylines.clear();
      polylines.add(polyline);
    });
  }

  void stopTracking() {
    if (positionStreamSubscription != null) {
      positionStreamSubscription!.cancel();
      positionStreamSubscription = null;
    }
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

      mapController?.animateCamera(
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

  Future<void> createWalk() async {
    stopTracking();
    String pictureUrl = await storageService.uploadImage(formProvider.image!);
    List<GeoPoint> routePoints = this
        .routePoints
        .map((latLng) => GeoPoint(latLng.latitude, latLng.longitude))
        .toList();

    GeoPoint startPoint = routePoints[0];

    Map<String, String> placesDetails =
        await placesService.getPlace(startPoint.latitude, startPoint.longitude);
    String? address = placesDetails['address'];
    String? city = placesDetails['city'];

    DocumentReference documentReference = places.doc();

    await documentReference.set({
      'id': documentReference.id,
      'address': address,
      'city': city,
      'description': formProvider.description,
      'latitude': startPoint.latitude,
      'longitude': startPoint.longitude,
      'name': formProvider.name,
      'difficulty': formProvider.difficulty,
      'duration': formProvider.time,
      'warning': formProvider.warning,
      'type': 'Balades',
      'pictures': [
        pictureUrl,
      ],
      'routes': routePoints
    });

    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
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

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: onMapCreated,
          initialCameraPosition: initialPosition,
          polylines: polylines,
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
                    onTap: () async {
                      stopTracking();
                      Navigator.pop(context);
                    },
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
              Positioned(
                right: 16,
                child: ValueListenableBuilder<bool>(
                  valueListenable: isCreatingWalk,
                  builder:
                      (BuildContext context, bool isCreating, Widget? child) {
                    return Material(
                      shape: const CircleBorder(),
                      color: routePoints.length < 2
                          ? Colors.grey
                          : Colors.orangeAccent,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: isCreating
                            ? null
                            : () async {
                                if (routePoints.isNotEmpty) {
                                  isCreatingWalk.value = true;
                                  await createWalk();
                                  isCreatingWalk.value = false;
                                }
                              },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: isCreating
                              ? const SizedBox(
                                  width: 24.0,
                                  height: 24.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  Icons.check,
                                  color: routePoints.length < 2
                                      ? Colors.white30
                                      : Colors.white,
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: Colors.orange,
            onPressed: () async {
              await updateCurrentLocation();
            },
            child: const Icon(
              Icons.my_location,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
