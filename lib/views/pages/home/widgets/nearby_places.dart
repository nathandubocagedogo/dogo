// Flutter
import 'package:dogo_final_app/provider/provider.dart';
import 'package:flutter/material.dart';

// Utilities
import 'package:carousel_slider/carousel_slider.dart';

// Models
import 'package:dogo_final_app/models/firebase/place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class NearbyPlacesWidget extends StatefulWidget {
  final double screenWidth;
  final List<Place> places;

  const NearbyPlacesWidget({
    super.key,
    required this.places,
    required this.screenWidth,
  });

  @override
  State<NearbyPlacesWidget> createState() => _NearbyPlacesWidgetState();
}

class _NearbyPlacesWidgetState extends State<NearbyPlacesWidget> {
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
    if (widget.places.isEmpty) {
      return const Center(
        child: Text("Aucun lieu trouvé à proximité"),
      );
    }

    return CarouselSlider.builder(
      options: CarouselOptions(
        viewportFraction: 1,
        height: 300,
        enableInfiniteScroll: false,
      ),
      itemCount: widget.places.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        Place place = widget.places[index];
        double distanceInKilometers = Geolocator.distanceBetween(
                currentPosition.latitude,
                currentPosition.longitude,
                place.latitude,
                place.longitude) /
            1000;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            index == 0 ? widget.screenWidth * 0.05 : 0,
            0,
            index == widget.places.length - 1
                ? widget.screenWidth * 0.04
                : widget.screenWidth * 0.04,
            0,
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/place-details',
                arguments: {'place': place, 'heroTag': place.id},
              );
            },
            child: Stack(
              children: [
                Hero(
                  tag: place.id,
                  child: Container(
                    width: 350,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        );
      },
    );
  }
}
