import 'package:dogo_final_app/models/store/data.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dogo_final_app/views/login/services/session.dart';
import 'package:dogo_final_app/routes/animations.dart';
import 'package:dogo_final_app/components/bottombar/bottombar_custom.dart';
import 'package:dogo_final_app/models/store/provider.dart';
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
              DataModel dataModel = dataProvider.dataModel;
              return Scaffold(
                backgroundColor: Colors.white,
                body: ListView.builder(
                  itemCount: dataModel.data.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(dataModel.data[index]),
                  ),
                ),
              );
            },
          ),
          const Scaffold(
            backgroundColor: Colors.red,
          ),
          const Scaffold(
            backgroundColor: Colors.blue,
          ),
          const Scaffold(
            backgroundColor: Colors.yellow,
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
