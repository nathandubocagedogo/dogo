// Flutter
import 'package:flutter/material.dart';

class NearbyPlacesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> places;

  const NearbyPlacesWidget({
    super.key,
    required this.places,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Mon appel à l'API s'est effectué avec succès !"),
      ),
    );
  }
}
