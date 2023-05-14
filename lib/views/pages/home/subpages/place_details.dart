// Flutter
import 'package:flutter/material.dart';

// Utilities
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogo_final_app/provider/provider.dart';

// Components
import 'package:dogo_final_app/views/pages/home/widgets/detail_sliver_delegate.dart';
import 'package:dogo_final_app/views/pages/home/widgets/place_info.dart';

// Models
import 'package:dogo_final_app/models/firebase/place.dart';

class PlaceDetailsPageView extends StatefulWidget {
  final Place place;
  final dynamic heroTag;

  const PlaceDetailsPageView(
      {super.key, required this.place, required this.heroTag});

  @override
  State<PlaceDetailsPageView> createState() => _PlaceDetailsPageViewState();
}

class _PlaceDetailsPageViewState extends State<PlaceDetailsPageView> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  bool isBookmarked = false;
  late double distanceInKilometers;

  void checkIfPlaceIsBookmarked() async {
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(user?.uid).get();

    List<dynamic> bookmarks = userDoc.get('bookmarks');
    setState(() {
      isBookmarked = bookmarks.contains(widget.place.id);
    });
  }

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

    checkIfPlaceIsBookmarked();
  }

  void onBookmarkTapped() {
    if (isBookmarked) {
      firestore.collection('users').doc(user?.uid).update({
        'bookmarks': FieldValue.arrayRemove([widget.place.id])
      });
    } else {
      firestore.collection('users').doc(user?.uid).update({
        'bookmarks': FieldValue.arrayUnion([widget.place.id])
      });
    }

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
