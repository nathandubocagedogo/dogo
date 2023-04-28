import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:logger/logger.dart';

class SessionService {
  Future<void> listenWhenUserIsLogged({
    required FirebaseFirestore firestore,
    required StreamSubscription<User?>? authSubscription,
    required BuildContext context,
  }) async {
    Logger logger = Logger();

    authSubscription = FirebaseAuth.instance.authStateChanges().listen(
      (User? user) {
        if (user != null) {
          // logger.v(user);
        } else {
          // logger.v("User is not logged in");
        }
      },
    );
  }
}
