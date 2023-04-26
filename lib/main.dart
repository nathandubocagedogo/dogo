// Flutter
import 'package:flutter/material.dart';
import 'package:dogo_final_app/theme/theme.dart';
import 'package:dogo_final_app/routes/routes.dart';
import 'dart:async';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dogo_final_app/firebase/firebase_options.dart';

// Utilities
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sqflite/sqflite.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: ".env");

  Database database = await openDatabase(
    'dogo.db',
    version: 1,
    onCreate: (database, version) async => {
      await database.execute(
        'CREATE TABLE preferences (id INTEGER PRIMARY KEY, type TEXT, value TEXT)',
      ),
      await database.insert('preferences', {'type': 'mode', 'value': 'light'}),
      await database.execute(
        'CREATE TABLE actions (id INTEGER PRIMARY KEY, isAlreadyComed INTEGER)',
      ),
      await database.insert('actions', {'isAlreadyComed': 0})
    },
  );
  database.close();

  runApp(const Dogo());
}

class Dogo extends StatefulWidget {
  const Dogo({super.key});

  @override
  State<Dogo> createState() => _DogoState();
}

class _DogoState extends State<Dogo> {
  final User? user = FirebaseAuth.instance.currentUser;

  Future<String> checkIfUserIsLoggedInAndReturnRoute() async {
    if (user == null) {
      return '/landing';
      // return '/welcome';
    } else {
      return '/home';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: checkIfUserIsLoggedInAndReturnRoute(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            initialRoute: snapshot.data,
            onGenerateRoute: generateRoute,
            theme: themeData,
            title: dotenv.get('APP_NAME'),
            debugShowCheckedModeBanner: false,
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
