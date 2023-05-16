// Flutter
import 'package:flutter/material.dart';

// Utilities
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Components
import 'package:dogo_final_app/components/snackbar/snackbar_custom.dart';

class AuthService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> signInBasically({
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required BuildContext context,
  }) async {
    String emailValue = emailController.value.text;
    String passwordValue = passwordController.value.text;

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailValue,
            password: passwordValue,
          )
          .then(
            (UserCredential user) => {
              Navigator.pushNamed(context, '/home'),
            },
          );
    } on FirebaseAuthException catch (exception) {
      late String errorMessage;

      switch (exception.code) {
        case 'user-not-found':
          errorMessage = "L'utilisateur ne semble pas exister.";
          break;
        case 'wrong-password':
          errorMessage = "Le mot de passe n'est pas correct.";
          break;
        case 'invalid-email':
          errorMessage = "Le format de l'adresse email n'est pas valide.";
          break;
        default:
          errorMessage = "Il est impossible de vous authentifier.";
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

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        User? user = userCredential.user;

        firestore.collection("users").doc(user?.uid).get().then((value) => {
              if (!value.exists)
                {
                  firestore.collection("users").doc(user?.uid).set(
                    {
                      "name": user?.displayName,
                      "email": user?.email,
                      "picture": user?.photoURL,
                    },
                  )
                }
            });

        return userCredential;
      } else {
        return null;
      }
    } catch (exception) {
      rethrow;
    }
  }

  Future<void> signInWithApple() async {}
}
