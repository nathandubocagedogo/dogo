import 'package:flutter/material.dart';

class ButtonRoundedText extends StatefulWidget {
  final double width;
  final String content;
  final VoidCallback callback;
  final Color backgroundColor;
  final Color textColor;
  final double elevation;
  final bool enabledMode;

  const ButtonRoundedText({
    super.key,
    this.width = double.infinity,
    required this.content,
    required this.callback,
    required this.backgroundColor,
    this.textColor = Colors.black,
    this.elevation = 0,
    this.enabledMode = false,
  });

  @override
  State<ButtonRoundedText> createState() => _ButtonRoundedTextState();
}

class _ButtonRoundedTextState extends State<ButtonRoundedText> {
  bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: ElevatedButton(
        onPressed: isEnabled
            ? () async {
                if (!widget.enabledMode) {
                  widget.callback();
                } else {
                  widget.callback();
                  setState(() {
                    isEnabled = false;
                  });
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() {
                    isEnabled = true;
                  });
                }
              }
            : null,
        style: ButtonStyle(
          backgroundColor: isEnabled
              ? MaterialStatePropertyAll(widget.backgroundColor)
              : MaterialStatePropertyAll(
                  widget.backgroundColor.withOpacity(0.5),
                ),
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
