import 'package:dogo_final_app/components/bottombar/bottombar_custom.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dogo_final_app/views/login/services/session.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<Widget> pages = [
    const Center(child: Text('Page 1')),
    const Center(child: Text('Page 2')),
    const Center(child: Text('Page 3')),
    const Center(child: Text('Page 4')),
  ];

  StreamSubscription<User?>? authSubscription;

  SessionService sessionService = SessionService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    sessionService.listenWhenUserIsLogged(
      firestore: firestore,
      authSubscription: authSubscription,
      context: context,
    );
  }

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    authSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Dogo"),
        automaticallyImplyLeading: false,
      ),
      body: pages[currentIndex],
      bottomNavigationBar:
          CustomBottomAppBar(onTap: onTap, currentIndex: currentIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.orange,
        elevation: 2,
        child: const Icon(Icons.add),
      ),
    );
  }
}
