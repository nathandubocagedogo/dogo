// Flutter
import 'package:flutter/material.dart';

// Utilities
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardEmailNotVerifiedWidget extends StatelessWidget {
  final String email;

  const CardEmailNotVerifiedWidget({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              FontAwesomeIcons.envelopesBulk,
              color: Colors.orange,
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vérifies ton e-mail',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Nous avons envoyé un e-mail à\n$email.',
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.3,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
