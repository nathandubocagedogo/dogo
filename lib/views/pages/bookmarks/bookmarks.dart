// Flutter
import 'package:flutter/material.dart';

// Models
import 'package:dogo_final_app/models/firebase/place.dart';

// Services
import 'package:dogo_final_app/services/bookmarks.dart';

// Utilities
import 'package:firebase_auth/firebase_auth.dart';

class BookmarsPageView extends StatefulWidget {
  const BookmarsPageView({super.key});

  @override
  State<BookmarsPageView> createState() => _BookmarsPageViewState();
}

class _BookmarsPageViewState extends State<BookmarsPageView> {
  final BookmarksService bookmarksService = BookmarksService();

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: bookmarksService.getUserBookmarks(user!.uid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            List<Place> bookmarks = snapshot.data;
            return ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (BuildContext context, int index) {
                Place place = bookmarks[index];

                return ListTile(
                  title: Text(place.name),
                );
              },
            );
          }
        },
      ),
    );
  }
}
