import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dogo_final_app/views/login/services/session.dart';
import 'package:dogo_final_app/routes/animations.dart';
import 'package:dogo_final_app/components/bottombar/bottombar_custom.dart';
import 'package:dogo_final_app/models/store/provider.dart';
import 'package:dogo_final_app/models/store/data.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  StreamSubscription<User?>? authSubscription;

  SessionService sessionService = SessionService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  PageController pageController = PageController();

  List<bool> pagesLoaded = [false, false, false, false];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    sessionService.listenWhenUserIsLogged(
      firestore: firestore,
      authSubscription: authSubscription,
      context: context,
    );
    pageController.addListener(onPageChanged);
    loadDataForPage(0);
  }

  @override
  void dispose() {
    super.dispose();
    authSubscription?.cancel();
    pageController.dispose();
    pageController.removeListener(onPageChanged);
  }

  void onPageChanged() {
    int pageIndex = pageController.page!.round();

    if (currentIndex != pageIndex) {
      setState(() {
        currentIndex = pageIndex;
      });
      loadDataForPage(currentIndex);
    }
  }

  void loadDataForPage(int pageIndex) async {
    if (!pagesLoaded[pageIndex]) {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      await dataProvider.fetchData(pageIndex);
      pagesLoaded[pageIndex] = true;
    }
  }

  void onTap(int index) {
    pageController.jumpToPage(
      index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
          Consumer<DataProvider>(
            builder: (context, dataProvider, child) {
              return const Scaffold(
                backgroundColor: Colors.green,
              );
            },
          ),
          const Scaffold(
            backgroundColor: Colors.red,
          ),
          const Scaffold(
            backgroundColor: Colors.blue,
          ),
          Consumer<DataProvider>(
            builder: (context, dataProvider, child) {
              return Scaffold(
                backgroundColor: Colors.yellow,
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: const Text("Déconnexion"),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar:
          CustomBottomAppBar(onTap: onTap, currentIndex: currentIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          '/map',
          arguments: {
            'animationType': AnimationType.slideBottom,
          },
        ),
        backgroundColor: Colors.orange,
        elevation: 2,
        child: const Icon(
          Icons.map,
          color: Colors.white,
        ),
      ),
    );
  }
}
