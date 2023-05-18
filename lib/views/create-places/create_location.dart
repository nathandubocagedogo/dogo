// Flutter
import 'package:dogo_final_app/components/snackbar/snackbar_custom.dart';
import 'package:flutter/material.dart';
import 'dart:io';

// Provider
import 'package:dogo_final_app/provider/form_provider.dart';

// Utilities
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// Components
import 'package:dogo_final_app/components/input/input_rounded_text.dart';
import 'package:dogo_final_app/components/buttons/button_rounded_text.dart';

class CreateLocationView extends StatefulWidget {
  const CreateLocationView({super.key});

  @override
  State<CreateLocationView> createState() => _CreateLocationViewState();
}

class _CreateLocationViewState extends State<CreateLocationView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController warningController = TextEditingController();

  final picker = ImagePicker();

  File? selectedImage;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    warningController.dispose();
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
        );

        Navigator.of(context).pushNamed("/create-location-map");
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
      imageQuality: 80,
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
      imageQuality: 80,
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
          title: const Text("Ajouter un parc 🌳"),
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
                    const Text("Nom du parc"),
                    const SizedBox(height: 6),
                    InputRoundedText(
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      validator: true,
                    ),
                    const SizedBox(height: 12),
                    const Text("Description du parc"),
                    const SizedBox(height: 6),
                    InputRoundedText(
                      controller: descriptionController,
                      textInputAction: TextInputAction.next,
                      validator: true,
                      isTextarea: true,
                    ),
                    const SizedBox(height: 12),
                    const Text("Remarque sur le parc"),
                    const SizedBox(height: 6),
                    InputRoundedText(
                      controller: warningController,
                      textInputAction: TextInputAction.next,
                      helperText: 'Exemple : Beaucoup de boue en hiver',
                      validator: true,
                    ),
                    const SizedBox(height: 12),
                    const Text("Image du parc"),
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
                      content: 'Valider et choisir un point',
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
