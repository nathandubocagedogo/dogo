// Flutter
import 'dart:io';

// Utilities
import 'package:firebase_storage/firebase_storage.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class StorageService {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadImage(File image) async {
    Reference storageReference =
        storage.ref().child("images/${path.basename(image.path)}");

    UploadTask uploadTask = storageReference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
