// Flutter
import 'package:flutter/material.dart';
import 'dart:io';

// Utilities
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// Provider
import 'package:dogo_final_app/provider/form_provider.dart';

// Components
import 'package:dogo_final_app/components/input/input_rounded_text.dart';
import 'package:dogo_final_app/components/snackbar/snackbar_custom.dart';
import 'package:dogo_final_app/components/buttons/button_rounded_text.dart';

class CreateWalkUpdateView extends StatefulWidget {
  const CreateWalkUpdateView({super.key});

  @override
  State<CreateWalkUpdateView> createState() => _CreateWalkUpdateViewState();
}

class _CreateWalkUpdateViewState extends State<CreateWalkUpdateView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController warningController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  final picker = ImagePicker();

  List<String> options = [
    'Veuillez sélectionner une difficulté',
    'Facile',
    'Moyenne',
    'Difficile'
  ];

  String? selectedOption;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    selectedOption = options.first;
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    warningController.dispose();
    timeController.dispose();
  }

  void submitForm() async {
    if (formKey.currentState!.validate()) {
      if (selectedImage != null) {
        var formProvider = context.read<FormProvider>();
        formProvider.updateModel(
          name: nameController.text,
          description: descriptionController.text,
          warning: warningController.text,
          image: selectedImage,
          time: timeController.text,
          difficulty: selectedOption,
        );

        Navigator.of(context).pushNamed("/create-walk-update-map");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          snackbarCustom(
            message: "Veuillez remplir tous les champs.",
            backgroundColor: Colors.red[100],
            textColor: Colors.red[900],
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<File?> pickImage() async {
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 500,
      maxHeight: 400,
    );

    if (pickedImage != null) {
      return File(pickedImage.path);
    } else {
      return null;
    }
  }

  Future<File?> takePicture() async {
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 500,
      maxHeight: 400,
    );

    if (pickedImage != null) {
      return File(pickedImage.path);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          title: const Text("Ajouter une balade 🦮"),
          elevation: 0,
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: screenWidth * 0.85,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Une image
                  children: [
                    const SizedBox(height: 20),
                    const Text("Nom de la blade"),
                    const SizedBox(height: 6),
                    InputRoundedText(
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      validator: true,
                    ),
                    const SizedBox(height: 12),
                    const Text("Description"),
                    const SizedBox(height: 6),
                    InputRoundedText(
                      controller: descriptionController,
                      textInputAction: TextInputAction.next,
                      validator: true,
                      isTextarea: true,
                    ),
                    const SizedBox(height: 12),
                    const Text("Remarque sur le parcours"),
                    const SizedBox(height: 6),
                    InputRoundedText(
                      controller: warningController,
                      textInputAction: TextInputAction.next,
                      helperText: 'Exemple : Endroit très fréquenté',
                      validator: true,
                    ),
                    const SizedBox(height: 12),
                    const Text("Difficulté du parcours"),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: selectedOption,
                      onChanged: (newValue) {
                        setState(() {
                          selectedOption = newValue;
                        });
                      },
                      items:
                          options.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == options[0]) {
                          return 'Veuillez sélectionner une option';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 10),
                      ),
                      dropdownColor: Colors.grey[200],
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 2,
                    ),
                    const SizedBox(height: 12),
                    const Text("Durée moyenne en minutes"),
                    const SizedBox(height: 6),
                    InputRoundedText(
                      controller: timeController,
                      textInputAction: TextInputAction.next,
                      validator: true,
                      isNumeric: true,
                    ),
                    const SizedBox(height: 12),
                    const Text("Image de la balade"),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        elevation: 0.2,
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(double.infinity, 0),
                      ),
                      onPressed: () async {
                        File? image = await pickImage();
                        setState(() {
                          selectedImage = image;
                        });
                      },
                      child: const Text("Choisir dans la galerie 🏞️"),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        elevation: 0.2,
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(double.infinity, 0),
                      ),
                      onPressed: () async {
                        File? image = await takePicture();
                        setState(() {
                          selectedImage = image;
                        });
                      },
                      child: const Text("Prendre une photo 📸"),
                    ),
                    if (selectedImage != null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Aperçu de l'image"),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    ButtonRoundedText(
                      content: 'Valider et commencer la balade',
                      callback: submitForm,
                      backgroundColor: Colors.orange,
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
