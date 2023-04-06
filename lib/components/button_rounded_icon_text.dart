import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ButtonRoundedIconText extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback callback;

  const ButtonRoundedIconText({
    super.key,
    required this.text,
    required this.icon,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        padding: const MaterialStatePropertyAll(EdgeInsets.all(18)),
        backgroundColor: const MaterialStatePropertyAll(Colors.black),
      ),
      onPressed: callback,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 18),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.6,
            ),
          )
        ],
      ),
    );
  }
}
