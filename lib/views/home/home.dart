// Flutter
import 'package:flutter/material.dart';
import 'package:dogo_final_app/routes/animations.dart';
import 'dart:async';

// Utilities
import 'package:geolocator/geolocator.dart';

// Components
import 'package:dogo_final_app/components/bottombar/bottombar_custom.dart';

// Provider
import 'package:dogo_final_app/provider/provider.dart';
import 'package:provider/provider.dart';

// Pages
import 'package:dogo_final_app/views/pages/bookmarks/bookmarks.dart';
import 'package:dogo_final_app/views/pages/home/home.dart';
import 'package:dogo_final_app/views/pages/settings/settings.dart';
import 'package:dogo_final_app/views/pages/groups/groups.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController pageController = PageController();

  List<bool> pagesLoaded = [false, false, false, false];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController.addListener(onPageChanged);
    getCurrentLocation();
    // loadDataForPage(0);
  }

  @override
  void dispose() {
    super.dispose();
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
    // if (!pagesLoaded[pageIndex]) {
    //   final dataProvider = Provider.of<DataProvider>(context, listen: false);
    //   await dataProvider.fetchData(pageIndex);
    //   pagesLoaded[pageIndex] = true;
    // }
  }

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception("Location permission denied");
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        Provider.of<DataProvider>(context, listen: false)
            .updateCurrentPosition(position);
      }
    } catch (exception) {
      rethrow;
    }
  }

  void changePage(int index) {
    pageController.jumpToPage(
      index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: const [
          HomePageView(),
          GroupsPageView(),
          BookmarsPageView(),
          SettingsPageView(),
        ],
      ),
      bottomNavigationBar:
          CustomBottomAppBar(onTap: changePage, currentIndex: currentIndex),
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
