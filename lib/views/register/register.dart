// Firebase
import 'package:cloud_firestore/cloud_firestore.dart';

// Services
import 'package:dogo_final_app/views/register/services/register.dart';

// Components
import 'package:dogo_final_app/components/buttons/button_rounded_text.dart';
import 'package:dogo_final_app/components/input/input_rounded_text.dart';

// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RegisterService registerService = RegisterService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: screenWidth * 0.85,
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
                    const Text("Quel est votre prénom ?"),
                    const SizedBox(height: 12),
                    InputRoundedText(
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      validator: true,
                    ),
                    const SizedBox(height: 12),
                    const Text("Quel est votre email ?"),
                    const SizedBox(height: 12),
                    InputRoundedText(
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      helperText: 'Vous devrez confirmer cet email plus tard.',
                      validator: true,
                    ),
                    const SizedBox(height: 12),
                    const Text("Crée un mot de passe ?"),
                    const SizedBox(height: 12),
                    InputRoundedText(
                      controller: passwordController,
                      textInputAction: TextInputAction.next,
                      obscureText: true,
                      helperText: 'Vous devez utilisez au moins 6 caractères',
                      validator: true,
                    ),
                    const SizedBox(height: 30),
                    ButtonRoundedText(
                      content: 'Crée un compte',
                      callback: () async {
                        await registerService.createAccount(
                          firestore: firestore,
                          formKey: formKey,
                          nameController: nameController,
                          emailController: emailController,
                          passwordController: passwordController,
                          context: context,
                        );
                      },
                      backgroundColor: Colors.orange,
                      textColor: Colors.white,
                      enabledMode: true,
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
                              ..onTap = () {
                                Navigator.pushNamed(context, '/privacy-policy');
                              },
                          ),
                          const TextSpan(
                            text: ' et les ',
                            style: TextStyle(color: Colors.black54),
                          ),
                          TextSpan(
                            text: 'conditions d\'utilisation',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, '/terms');
                              },
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
