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

  @override
  void initState() {
    super.initState();
    pageController.addListener(onPageChanged);
  }

  @override
  void dispose() {
    pageController.removeListener(onPageChanged);
    pageController.dispose();
    super.dispose();
  }

  void onPageChanged() {
    setState(() {
      currentIndex = pageController.page!.round();
    });
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
                        content: 'Suivant',
                        callback: () {
                          setState(
                            () {
                              if (currentIndex < 2) {
                                currentIndex++;
                                pageController.animateToPage(
                                  currentIndex,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              } else {
                                currentIndex = 0;
                                pageController.jumpToPage(currentIndex);
                              }
                            },
                          );
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
