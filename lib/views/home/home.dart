import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogo_final_app/views/login/services/session.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  StreamSubscription<User?>? authSubscription;

  SessionService sessionService = SessionService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    sessionService.listenWhenUserIsLogged(
      firestore: firestore,
      authSubscription: authSubscription,
      context: context,
    );
  }

  @override
  void dispose() {
    super.dispose();
    authSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/welcome',
              (Route<dynamic> route) => false,
            );
          },
          child: const Text("Déconnexion"),
        ),
      ),
    );
  }
}
