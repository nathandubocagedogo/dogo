import 'package:dogo_final_app/models/firebase/place.dart';
import 'package:flutter/material.dart';

class PlaceDetailsPageView extends StatefulWidget {
  final Place place;

  const PlaceDetailsPageView({super.key, required this.place});

  @override
  State<PlaceDetailsPageView> createState() => _PlaceDetailsPageViewState();
}

class _PlaceDetailsPageViewState extends State<PlaceDetailsPageView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
