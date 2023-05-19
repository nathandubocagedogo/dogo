// Utilities
import 'package:cloud_firestore/cloud_firestore.dart';

// Models
import 'package:dogo_final_app/models/firebase/place.dart';

class BookmarksService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Récupération des favoris de l'utilisateur connecté
  Future<List<Place>> getUserBookmarks(String userId) async {
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(userId).get();
    List<dynamic> bookmarksIds = userDoc.get('bookmarks');

    List<Place> bookmarks = [];
    for (var id in bookmarksIds) {
      DocumentSnapshot placeDoc =
          await firestore.collection('places').doc(id).get();
      bookmarks.add(Place.fromDocument(placeDoc));
    }

    return bookmarks;
  }
}
