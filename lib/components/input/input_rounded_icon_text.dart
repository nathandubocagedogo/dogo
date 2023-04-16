import 'package:flutter/material.dart';

class InputRoundedIconText extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final double iconSize;

  const InputRoundedIconText({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(
            10,
            0,
            0,
            0,
          ),
          child: Icon(
            icon,
            size: 18,
          ),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        contentPadding: const EdgeInsets.fromLTRB(
          20.0 + 40.0 + 10.0,
          16,
          20,
          16,
        ),
      ),
    );
  }
}
