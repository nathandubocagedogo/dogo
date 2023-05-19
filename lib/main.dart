// Flutter
import 'package:flutter/material.dart';
import 'package:dogo_final_app/theme/theme.dart';
import 'package:dogo_final_app/routes/routes.dart';
import 'dart:async';

// Settings
import 'package:dogo_final_app/firebase/firebase_options.dart';

// Services
import 'package:dogo_final_app/services/places.dart';

// Utilities
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

// Provider
import 'package:dogo_final_app/provider/provider.dart';
import 'package:dogo_final_app/provider/form_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FormProvider(),
        ),
        Provider<PlacesService>(
          create: (_) => PlacesService(),
        ),
      ],
      child: const Dogo(),
    ),
  );
}

class Dogo extends StatefulWidget {
  const Dogo({super.key});

  @override
  State<Dogo> createState() => _DogoState();
}

class _DogoState extends State<Dogo> {
  final User? user = FirebaseAuth.instance.currentUser;

  Future<String> checkIfUserIsLoggedInAndReturnRoute() async {
    return user == null ? '/welcome' : '/home';
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
