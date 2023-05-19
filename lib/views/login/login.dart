// Flutter
import 'package:flutter/material.dart';
import 'package:dogo_final_app/theme/theme.dart';

// Services
import 'package:dogo_final_app/services/auth.dart';

// Components
import 'package:dogo_final_app/components/buttons/button_back.dart';
import 'package:dogo_final_app/components/input/input_rounded_text.dart';
import 'package:dogo_final_app/components/buttons/button_rounded_text.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService authService = AuthService();

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> submitLogin() async {
    // On vient enlever le focus du clavier
    FocusScope.of(context).unfocus();

    // Vérification des champs et connexion basique
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authService.signInBasically(
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
              child: Column(
                children: [
                  const Text(
                    'Connexion',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text("E-mail"),
                        const SizedBox(height: 12),
                        InputRoundedText(
                          controller: emailController,
                          textInputAction: TextInputAction.next,
                          validator: true,
                        ),
                        const SizedBox(height: 30),
                        const Text("Mot de passe"),
                        const SizedBox(height: 12),
                        InputRoundedText(
                          controller: passwordController,
                          textInputAction: TextInputAction.next,
                          obscureText: true,
                          validator: true,
                        ),
                        const SizedBox(height: 30),
                        ButtonRoundedText(
                          content: "Connexion",
                          callback: submitLogin,
                          backgroundColor: themeData.primaryColor,
                          textColor: Colors.white,
                          isActive: isLoading,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, '/forgot-password'),
                    child: Text(
                      'As-tu oublié ton mot de passe ?',
                      style: TextStyle(
                        color: themeData.primaryColor,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
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
