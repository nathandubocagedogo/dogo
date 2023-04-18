import 'package:dogo_final_app/components/buttons/button_rounded_text.dart';
import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: screenWidth * 0.85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bienvenue sur Dogo !',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Explorez les meilleurs itinéraires de promenade pour votre compagnon à quatre pattes avec notre application mobile, et partagez vos découvertes avec une communauté de passionnés de chiens !',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              const SizedBox(height: 16),
              ButtonRoundedText(
                width: double.infinity,
                content: 'Commencer',
                callback: () {
                  Navigator.pushNamed(context, '/home');
                },
                backgroundColor: Colors.orange,
                textColor: Colors.white,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
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
