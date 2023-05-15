import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateWalkView extends StatefulWidget {
  const CreateWalkView({super.key});

  @override
  State<CreateWalkView> createState() => _CreateWalkViewState();
}

class _CreateWalkViewState extends State<CreateWalkView> {
  GoogleMapController? mapController;
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> _routePoints = [];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _addPointToRoute(LatLng position) {
    setState(() {
      _routePoints.add(position);
      _updateRoute();
    });
  }

  void _updateRoute() {
    Polyline polyline = Polyline(
      polylineId: PolylineId('route1'),
      visible: true,
      points: _routePoints,
      color: Colors.blue,
    );

    _polylines.add(polyline);
  }

  void _saveRoute() {
    // Convert _routePoints to a List of GeoPoints
    List<GeoPoint> routePoints = _routePoints
        .map((latLng) => GeoPoint(latLng.latitude, latLng.longitude))
        .toList();

    // Save routePoints in Firestore
    FirebaseFirestore.instance.collection('routes').add({
      'points': routePoints,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        title: const Text("Créer une balade"),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(target: LatLng(0, 0)),
              onTap: _addPointToRoute,
              polylines: _polylines,
            ),
          )
        ],
      ),
    );
  }
}
