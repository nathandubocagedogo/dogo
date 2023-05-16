// Flutter
import 'package:flutter/material.dart';

class ResultsHeadingWidget extends StatelessWidget {
  const ResultsHeadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: screenWidth * 0.9,
        child: const Text(
          "Résultats trouvés",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
