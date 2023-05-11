import 'package:flutter/material.dart';

class ButtonRoundedText extends StatefulWidget {
  final double width;
  final String content;
  final VoidCallback callback;
  final Color backgroundColor;
  final Color textColor;
  final double elevation;
  final bool isActive;
  final double spacing;

  const ButtonRoundedText(
      {super.key,
      this.width = double.infinity,
      required this.content,
      required this.callback,
      required this.backgroundColor,
      this.textColor = Colors.black,
      this.elevation = 0,
      this.isActive = false,
      this.spacing = 18});

  @override
  State<ButtonRoundedText> createState() => _ButtonRoundedTextState();
}

class _ButtonRoundedTextState extends State<ButtonRoundedText> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: ElevatedButton(
        onPressed: !widget.isActive ? widget.callback : null,
        style: ButtonStyle(
          backgroundColor: !widget.isActive
              ? MaterialStateProperty.all(widget.backgroundColor)
              : MaterialStateProperty.all(
                  widget.backgroundColor.withOpacity(0.5),
                ),
          elevation: MaterialStateProperty.all(widget.elevation),
          padding: MaterialStatePropertyAll(
            EdgeInsets.symmetric(
              vertical: widget.spacing,
            ),
          ),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
        child: Text(
          widget.content,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            letterSpacing: 0.6,
            color: widget.textColor,
          ),
        ),
      ),
    );
  }
}
