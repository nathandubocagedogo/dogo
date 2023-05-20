// Flutter
import 'package:flutter/material.dart';

// Models
import 'package:dogo_final_app/models/firebase/place.dart';

// Provider
import 'package:dogo_final_app/provider/provider.dart';

// Services
import 'package:dogo_final_app/services/bookmarks.dart';

// Utilities
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class BookmarsPageView extends StatefulWidget {
  const BookmarsPageView({super.key});

  @override
  State<BookmarsPageView> createState() => _BookmarsPageViewState();
}

class _BookmarsPageViewState extends State<BookmarsPageView> {
  final BookmarksService bookmarksService = BookmarksService();
  User? user = FirebaseAuth.instance.currentUser;
  late dynamic currentPosition;

  @override
  void initState() {
    super.initState();
    currentPosition = Provider.of<DataProvider>(context, listen: false)
        .dataModel
        .currentPosition;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text("Mes favoris"),
      ),
      body: FutureBuilder(
        future: bookmarksService.getUserBookmarks(user!.uid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.data.isEmpty) {
            return const Center(child: Text('Aucun favoris enregistré'));
          } else {
            List<Place> bookmarks = snapshot.data;
            return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: bookmarks.length,
              itemBuilder: (BuildContext context, int index) {
                Place place = bookmarks[index];
                double distanceInKilometers = Geolocator.distanceBetween(
                        currentPosition.latitude,
                        currentPosition.longitude,
                        place.latitude,
                        place.longitude) /
                    1000;

                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/place-details',
                      arguments: {'place': place, 'heroTag': place.id},
                    );
                  },
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: screenWidth * 0.9,
                      child: Stack(
                        children: [
                          Hero(
                            tag: place.id,
                            child: Container(
                              width: screenWidth * 0.9,
                              height: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    place.pictures.isNotEmpty
                                        ? place.pictures[0]
                                        : "https://cdn.pixabay.com/photo/2016/08/11/23/48/mountains-1587287_1280.jpg",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            right: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(1),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 18,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      place.name,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${place.city} - ${place.type}",
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          "à ${distanceInKilometers.toStringAsFixed(2)} km",
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
