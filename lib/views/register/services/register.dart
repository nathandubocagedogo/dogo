// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

      Navigator.pushNamed(context, '/login');

      ScaffoldMessenger.of(context).showSnackBar(
        snackbarCustom(
          message:
              "L'inscription a été effectuée avec succès. Veuillez vérifier votre boîte mail pour confirmer votre adresse email.",
          backgroundColor: Colors.green[100],
          textColor: Colors.green[900],
          duration: const Duration(seconds: 3),
        ),
      );

      User? user = credential.user;
      await user?.sendEmailVerification();
      FirebaseAuth.instance.signOut();

      firestore.collection("users").doc(user?.uid).get().then((value) => {
            if (!value.exists)
              {
                firestore.collection("users").doc(user?.uid).set(
                  {
                    "name": nameValue,
                    "email": emailValue,
                    "picture": "",
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
          errorMessage = "L'adresse email est déjà utilisée.";
          break;
        default:
          errorMessage = "Le format de l'adresse email est invalide.";
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
