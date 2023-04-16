import 'package:flutter/material.dart';

class ButtonRoundedText extends StatelessWidget {
  final String content;
  final VoidCallback callback;
  final Color color;

  const ButtonRoundedText({
    super.key,
    required this.content,
    required this.callback,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback,
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(color),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(
            vertical: 18,
          ),
        ),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
      child: Text(
        content,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.6,
          color: Colors.white,
        ),
      ),
    );
  }
}
