import 'package:dogo_final_app/components/snackbar/snackbar_custom.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordService {
  Future<void> resetPassword({
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required BuildContext context,
  }) async {
    if (formKey.currentState!.validate()) {
      String emailValue = emailController.value.text;

      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(
              email: emailValue,
            )
            .then(
              (_) => {
                ScaffoldMessenger.of(context).showSnackBar(
                  snackbarCustom(
                    message:
                        "Un email de réinitialisation de mot de passe a été envoyé à $emailValue.",
                    backgroundColor: Colors.green[100],
                    textColor: Colors.green[900],
                    duration: const Duration(seconds: 3),
                  ),
                ),
                Navigator.pushNamed(context, '/login')
              },
            );
      } on FirebaseException catch (exception) {
        late String errorMessage;

        switch (exception.code) {
          case 'weak-password':
            errorMessage = "Le mot de passe est trop faible.";
            break;
          case 'email-already-in-use':
            errorMessage = "L'adresse email est déjà utilisée.";
            break;
          case 'invalid-email':
            errorMessage = "Le format de l'adresse email est invalide.";
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
}
