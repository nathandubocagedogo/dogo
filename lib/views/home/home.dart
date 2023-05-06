// Flutter
import 'package:flutter/material.dart';
import 'package:dogo_final_app/routes/animations.dart';

// Provider
import 'package:dogo_final_app/provider/provider.dart';

// Components
import 'package:dogo_final_app/components/bottombar/bottombar_custom.dart';

// Utilities
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

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
  final PageController pageController = PageController(keepPage: true);

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeProvider();
    pageController.addListener(onPageChanged);
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
    }
  }

  void changePage(int index) {
    pageController.jumpToPage(
      index,
    );
  }

  Future<void> initializeProvider() async {
    await Future.wait([
      getCurrentLocation(),
      setFilter(),
    ]);
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

  Future<void> setFilter() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DataProvider>(context, listen: false).updateFilter("");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: const [
          HomePageView(key: PageStorageKey('homePage')),
          GroupsPageView(key: PageStorageKey('groupsPage')),
          BookmarsPageView(key: PageStorageKey('bookmarksPage')),
          SettingsPageView(key: PageStorageKey('settingsPage')),
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
