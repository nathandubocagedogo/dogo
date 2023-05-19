// Flutter
import 'package:flutter/material.dart';

// Utilities
import 'package:lottie/lottie.dart';

class LandingSecond extends StatelessWidget {
  const LandingSecond({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: screenWidth * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Participe à la communauté !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Tu peux publier tes propres trajets, ce qui permettra aux autres utilisateurs de les découvrir.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.3,
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    child: Lottie.asset('assets/lottie/map.json'),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
