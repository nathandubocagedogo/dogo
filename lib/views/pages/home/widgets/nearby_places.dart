// Flutter
import 'package:flutter/material.dart';

// Services
import 'package:dogo_final_app/services/places.dart';

// Utilities
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearbyPlaces extends StatefulWidget {
  final LatLng position;
  final String? filter;
  final double? radius;

  const NearbyPlaces(
      {super.key, required this.position, this.filter, this.radius});

  @override
  State<NearbyPlaces> createState() => _NearbyPlacesState();
}

class _NearbyPlacesState extends State<NearbyPlaces> {
  final PlacesService placesService = PlacesService();

  late Future<List<Map<String, dynamic>>> nearbyPlacesFuture;

  @override
  void initState() {
    super.initState();
    nearbyPlacesFuture = placesService.fetchAllNearbyPlaces(
      widget.position,
      100,
    );
  }

  @override
  void didUpdateWidget(NearbyPlaces oldWidget) {
    super.didUpdateWidget(oldWidget);
    bool positionChanged = widget.position != oldWidget.position;
    bool filterChanged = widget.filter != oldWidget.filter;
    bool radiusChanged = widget.radius != oldWidget.radius;

    if (positionChanged || filterChanged || radiusChanged) {
      nearbyPlacesFuture = placesService.fetchAllNearbyPlaces(
        widget.position,
        100,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: nearbyPlacesFuture,
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        } else {
          return const Scaffold(
            body: Center(
              child: Text("Mon appel à l'API s'est effectué avec succès !"),
            ),
          );
        }
      },
    );
  }
}
