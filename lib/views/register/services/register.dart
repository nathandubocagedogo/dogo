import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterService {
  Future<void> createAccount({
    required FirebaseFirestore firestore,
    required GlobalKey<FormState> formKey,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required BuildContext context,
  }) async {
    if (formKey.currentState!.validate()) {
      String nameValue = nameController.value.text;
      String emailValue = emailController.value.text;
      String passwordValue = passwordController.value.text;

      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailValue,
          password: passwordValue,
        );

        final user = credential.user;

        await user?.sendEmailVerification();

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
            errorMessage = "Une erreur est survenue.";
        }

        final SnackBar snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFF9E1DC),
          elevation: 0,
          duration: const Duration(seconds: 3),
          content: Text(
            errorMessage,
            style: const TextStyle(
              color: Color(0xFFD9110B),
              fontWeight: FontWeight.w500,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          closeIconColor: const Color(0xFFD9110B),
          showCloseIcon: true,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}
