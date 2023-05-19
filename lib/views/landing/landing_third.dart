// Flutter
import 'package:flutter/material.dart';

// Utilities
import 'package:lottie/lottie.dart';

class LandingThird extends StatelessWidget {
  const LandingThird({super.key});

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
                  'Sociabilise avec les passionnés !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Rejoins des groupes qui correspondent à tes centres d\'intérêts et discute avec les autres membres.',
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
                    child: Lottie.asset(
                      'assets/lottie/chat.json',
                      repeat: false,
                      reverse: false,
                    ),
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
