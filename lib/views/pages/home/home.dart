import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:dogo_final_app/provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        Position? currentPosition = dataProvider.dataModel.currentPosition;
        return Scaffold(
          backgroundColor: Colors.yellow,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 150,
                    color: Colors.red,
                  ),
                  Container(
                    height: 150,
                    color: Colors.blue,
                  ),
                  Container(
                    height: 150,
                    color: Colors.red,
                  ),
                  Container(
                    height: 150,
                    color: Colors.blue,
                  ),
                  Container(
                    height: 150,
                    color: Colors.red,
                  ),
                  Container(
                    height: 150,
                    color: Colors.blue,
                  ),
                  Container(
                    height: 150,
                    color: Colors.red,
                  ),
                  Container(
                    height: 150,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
