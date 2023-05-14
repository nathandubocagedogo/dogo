import 'package:dogo_final_app/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:dogo_final_app/views/pages/home/widgets/detail_sliver_delegate.dart';
import 'package:dogo_final_app/views/pages/home/widgets/place_info.dart';
import 'package:dogo_final_app/models/firebase/place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class PlaceDetailsPageView extends StatefulWidget {
  final Place place;
  final dynamic heroTag;

  const PlaceDetailsPageView(
      {super.key, required this.place, required this.heroTag});

  @override
  State<PlaceDetailsPageView> createState() => _PlaceDetailsPageViewState();
}

class _PlaceDetailsPageViewState extends State<PlaceDetailsPageView> {
  bool isBookmarked = false;
  late double distanceInKilometers;

  @override
  void initState() {
    super.initState();
    dynamic currentPosition = Provider.of<DataProvider>(context, listen: false)
        .dataModel
        .currentPosition;

    distanceInKilometers = Geolocator.distanceBetween(
            currentPosition.latitude,
            currentPosition.longitude,
            widget.place.latitude,
            widget.place.longitude) /
        1000;
  }

  void onBookmarkTapped() {
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: DetailSliverDelegate(
              heroTag: widget.heroTag,
              place: widget.place,
              expandedHeight: 260,
              roundedContainerHeight: 30,
              isBookmarked: isBookmarked,
              onBookmarkTapped: onBookmarkTapped,
            ),
          ),
          SliverToBoxAdapter(
            child: PlaceInfo(
              place: widget.place,
              distance: distanceInKilometers,
            ),
          )
        ],
      ),
    );
  }
}
