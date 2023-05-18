// Flutter
import 'package:flutter/material.dart';
import 'dart:io';

// Services
import 'package:dogo_final_app/services/places.dart';

// Provider
import 'package:dogo_final_app/provider/provider.dart';
import 'package:dogo_final_app/provider/form_provider.dart';

// Utilities
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class CreateLocationMapView extends StatefulWidget {
  const CreateLocationMapView({super.key});

  @override
  State<CreateLocationMapView> createState() => _CreateLocationMapViewState();
}

class _CreateLocationMapViewState extends State<CreateLocationMapView> {
  final PlacesService placesService = PlacesService();

  CollectionReference places = FirebaseFirestore.instance.collection('places');
  FirebaseStorage storage = FirebaseStorage.instance;
  ValueNotifier<bool> isCreatingLocation = ValueNotifier<bool>(false);

  GoogleMapController? mapController;
  LatLng? lastMapPosition;

  Set<Marker> markers = {};

  late FormProvider formProvider;

  @override
  void initState() {
    super.initState();
    formProvider = Provider.of<FormProvider>(context, listen: false);
  }

  Future<String> uploadImage(File image) async {
    Reference storageReference =
        storage.ref().child("images/${path.basename(image.path)}");

    UploadTask uploadTask = storageReference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void updateMarker(LatLng position) {
    setState(() {
      markers.clear();
      markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          draggable: true,
          onDragEnd: (newPosition) => updateMarker(newPosition),
        ),
      );
      lastMapPosition = position;
    });
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

  Future<void> createLocation() async {
    String pictureUrl = await uploadImage(formProvider.image!);
    LatLng position = lastMapPosition!;
    Map<String, String> placesDetails =
        await placesService.getPlace(position.latitude, position.longitude);
    String? address = placesDetails['address'];
    String? city = placesDetails['city'];

    DocumentReference documentReference = places.doc();

    await documentReference.set({
      'id': documentReference.id,
      'address': address,
      'city': city,
      'description': formProvider.description,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'name': formProvider.name,
      'type': 'Parcs',
      'pictures': [
        pictureUrl,
      ],
      'routes': [GeoPoint(position.latitude, position.longitude)]
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
          markers: markers,
          onTap: updateMarker,
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
                  valueListenable: isCreatingLocation,
                  builder:
                      (BuildContext context, bool isCreating, Widget? child) {
                    return Material(
                      shape: const CircleBorder(),
                      color: Colors.orangeAccent,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: isCreating
                            ? null
                            : () async {
                                if (lastMapPosition != null) {
                                  isCreatingLocation.value = true;
                                  await createLocation();
                                  isCreatingLocation.value = false;
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
                              : const Icon(
                                  Icons.check,
                                  color: Colors.white,
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
