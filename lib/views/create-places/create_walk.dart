// Flutter
import 'package:flutter/material.dart';

// Utilities
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateWalkView extends StatefulWidget {
  const CreateWalkView({super.key});

  @override
  State<CreateWalkView> createState() => _CreateWalkViewState();
}

class _CreateWalkViewState extends State<CreateWalkView> {
  GoogleMapController? mapController;

  Set<Polyline> polylines = {};
  List<LatLng> routePoints = [];

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void addPointToRoute(LatLng position) {
    setState(() {
      routePoints.add(position);
      updateRoute();
    });
  }

  void updateRoute() {
    Polyline polyline = Polyline(
      polylineId: const PolylineId('Route principale'),
      visible: true,
      points: routePoints,
      color: Colors.orange,
    );

    polylines.add(polyline);
  }

  void saveRoute() {
    List<GeoPoint> routePoints = this
        .routePoints
        .map((latLng) => GeoPoint(latLng.latitude, latLng.longitude))
        .toList();

    FirebaseFirestore.instance.collection('routes').add({
      'points': routePoints,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer une balade"),
        leading: const BackButton(),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.save,
              color: Colors.red,
            ),
            onPressed: saveRoute,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: onMapCreated,
              initialCameraPosition: const CameraPosition(target: LatLng(0, 0)),
              onTap: addPointToRoute,
              polylines: polylines,
            ),
          )
        ],
      ),
    );
  }
}
