// Flutter
import 'package:flutter/material.dart';

// Utilities
import 'package:lottie/lottie.dart';

class LandingFirst extends StatelessWidget {
  const LandingFirst({super.key});

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
                  'Qu\'est-ce que Dogo ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Dogo est une application qui vous permet de de trouver des lieux dog-friendly autour de vous comme des balades ou des parcs.',
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
                      'assets/lottie/smartphone.json',
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
