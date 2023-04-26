// Components
import 'package:dogo_final_app/components/buttons/button_rounded_text.dart';

// Routes
import 'package:dogo_final_app/routes/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Flutter
import 'package:flutter/material.dart';

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
      body: Center(
        child: SizedBox(
          width: screenWidth * 0.85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bienvenue sur Dogo !',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Explorez les meilleurs itinéraires de promenade pour votre compagnon à quatre pattes avec notre application mobile, et partagez vos découvertes avec une communauté de passionnés de chiens !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.2,
                  color: Colors.black54,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 20),
              ButtonRoundedText(
                content: 'Commencer',
                callback: () => Navigator.pushNamed(context, '/landing'),
                backgroundColor: Colors.orange,
                textColor: Colors.white,
              ),
              if (user == null)
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/login-home',
                      arguments: {
                        'animationType': AnimationType.slideBottom,
                      },
                    );
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Text('Connexion'),
                )
            ],
          ),
        ),
      ),
    );
  }
}
