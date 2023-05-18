// Flutter
import 'package:flutter/material.dart';

// Components
import 'package:dogo_final_app/components/buttons/button_rounded_text.dart';

// Models
import 'package:dogo_final_app/models/firebase/place.dart';

// Utilities
import 'package:readmore/readmore.dart';
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  place.city,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "à ${distance.toStringAsFixed(2)} km d'ici",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.info,
                      size: 12,
                      color: Colors.deepOrange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      place.warning,
                      style: const TextStyle(
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
                  if (place.type == 'Balades')
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
                  if (place.type == 'Balades')
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
                ],
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
            ElevatedButton(
              onPressed: () async {
                final url =
                    'https://www.google.com/maps/search/?api=1&query=${place.latitude},${place.longitude}';
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(url);
                } else {
                  throw 'Impossible de lancer $url';
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Me rendre sur le lieu",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 4),
            if (place.type == 'Balades')
              ButtonRoundedText(
                spacing: 12,
                backgroundColor: Colors.orange,
                textColor: Colors.white,
                content: 'Faire la balade',
                callback: () {
                  Navigator.pushNamed(
                    context,
                    '/make-activity',
                    arguments: {
                      'place': place,
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
