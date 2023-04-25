import 'package:dogo_final_app/components/snackbar/snackbar_custom.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordService {
  Future<void> resetPassword({
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required BuildContext context,
  }) async {
    String emailValue = emailController.value.text;

    try {
      if (emailValue.isNotEmpty) {
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
      } else {
        String errorMessage = "Veuillez saisir une adresse email.";

        ScaffoldMessenger.of(context).showSnackBar(
          snackbarCustom(
            message: errorMessage,
            backgroundColor: Colors.red[100],
            textColor: Colors.red[900],
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (exception) {}
  }
}
