// Flutter
import 'package:flutter/material.dart';
import 'package:dogo_final_app/routes/routes.dart';
import 'package:dogo_final_app/theme/theme.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
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

  await openDatabase(
    'dogo.db',
    version: 1,
    onCreate: (database, version) async => {
      await database.execute(
        'CREATE TABLE preferences (id INTEGER PRIMARY KEY, type TEXT, value TEXT)',
      ),
      await database.insert('preferences', {'type': 'mode', 'value': 'light'})
    },
  );

  runApp(const Dogo());
}

class Dogo extends StatelessWidget {
  const Dogo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: routes,
      theme: themeData,
      title: dotenv.get('APP_NAME'),
      debugShowCheckedModeBanner: false,
    );
  }
}
