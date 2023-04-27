import 'package:flutter/material.dart';
import 'package:dogo_final_app/components/buttons/button_rounded_text.dart';

class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  PageController pageController = PageController();
  int currentIndex = 0;
  String buttonText = 'Suivant';

  @override
  void initState() {
    super.initState();
    pageController.addListener(onPageChanged);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    pageController.removeListener(onPageChanged);
  }

  void onPageChanged() {
    setState(
      () {
        int previousIndex = currentIndex;
        double scrollThreshold = 50;
        currentIndex = pageController.page!.round();

        if (currentIndex == 2 &&
            previousIndex == 2 &&
            pageController.position.pixels >
                pageController.position.maxScrollExtent + scrollThreshold) {
          Navigator.pushNamed(context, '/home');
        } else {
          if (currentIndex == 2) {
            buttonText = 'Démarrer';
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
      body: Stack(
        children: [
          PageView(
            physics: const BouncingScrollPhysics(),
            controller: pageController,
            children: const [
              Center(child: Text('Explication de la fonctionnalité 1')),
              Center(child: Text('Explication de la fonctionnalité 2')),
              Center(child: Text('Explication de la fonctionnalité 3')),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: screenWidth * 0.85,
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
                            } else {
                              Navigator.pushNamed(context, '/home');
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
