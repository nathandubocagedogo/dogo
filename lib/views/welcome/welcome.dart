// Flutter
import 'package:flutter/material.dart';
import 'package:dogo_final_app/routes/animations.dart';

// Components
import 'package:dogo_final_app/components/buttons/button_rounded_text.dart';

// Utilities
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  User? user = FirebaseAuth.instance.currentUser;

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
                const SizedBox(height: 50),
                const Text(
                  'Bienvenue sur Dogo !',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Explore les meilleurs itinéraires de promenade pour ton compagnon à quatre pattes et partage tes découvertes avec la communauté !',
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
                      'assets/lottie/welcome.json',
                      repeat: false,
                      reverse: false,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ButtonRoundedText(
                  content: 'Commencer',
                  callback: () => Navigator.pushNamed(
                    context,
                    '/landing',
                    arguments: {
                      'animationType': AnimationType.slideLeft,
                    },
                  ),
                  backgroundColor: Colors.orange,
                  textColor: Colors.white,
                ),
                if (user == null)
                  TextButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/login-home',
                      arguments: {
                        'animationType': AnimationType.slideBottom,
                      },
                    ),
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: const Text('Connexion'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
