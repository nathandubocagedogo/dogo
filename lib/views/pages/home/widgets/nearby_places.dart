// Flutter
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dogo_final_app/views/pages/home/subpages/place_details.dart';
import 'package:flutter/material.dart';

// Models
import 'package:dogo_final_app/models/firebase/place.dart';

class NearbyPlacesWidget extends StatelessWidget {
  final double screenWidth;
  final List<Place> places;

  const NearbyPlacesWidget({
    super.key,
    required this.places,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return const Center(
        child: Text("Aucun lieu trouvé à proximité"),
      );
    }

    return CarouselSlider.builder(
      options: CarouselOptions(
        viewportFraction: 0.99,
        height: 300,
        enableInfiniteScroll: false,
      ),
      itemCount: places.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        Place place = places[index];

        return Padding(
          padding: EdgeInsets.fromLTRB(
            index == 0 ? screenWidth * 0.05 : 0,
            0,
            index == places.length - 1
                ? screenWidth * 0.04
                : screenWidth * 0.04,
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
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(14),
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
                          Text(
                            place.city,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                            ),
                          ),
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
