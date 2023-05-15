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
        title: const Text("Créer un emplacement"),
        leading: const BackButton(),
      ),
    );
  }
}
