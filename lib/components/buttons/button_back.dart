import 'package:flutter/material.dart';

class ButtonBack extends StatefulWidget {
  final IconData icon;

  const ButtonBack({
    super.key,
    this.icon = Icons.arrow_back_ios_new_outlined,
  });

  @override
  State<ButtonBack> createState() => _ButtonBackState();
}

class _ButtonBackState extends State<ButtonBack> {
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: IconButton(
          icon: Icon(
            widget.icon,
          ),
          onPressed: () => Navigator.pop(context),
        ));
  }
}
