// Flutter
import 'dart:io';
import 'package:flutter/material.dart';

class FormProvider with ChangeNotifier {
  String? name;
  String? description;
  String? warning;
  File? image;

  void updateModel({
    String? name,
    String? description,
    String? warning,
    File? image,
  }) {
    this.name = name;
    this.description = description;
    this.warning = warning;
    this.image = image;
    notifyListeners();
  }
}
