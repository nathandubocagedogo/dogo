// Firebase
import 'package:dogo_final_app/components/button_rounded_icon_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Service
import 'package:dogo_final_app/views/login/services/auth.dart';

// Flutter
import 'package:flutter/material.dart';
import 'dart:async';

// Utilities
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  StreamSubscription<User?>? _authSubscription;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    checkIfUserIsLogged();
  }

  @override
  void dispose() {
    super.dispose();
    _authSubscription?.cancel();
  }

  Future<void> checkIfUserIsLogged() async {
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        firestore.collection("users").doc(user.uid).get().then((value) => {
              if (!value.exists)
                {
                  firestore.collection("users").doc(user.uid).set(
                    {
                      "name": user.displayName,
                      "email": user.email,
                      "picture": user.photoURL,
                    },
                  )
                }
            });

        _authSubscription?.cancel();
        // Navigator.pushReplacementNamed(context, '/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Connexion',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: ButtonRoundedIconText(
                text: "Connexion avec Google",
                icon: FontAwesomeIcons.google,
                callback: signInWithGoogle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
