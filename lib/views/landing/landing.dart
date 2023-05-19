// Flutter
import 'package:dogo_final_app/views/landing/landing_first.dart';
import 'package:dogo_final_app/views/landing/landing_second.dart';
import 'package:dogo_final_app/views/landing/landing_third.dart';
import 'package:flutter/material.dart';

// Components
import 'package:dogo_final_app/components/buttons/button_rounded_text.dart';
import 'package:dogo_final_app/components/buttons/button_back.dart';

// Utilities
import 'package:firebase_auth/firebase_auth.dart';

class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  // Utilisation d'un PageController pour gérer les trois pages et les défilements
  PageController pageController = PageController();

  User? user = FirebaseAuth.instance.currentUser;

  int currentIndex = 0;
  String buttonText = 'Suivant';
  bool popCalled = false;

  @override
  void initState() {
    super.initState();
    pageController.addListener(onPageChanged);
  }

  @override
  void dispose() {
    pageController.dispose();
    pageController.removeListener(onPageChanged);
    super.dispose();
  }

  void onPageChanged() {
    setState(
      () {
        int previousIndex = currentIndex;
        double scrollThreshold = 50;
        currentIndex = pageController.page!.round();

        // Si je mets swipe vers la droite à la dernière page, on va sur la page d'accueil de l'application mais il faut être connecté
        if (currentIndex == 2 &&
            previousIndex == 2 &&
            pageController.position.pixels >
                pageController.position.maxScrollExtent + scrollThreshold) {
          if (user != null) {
            Navigator.pushNamed(context, '/home');
          }
        } else {
          if (currentIndex == 2 && user != null) {
            buttonText = 'Démarrer';
          } else if (currentIndex == 2 && user == null) {
            buttonText = 'Connexion';
          } else {
            buttonText = 'Suivant';
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const ButtonBack(),
      ),
      body: Stack(
        children: [
          PageView(
            physics: const BouncingScrollPhysics(),
            controller: pageController,
            children: const [
              LandingFirst(),
              LandingSecond(),
              LandingThird(),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: screenWidth * 0.9,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: CircleAvatar(
                              radius: 5,
                              backgroundColor: index == currentIndex
                                  ? Colors.orange
                                  : Colors.grey,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                      ButtonRoundedText(
                        content: buttonText,
                        callback: () {
                          setState(() {
                            if (currentIndex < 1) {
                              currentIndex++;
                              buttonText = 'Suivant';
                            } else if (currentIndex == 1) {
                              currentIndex++;
                              buttonText = 'Démarrer';
                            } else if (user != null) {
                              Navigator.pushNamed(context, '/home');
                            } else {
                              Navigator.pushNamed(context, '/login-home');
                            }
                            pageController.animateToPage(
                              currentIndex,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          });
                        },
                        backgroundColor: Colors.orange,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
