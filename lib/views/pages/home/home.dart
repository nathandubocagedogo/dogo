import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dogo_final_app/provider/provider.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        return const Scaffold(
          backgroundColor: Colors.green,
        );
      },
    );
  }
}
