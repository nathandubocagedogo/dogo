import 'package:dogo_final_app/components/buttons/button_rounded_text.dart';
import 'package:flutter/material.dart';
import 'package:dogo_final_app/models/firebase/place.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PlaceInfo extends StatelessWidget {
  final Place place;
  final double distance;

  const PlaceInfo({super.key, required this.place, required this.distance});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: screenWidth * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(
              place.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "${place.city} | à ${distance.toStringAsFixed(2)} km d'ici",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            IntrinsicWidth(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.deepOrange[100],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info,
                      size: 12,
                      color: Colors.deepOrange,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Souvent beaucoup de monde",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Description",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            ReadMoreText(
              place.description,
              trimLines: 6,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Voir plus',
              trimExpandedText: 'Réduire',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              moreStyle: const TextStyle(
                fontSize: 14,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Informations pratiques",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                          children: [
                            const TextSpan(text: "Adresse : "),
                            TextSpan(
                              text: place.address,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                          children: [
                            TextSpan(text: "Difficulté "),
                            TextSpan(
                              text: "Facile",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                          children: [
                            TextSpan(text: "Durée moyenne "),
                            TextSpan(
                              text: "25 minutes",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                          children: [
                            TextSpan(text: "Typologie : "),
                            TextSpan(
                              text: "Route, Herbe, Terre",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Actions",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            ButtonRoundedText(
              spacing: 12,
              backgroundColor: Colors.orange,
              textColor: Colors.white,
              content: 'Me rendre sur le lieu',
              callback: () async {
                final url =
                    'https://www.google.com/maps/search/?api=1&query=${place.latitude},${place.longitude}';
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(url);
                } else {
                  throw 'Impossible de lancer $url';
                }
              },
            ),
            const SizedBox(height: 4),
            ButtonRoundedText(
              spacing: 12,
              backgroundColor: Colors.orange,
              textColor: Colors.white,
              content: 'Faire la balade',
              callback: () {},
            ),
          ],
        ),
      ),
    );
  }
}
