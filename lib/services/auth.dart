// Flutter
import 'package:flutter/material.dart';

// Utilities
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// Components
import 'package:dogo_final_app/components/snackbar/snackbar_custom.dart';

class AuthService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Connexion basique de l'utilisateur à Firebase puis redirection vers la page d'accueil
  Future<void> signInBasically({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
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
      displayErrors(exception, context);
    }
  }

  // Connexion de l'utilisateur à Firebase avec Google puis redirection vers la page d'accueil
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

        // Si je récupère un utilisateur, je vérifie s'il existe dans la collection "users" de Firestore
        // S'il n'existe pas, je l'ajoute
        await addUserToFirestore(user);

        return userCredential;
      } else {
        return null;
      }
    } catch (exception) {
      rethrow;
    }
  }

  // Connexion de l'utilisateur à Firebase avec Apple puis redirection vers la page d'accueil
  Future<UserCredential?> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      User? user = userCredential.user;

      // Si je récupère un utilisateur, je vérifie s'il existe dans la collection "users" de Firestore
      await addUserToFirestore(user);

      return userCredential;
    } catch (exception) {
      rethrow;
    }
  }

  Future<void> addUserToFirestore(User? user) async {
    firestore.collection("users").doc(user?.uid).get().then((value) => {
          if (!value.exists)
            {
              firestore.collection("users").doc(user?.uid).set(
                {
                  "name": user?.displayName ?? "Utilisateur inconnu",
                  "email": user?.email,
                  "picture": user?.photoURL,
                  "bookmarks": []
                },
              )
            }
        });
  }

  void displayErrors(FirebaseAuthException exception, BuildContext context) {
    late String errorMessage;

    switch (exception.code) {
      case 'user-not-found':
        errorMessage = "L'utilisateur ne semble pas exister.";
        break;
      case 'wrong-password':
        errorMessage = "Le mot de passe n'est pas correct.";
        break;
      case 'invalid-email':
        errorMessage = "Le format de l'adresse e-mail n'est pas valide.";
        break;
      default:
        errorMessage = "Il est impossible de t'authentifier.";
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
