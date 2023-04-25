import 'package:flutter/material.dart';

class ButtonRoundedText extends StatelessWidget {
  final double width;
  final String content;
  final VoidCallback callback;
  final Color backgroundColor;
  final Color textColor;
  final double elevation;
  final bool isEnabled;

  const ButtonRoundedText({
    super.key,
    this.width = double.infinity,
    required this.content,
    required this.callback,
    required this.backgroundColor,
    this.textColor = Colors.black,
    this.elevation = 0,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: isEnabled ? callback : null,
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(backgroundColor),
          elevation: MaterialStateProperty.all(0),
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
          style: TextStyle(
            fontWeight: FontWeight.w500,
            letterSpacing: 0.6,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
