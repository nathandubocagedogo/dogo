// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

// Utilities
import 'package:cloud_firestore/cloud_firestore.dart';

// Services
import 'package:dogo_final_app/services/register.dart';

// Components
import 'package:dogo_final_app/components/buttons/button_back.dart';
import 'package:dogo_final_app/components/buttons/button_rounded_text.dart';
import 'package:dogo_final_app/components/input/input_rounded_text.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RegisterService registerService = RegisterService();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> submitRegister() async {
    FocusScope.of(context).unfocus();

    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await registerService.createAccount(
        firestore: firestore,
        nameController: nameController,
        emailController: emailController,
        passwordController: passwordController,
        context: context,
      );
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const ButtonBack(),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: screenWidth * 0.90,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Inscription',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text("Quel est ton prénom ?"),
                    const SizedBox(height: 12),
                    InputRoundedText(
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      validator: true,
                    ),
                    const SizedBox(height: 12),
                    const Text("Quel est ton e-mail ?"),
                    const SizedBox(height: 12),
                    InputRoundedText(
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      helperText: 'Tu devras confirmer cet e-mail plus tard',
                      validator: true,
                    ),
                    const SizedBox(height: 12),
                    const Text("Créer un mot de passe ?"),
                    const SizedBox(height: 12),
                    InputRoundedText(
                      controller: passwordController,
                      textInputAction: TextInputAction.next,
                      obscureText: true,
                      helperText: 'Tu dois utiliser au moins 6 caractères',
                      validator: true,
                    ),
                    const SizedBox(height: 30),
                    ButtonRoundedText(
                      content: 'Créer un compte',
                      callback: submitRegister,
                      backgroundColor: Colors.orange,
                      textColor: Colors.white,
                      isActive: isLoading,
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: Colors.black54,
                        ),
                        children: [
                          const TextSpan(
                            text: 'En créant un compte, tu acceptes la ',
                            style: TextStyle(color: Colors.black54),
                          ),
                          TextSpan(
                            text: 'politique de confidentialité',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.pushNamed(
                                  context, '/privacy-policy'),
                          ),
                          const TextSpan(
                            text: ' de Dogo.',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
