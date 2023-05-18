// Flutter
import 'package:flutter/material.dart';
import 'dart:io';

// Components
import 'package:dogo_final_app/components/buttons/button_rounded_text.dart';
import 'package:dogo_final_app/components/input/input_rounded_text.dart';
import 'package:dogo_final_app/components/snackbar/snackbar_custom.dart';

// Services
import 'package:dogo_final_app/services/group.dart';

// Utilities
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

class GroupCreateView extends StatefulWidget {
  const GroupCreateView({super.key});

  @override
  State<GroupCreateView> createState() => _GroupCreateViewState();
}

class _GroupCreateViewState extends State<GroupCreateView> {
  final GroupService groupService = GroupService();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController privacyController = TextEditingController();

  final User? user = FirebaseAuth.instance.currentUser;
  final ImagePicker picker = ImagePicker();

  ValueNotifier<bool> isCreating = ValueNotifier<bool>(false);
  FirebaseStorage storage = FirebaseStorage.instance;
  CollectionReference places = FirebaseFirestore.instance.collection('groups');
  File? selectedImage;
  List<String> privacyOptions = ['Public', 'Privé'];
  String? selectedPrivacy = 'Public';

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    privacyController.dispose();
  }

  void submitForm() async {
    if (formKey.currentState!.validate()) {
      if (selectedImage != null) {
        isCreating.value = true;
        String pictureUrl = await uploadImage(selectedImage!);
        await groupService.createGroup(
          nameController.text,
          descriptionController.text,
          selectedPrivacy! == 'Private' ? true : false,
          pictureUrl,
          user!.uid,
        );

        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        isCreating.value = false;
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

  Future<String> uploadImage(File image) async {
    Reference storageReference =
        storage.ref().child("images/${path.basename(image.path)}");

    UploadTask uploadTask = storageReference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
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
          title: const Text("Ajouter un groupe 🐶"),
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
                    const Text("Nom du groupe"),
                    const SizedBox(height: 6),
                    InputRoundedText(
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      validator: true,
                    ),
                    const SizedBox(height: 12),
                    const Text("Description du groupe"),
                    const SizedBox(height: 6),
                    InputRoundedText(
                      controller: descriptionController,
                      textInputAction: TextInputAction.next,
                      validator: true,
                      isTextarea: true,
                    ),
                    const SizedBox(height: 12),
                    const Text("Confidentialité du groupe"),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: selectedPrivacy,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPrivacy = newValue;
                        });
                      },
                      items: privacyOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
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
                    ValueListenableBuilder<bool>(
                      valueListenable: isCreating,
                      builder: (context, isCreating, child) {
                        if (isCreating) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.orange),
                                elevation: MaterialStateProperty.all(0),
                                padding: const MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(vertical: 18),
                                ),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),
                              child: const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }
                        return ButtonRoundedText(
                          content: 'Créer le groupe',
                          callback: submitForm,
                          backgroundColor: Colors.orange,
                          textColor: Colors.white,
                        );
                      },
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
