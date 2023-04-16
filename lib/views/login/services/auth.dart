import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<void> signInBasically({
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required BuildContext context,
  }) async {
    String emailValue = emailController.value.text;
    String passwordValue = passwordController.value.text;

    formKey.currentState!.validate();
    formKey.currentState!.save();

    try {
      if (formKey.currentState!.validate()) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailValue,
          password: passwordValue,
        );
      }
    } on FirebaseAuthException catch (exception) {
      late String errorMessage;

      switch (exception.code) {
        case 'user-not-found':
          errorMessage = "L'utilisateur ne semble pas exister.";
          break;
        case 'wrong-password':
          errorMessage = "Le mot de passe n'est pas correct.";
          break;
        default:
          errorMessage = "Impossible de vous authentifier.";
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

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        return null;
      }
    } catch (exception) {
      rethrow;
    }
  }

  Future<void> signInWithApple() async {}
}
