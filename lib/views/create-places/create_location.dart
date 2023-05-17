// Flutter
import 'package:flutter/material.dart';

// Components
import 'package:dogo_final_app/components/input/input_rounded_text.dart';

class CreateLocationView extends StatefulWidget {
  const CreateLocationView({super.key});

  @override
  State<CreateLocationView> createState() => _CreateLocationViewState();
}

class _CreateLocationViewState extends State<CreateLocationView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController warningController = TextEditingController();
  final TextEditingController difficultyController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    warningController.dispose();
    difficultyController.dispose();
    typeController.dispose();
    timeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: screenWidth * 0.85,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Nom du parc
                // Description du parc
                // Alerte
                // Une image
                // Difficulté
                // Typlogie
                // Durée moyenne
                children: [
                  const SizedBox(height: 20),
                  const Text("Nom du parc"),
                  const SizedBox(height: 6),
                  InputRoundedText(
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    validator: true,
                  ),
                  const SizedBox(height: 12),
                  const Text("Description du parc"),
                  const SizedBox(height: 6),
                  InputRoundedText(
                    controller: descriptionController,
                    textInputAction: TextInputAction.next,
                    validator: true,
                    isTextarea: true,
                  ),
                  const SizedBox(height: 12),
                  const Text("Remarque sur le parc"),
                  const SizedBox(height: 6),
                  InputRoundedText(
                    controller: warningController,
                    textInputAction: TextInputAction.next,
                    helperText: 'Exemple : Beaucoup de boue en hiver',
                    validator: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
