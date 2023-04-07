import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ButtonRoundedIconText extends StatelessWidget {
  final String content;
  final IconData icon;
  final double iconSize;
  final double gap;
  final VoidCallback callback;

  const ButtonRoundedIconText({
    super.key,
    required this.content,
    required this.icon,
    required this.iconSize,
    required this.callback,
    required this.gap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback,
      style: ButtonStyle(
        backgroundColor: const MaterialStatePropertyAll(Colors.black),
        padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(
          vertical: 18,
        )),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: Colors.white,
          ),
          SizedBox(width: gap),
          Text(
            content,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: 0.6,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
