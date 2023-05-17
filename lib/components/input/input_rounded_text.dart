// Flutter
import 'package:flutter/material.dart';

class InputRoundedText extends StatefulWidget {
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final bool obscureText;
  final String? helperText;
  final bool validator;
  final bool? isTextarea;

  const InputRoundedText({
    super.key,
    required this.controller,
    this.helperText,
    this.textInputAction = TextInputAction.none,
    this.obscureText = false,
    this.validator = false,
    this.isTextarea = false,
  });

  @override
  State<InputRoundedText> createState() => _InputRoundedTextState();
}

class _InputRoundedTextState extends State<InputRoundedText> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;
  }

  void toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: widget.isTextarea! ? 10 : 1,
      maxLines: widget.isTextarea! ? 20 : 1,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator
          ? (value) => value!.isEmpty ? 'Le champ est obligatoire.' : null
          : null,
      controller: widget.controller,
      obscureText: obscureText,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: toggleObscureText,
              )
            : null,
        helperText: widget.helperText,
      ),
    );
  }
}
