// Flutter
import 'package:flutter/material.dart';

class CreateLocationView extends StatefulWidget {
  const CreateLocationView({super.key});

  @override
  State<CreateLocationView> createState() => _CreateLocationViewState();
}

class _CreateLocationViewState extends State<CreateLocationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        title: const Text("Ajouter un parc 🌳"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: const Column(
        // Nom du parc
        // Description du parc
        // Alerte
        // Une image
        // Ville
        // L'adresse
        // Difficulté
        // Typlogie
        // Durée moyenne
        children: [],
      ),
    );
  }
}
