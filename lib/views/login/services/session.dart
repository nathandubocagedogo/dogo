import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class SessionService {
  Future<void> checkIfUserIsLogged({
    required FirebaseFirestore firestore,
    required StreamSubscription<User?>? authSubscription,
    required BuildContext context,
  }) async {
    authSubscription =
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

        authSubscription?.cancel();
        // Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }
}
