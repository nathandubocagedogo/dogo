// Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

// Components
import 'package:dogo_final_app/components/buttons/button_rounded_text.dart';
import 'package:dogo_final_app/components/input/input_rounded_text.dart';

// Utilities
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogo_final_app/services/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Utils
import 'package:dogo_final_app/utils/manipulate_string.dart';

class SettingsPageView extends StatefulWidget {
  const SettingsPageView({super.key});

  @override
  State<SettingsPageView> createState() => _SettingsPageViewState();
}

class _SettingsPageViewState extends State<SettingsPageView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  final StorageService storageService = StorageService();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  final TextEditingController nameController = TextEditingController();

  late Stream<DocumentSnapshot<Map<String, dynamic>>> userData;

  @override
  void initState() {
    super.initState();
    userData = getUserData();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserData() {
    return firestore.collection("users").doc(user?.uid).snapshots();
  }

  Future<void> pickImage() async {
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedImage != null) {
      File image = File(pickedImage.path);
      String pictureUrl = await storageService.uploadImage(image);
      firestore.collection("users").doc(user?.uid).update({
        "picture": pictureUrl,
      });
    }
  }

  Future<void> updateUserName(String newName) async {
    if (user != null && formKey.currentState!.validate()) {
      formKey.currentState!.reset();
      nameController.clear();
      await firestore.collection('users').doc(user?.uid).update({
        'name': newName,
      });
    }
  }

  Future<void> deleteUserAccount() async {
    if (user != null) {
      await FirebaseAuth.instance.signOut();
      await user?.delete();
      await firestore.collection('users').doc(user?.uid).delete();
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profil utilisateur'),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: screenWidth * 0.9,
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: userData,
            builder: (
              BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                final Map<String, dynamic>? user = snapshot.data?.data();
                final String name = convertFullNameInFirstName(
                  name: snapshot.data?.data()?['name'],
                );
                final String? picture = snapshot.data?.data()?['picture'];
                final String firstLetter =
                    name.isNotEmpty ? name[0].toUpperCase() : "";

                return Column(
                  children: [
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: pickImage,
                      customBorder: const CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 50,
                        child: picture != null && picture.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  picture,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Text(
                                firstLetter,
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?['name'] ?? "Inconnu",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      user?['email'] ?? "Inconnu",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Modifier le nom complet",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          InputRoundedText(
                            controller: nameController,
                            validator: true,
                          ),
                          const SizedBox(height: 12),
                          ButtonRoundedText(
                            backgroundColor: Colors.orange,
                            textColor: Colors.white,
                            content: "Sauvegarder",
                            callback: () {
                              updateUserName(nameController.text);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Actions sur le compte",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    CupertinoListTile(
                      backgroundColor: Colors.grey[200],
                      title: const Text('Déconnexion'),
                      trailing: const Icon(Icons.logout),
                      onTap: () async {
                        await signOut();
                      },
                    ),
                    const Divider(height: 0.1),
                    CupertinoListTile(
                      backgroundColor: Colors.grey[200],
                      title: const Text('Supprimer le compte'),
                      trailing: const Icon(Icons.delete),
                      onTap: () async {
                        await deleteUserAccount();
                      },
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
