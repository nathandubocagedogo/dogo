// Flutter
import 'dart:io';
import 'package:flutter/material.dart';

class FormProvider with ChangeNotifier {
  String? name;
  String? description;
  String? warning;
  File? image;
  String? time;
  String? difficulty;

  void updateModel(
      {String? name,
      String? description,
      String? warning,
      File? image,
      String? time,
      String? difficulty}) {
    this.name = name;
    this.description = description;
    this.warning = warning;
    this.image = image;
    this.time = time;
    this.difficulty = difficulty;
    notifyListeners();
  }
}
