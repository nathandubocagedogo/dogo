import 'package:flutter/material.dart';

SnackBar snackbarCustom({
  required String message,
  Color? backgroundColor = Colors.blue,
  Color? textColor = Colors.white,
  Duration duration = const Duration(seconds: 4),
}) {
  return SnackBar(
    content: Text(
      message,
      style: TextStyle(
        color: textColor,
      ),
    ),
    backgroundColor: backgroundColor,
    duration: duration,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    closeIconColor: textColor,
    showCloseIcon: true,
    behavior: SnackBarBehavior.floating,
  );
}
