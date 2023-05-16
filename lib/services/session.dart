// Flutter
import 'package:flutter/material.dart';
import 'dart:async';

// Utilities
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SessionService {
  Future<void> listenWhenUserIsLogged({
    required FirebaseFirestore firestore,
    required StreamSubscription<User?>? authSubscription,
    required BuildContext context,
  }) async {
    authSubscription = FirebaseAuth.instance.authStateChanges().listen(
      (User? user) {
        if (user != null) {}
      },
    );
  }
}
