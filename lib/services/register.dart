// ignore_for_file: use_build_context_synchronously

// Flutter
import 'package:flutter/material.dart';

// Utilities
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Components
import 'package:dogo_final_app/components/snackbar/snackbar_custom.dart';

class RegisterService {
  Future<void> createAccount({
    required FirebaseFirestore firestore,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required BuildContext context,
  }) async {
    String nameValue = nameController.value.text;
    String emailValue = emailController.value.text;
    String passwordValue = passwordController.value.text;

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailValue,
        password: passwordValue,
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/welcome',
        (Route<dynamic> route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        snackbarCustom(
          message:
              "L'inscription a été effectuée avec succès. Vérifies ta boîte mail pour confirmer ton adresse e-mail.",
          backgroundColor: Colors.green[100],
          textColor: Colors.green[900],
          duration: const Duration(seconds: 3),
        ),
      );

      User? user = credential.user;
      await user?.sendEmailVerification();

      firestore.collection("users").doc(user?.uid).get().then((value) => {
            if (!value.exists)
              {
                firestore.collection("users").doc(user?.uid).set(
                  {
                    "name": nameValue,
                    "email": emailValue,
                    "picture": "",
                    "bookmarks": []
                  },
                )
              }
          });
    } on FirebaseAuthException catch (exception) {
      late String errorMessage;

      switch (exception.code) {
        case 'weak-password':
          errorMessage = "Le mot de passe est trop faible.";
          break;
        case 'email-already-in-use':
          errorMessage = "L'adresse e-mail est déjà utilisée.";
          break;
        default:
          errorMessage = "Le format de l'adresse e-mail est invalide.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        snackbarCustom(
          message: errorMessage,
          backgroundColor: Colors.red[100],
          textColor: Colors.red[900],
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
