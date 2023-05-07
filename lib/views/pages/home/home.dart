// Flutter
import 'package:flutter/material.dart';

// Services
import 'package:dogo_final_app/services/places.dart';

// Components
import 'package:dogo_final_app/views/pages/home/widgets/filters.dart';
import 'package:dogo_final_app/views/pages/home/widgets/nearby_places.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';

// Provider
import 'package:dogo_final_app/provider/provider.dart';

// Utilities
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tuple/tuple.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView>
    with AutomaticKeepAliveClientMixin {
  final PlacesService placesService = PlacesService();
  final User? user = FirebaseAuth.instance.currentUser;

  late bool dataLoaded = false;

  @override
  void initState() {
    super.initState();
    initializeProvider();
  }

  Future<void> initializeProvider() async {
    // await Future.wait([
    //   getCurrentLocation(),
    //   setFilter(),
    // ]);

    // setState(() {
    //   dataLoaded = true;
    // });
  }

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception("Location permission denied");
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        Provider.of<DataProvider>(context, listen: false)
            .updateCurrentPosition(position);
      }
    } catch (exception) {
      rethrow;
    }
  }

  Future<void> setFilter() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DataProvider>(context, listen: false).updateFilter("");
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Filters(),
            Expanded(
              child:
                  Selector<DataProvider, Tuple3<String?, Position?, double?>>(
                selector: (context, dataProvider) => Tuple3(
                  dataProvider.dataModel.filter,
                  dataProvider.dataModel.currentPosition,
                  dataProvider.dataModel.radius,
                ),
                builder: (context, tuple, child) {
                  String? filter = tuple.item1;
                  Position? currentPosition = tuple.item2;
                  double? radius = tuple.item3;

                  if (!dataLoaded) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return NearbyPlaces(
                      position: LatLng(
                        currentPosition!.latitude,
                        currentPosition.longitude,
                      ),
                      filter: filter,
                      radius: radius,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
